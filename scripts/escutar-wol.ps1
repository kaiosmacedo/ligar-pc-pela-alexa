# Escuta os pacotes mágicos que chegam na placa de rede, por baixo do firewall, e diz de onde vêm e para onde vão.
# Precisa de administrador (pktmon, Windows 10 2004 ou mais novo). Rode com o PC ligado e mande o pacote (app ou Alexa) enquanto ele escuta.
# Uso:     Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "<este arquivo>"'
# Conferir uma captura já feita, sem administrador:  escutar-wol.ps1 -Captura <arquivo .txt do pktmon>
param(
    [int[]]$Porta = @(9, 7),   # 9 é a dos apps; a 7 também é usada por alguns emissores
    [int]$Segundos = 60,
    [string]$Saida = (Join-Path $env:PUBLIC 'Documents\escutar-wol.txt'),
    [string]$Captura
)
$capturaDada = $PSBoundParameters.ContainsKey('Captura')
$falha = $null

if (-not $capturaDada) {
    $etl = [IO.Path]::ChangeExtension($Saida, '.etl')
    $Captura = [IO.Path]::ChangeExtension($Saida, '.captura.txt')
    Remove-Item $etl, $Captura -ErrorAction SilentlyContinue
    pktmon stop 2>&1 | Out-Null
    pktmon filter remove 2>&1 | Out-Null
    foreach ($p in $Porta) { pktmon filter add "WOL$p" -t UDP -p $p 2>&1 | Out-Null }
    $msg = pktmon start -c --comp nics --pkt-size 0 -f $etl 2>&1
    if ($LASTEXITCODE -ne 0) {
        $falha = "A escuta não começou. Rode como administrador, no Windows 10 2004 ou mais novo. pktmon disse: $($msg -join ' ')"
    } else {
        "Escutando as portas $($Porta -join ' e ') por $Segundos segundos. Mande o pacote agora, 2 ou 3 vezes."
        foreach ($s in $Segundos..1) { Write-Progress -Activity 'Escutando o pacote mágico' -Status "$s s" -PercentComplete (100 * ($Segundos - $s) / $Segundos); Start-Sleep 1 }
        Write-Progress -Activity 'Escutando o pacote mágico' -Completed
        pktmon stop 2>&1 | Out-Null
        pktmon etl2txt $etl -o $Captura 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) { $falha = 'A escuta rodou, mas o pktmon não converteu a captura.' }
    }
    pktmon filter remove 2>&1 | Out-Null
}
if (-not $falha -and -not (Test-Path $Captura)) { $falha = "Não achei o arquivo de captura ($Captura)." }

$r = @()
if ($falha) {
    $r += "A escuta não rodou: $falha"
    $r += 'Isto NÃO quer dizer que o pacote não chegou. Corrija e rode de novo.'
} else {
    # O pktmon registra o mesmo pacote em mais de um ponto da placa: a contagem é de registros, não de pacotes.
    $rx = "(\d+\.\d+\.\d+\.\d+)\.\d+ > (\d+\.\d+\.\d+\.\d+)\.($($Porta -join '|'))\b: UDP"
    $pares = @(Select-String -Path $Captura -Pattern $rx | ForEach-Object { $g = $_.Matches[0].Groups; '{0} -> {1} (porta {2})' -f $g[1].Value, $g[2].Value, $g[3].Value } | Group-Object)
    if (-not $pares.Count) {
        $r += "Nada chegou nas portas $($Porta -join ' e '). O pacote não está alcançando o PC."
        $r += 'Confira: celular no Wi-Fi de casa (não no 4G nem na rede de visitantes), modo LAN no app, porta e MAC da placa com cabo. Com a Alexa: o Echo na mesma rede do PC.'
    } else {
        $r += 'Chegou. Origem -> destino (registros):'
        $r += $pares | ForEach-Object { '  ' + $_.Name + '  ' + $_.Count }
        # Destino igual a um IP do próprio PC = envio direto; qualquer outro = para a rede inteira.
        $meus = @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | ForEach-Object { $_.IPAddress })
        $destinos = @($pares | ForEach-Object { ($_.Name -split ' -> ')[1].Split(' ')[0] } | Select-Object -Unique)
        $diretos = @($destinos | Where-Object { $meus -contains $_ })
        if ($diretos.Count -lt $destinos.Count) {
            $r += 'Há envio para a rede inteira (broadcast). Certo: é assim que chega no PC suspenso ou desligado.'
        } else {
            $r += "O envio vai direto para o IP do PC ($($diretos -join ', ')). Com o PC ligado chega, mas suspenso ou desligado costuma se perder."
            $r += 'Troque o destino no app para o broadcast que o diagnóstico mostrou (numa rede de casa comum, o IP do PC com .255 no fim).'
        }
    }
}
$r | Set-Content -Path $Saida -Encoding UTF8
''
$r
''
"Resultado salvo em $Saida"
if (-not $capturaDada) { Read-Host 'Enter para fechar' | Out-Null }
