# Diagnóstico para ligar o PC pela rede (Wake-on-LAN) e entrar de longe.
# Só lê, não muda nada e não precisa de administrador. Funciona no Windows PowerShell 5.1 e no PowerShell 7.
# Uso: powershell -NoProfile -ExecutionPolicy Bypass -File diagnostico.ps1
$ErrorActionPreference = 'SilentlyContinue'
$avisos = New-Object System.Collections.Generic.List[string]

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$bb = Get-CimInstance Win32_BaseBoard
$bios = Get-CimInstance Win32_BIOS
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$notebook = $cs.PCSystemType -eq 2

'== Computador'
"Windows     : $($os.Caption) (build $($os.BuildNumber))"
"Tipo        : " + $(if ($notebook) { 'notebook' } else { 'desktop' })
"Placa-mãe   : $($bb.Manufacturer) $($bb.Product)"
"BIOS        : $($bios.Manufacturer) $($bios.SMBIOSBIOSVersion)"
"Processador : $($cpu.Name.Trim())"
"Último boot : $($os.LastBootUpTime)"
if ($notebook) { $avisos.Add('Notebook: muitos só ligam pela rede na tomada e com cabo, e vários não ligam a partir do desligado. Teste antes de prometer.') }

''
'== Placas de rede físicas'
$nics = @(Get-NetAdapter -Physical | Sort-Object Status, Name)
foreach ($n in $nics) { '{0,-26} {1,-14} {2,-12} {3,-10} MAC {4}' -f $n.Name, $n.PhysicalMediaType, $n.Status, $n.LinkSpeed, $n.MacAddress }
$comGw = @(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | ForEach-Object { $_.InterfaceIndex })
$comCabo = @($nics | Where-Object { $_.PhysicalMediaType -eq '802.3' -and $_.Status -eq 'Up' })
# A placa com cabo que leva ao roteador vem primeiro.
$cabo = $comCabo | Sort-Object { -not ($comGw -contains $_.ifIndex) } | Select-Object -First 1

if (-not $cabo) {
    if ($notebook) { $avisos.Add('Nenhuma placa com cabo conectada. Por Wi-Fi o notebook quase nunca liga a partir do desligado. Veja guias/caminhos.md: alguns notebooks ligam quando a energia volta (opção da BIOS); adaptador de rede USB raramente liga o PC.') }
    else { $avisos.Add('Nenhuma placa com cabo conectada. Por Wi-Fi o PC quase nunca liga a partir do desligado: o caminho é ligar um cabo de rede ou usar a tomada inteligente.') }
} else {
    if ($comCabo.Count -gt 1) { $avisos.Add("Há $($comCabo.Count) placas com cabo conectadas. Usei '$($cabo.Name)', a que leva ao roteador. Confira se é a certa.") }
    ''
    "== Placa com cabo: $($cabo.InterfaceDescription)"
    "MAC (vai no app e na skill da Alexa): $($cabo.MacAddress)   ou   $($cabo.MacAddress -replace '-', ':')"
    "Driver      : $($cabo.DriverProvider) $($cabo.DriverVersion) de $($cabo.DriverDate)"
    "Velocidade  : $($cabo.LinkSpeed)"
    if ($cabo.LinkSpeed -eq '100 Mbps' -and $cabo.InterfaceDescription -match 'Gb|2\.5|2,5|Gigabit|I2\d\d|Killer|E3\d00') { $avisos.Add('A placa é gigabit, mas está a 100 Mbps: costuma ser cabo ruim. Não impede ligar pela rede, mas vale trocar.') }

    # O IP pode estar noutra interface (ex.: switch virtual do Hyper-V); nesse caso, usa a que tem o roteador.
    $ip = Get-NetIPAddress -InterfaceIndex $cabo.ifIndex -AddressFamily IPv4 | Where-Object PrefixOrigin -ne 'WellKnown' | Select-Object -First 1
    if (-not $ip -and $comGw.Count) { $ip = Get-NetIPAddress -InterfaceIndex $comGw[0] -AddressFamily IPv4 | Select-Object -First 1 }
    if ($ip) {
        # ponytail: broadcast calculado octeto a octeto pelo tamanho da máscara.
        $p = [int]$ip.PrefixLength
        $bc = foreach ($o in ([Net.IPAddress]$ip.IPAddress).GetAddressBytes()) {
            $m = if ($p -ge 8) { 255 } elseif ($p -le 0) { 0 } else { 256 - [int][math]::Pow(2, 8 - $p) }
            $p -= 8
            $o -bor (255 - $m)
        }
        $gw = (Get-NetIPConfiguration -InterfaceIndex $ip.InterfaceIndex).IPv4DefaultGateway.NextHop
        "IP          : $($ip.IPAddress)/$($ip.PrefixLength) · roteador $gw" + $(if ($ip.InterfaceIndex -ne $cabo.ifIndex) { " (na interface '$($ip.InterfaceAlias)')" } else { '' })
        "Broadcast   : $($bc -join '.')   (é este endereço que vai no app de teste, não o IP do PC)"
    } else {
        $avisos.Add('A placa com cabo está sem IPv4. No app de teste, use o broadcast 255.255.255.255 e confira a rede do PC.')
    }

    ''
    '-- Opções da placa (aba Avançado)'
    $props = @(Get-NetAdapterAdvancedProperty -Name $cabo.Name | Where-Object { $_.RegistryKeyword -match 'Wake|WoL|PME|EEE|Green|PowerSaving|GigaLite|S5' })
    foreach ($a in $props) { '  {0} = {1}   [{2}]' -f $a.DisplayName, $a.DisplayValue, $a.RegistryKeyword }
    foreach ($k in '*WakeOnMagicPacket', 'S5WakeOnLan', 'EnablePME') {
        $a = $props | Where-Object RegistryKeyword -eq $k
        if ($a -and "$($a.RegistryValue)" -ne '1') { $avisos.Add("Placa: '$($a.DisplayName)' está desligado. Ligue na aba Avançado da placa (ver guias/windows.md).") }
    }

    $armadas = @(powercfg /devicequery wake_armed | ForEach-Object { $_.Trim() })
    $pode = $armadas -contains $cabo.InterfaceDescription
    "Pode acordar o PC (Gerenciamento de Energia): " + $(if ($pode) { 'sim' } else { 'NÃO' })
    if (-not $pode) { $avisos.Add('Placa, aba Gerenciamento de Energia: marque "Permitir que este dispositivo acorde o computador" e "Somente permitir um pacote Magic para ativar o computador".') }
}

''
'== Windows'
$pw = Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'
$hb = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power').HiberbootEnabled
if ($pw.HibernateEnabled -eq 0) { 'Inicialização rápida: indisponível (a hibernação está desligada); não atrapalha' }
elseif ($hb -eq 0) { 'Inicialização rápida: desligada' }
else {
    'Inicialização rápida: LIGADA'
    $avisos.Add('A inicialização rápida está ligada: ela costuma impedir que o PC ligue pela rede a partir do desligado.')
}
'-- Estados de suspensão disponíveis'
$estados = @(powercfg /a)
$i = 1
while ($i -lt $estados.Count -and $estados[$i].Trim()) { $estados[$i]; $i++ }

''
'== Acesso remoto'
$svc = @(Get-CimInstance Win32_Service | Where-Object { $_.Name -match 'AnyDesk|RustDesk|TeamViewer|Parsec|chromoting|Tailscale|ZeroTier' })
if ($svc.Count) { foreach ($s in $svc) { '{0,-34} início {1,-8} {2}' -f $s.DisplayName, $s.StartMode, $s.State } } else { 'Nenhum programa de acesso remoto instalado como serviço.' }
$anySvc = $svc | Where-Object Name -match 'AnyDesk'
$conf = 'C:\ProgramData\AnyDesk\service.conf'
if ($anySvc -and (Test-Path $conf)) { 'AnyDesk, senha de acesso sem ninguém na frente: ' + $(if (Select-String -Path $conf -Pattern '^ad\.anynet\.pwd_hash=' -Quiet) { 'configurada' } else { 'NÃO configurada' }) }
if (-not $anySvc -and (Get-Process AnyDesk)) { $avisos.Add('O AnyDesk está aberto sem estar instalado: assim ele não funciona na tela de login. Ver guias/acesso-remoto.md.') }
$rdp = (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections
"Área de Trabalho Remota do Windows: " + $(if ($rdp -eq 0) { 'ligada' } else { 'desligada' }) + ' (só recebe conexão no Windows Pro)'

''
'== O que ajustar'
if ($avisos.Count) { $avisos | ForEach-Object { "- $_" } } else { '- Nada do lado do Windows. Falta a BIOS e os testes.' }
