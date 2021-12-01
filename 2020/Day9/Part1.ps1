$FilePath = '.\sample.txt'
#$FilePath = '.\input.txt'

$DataStream = Get-Content -Path $FilePath

function Invoke-XMASDecryption {
    param(
        $PreambleNumber,
        $DataStream
    )

    $UsedNumbers = @()

    $Preable = $DataStream[0..($PreambleNumber - 1)]

    for ($i=$Preable.Clone();$i -lt $DataStream.Count;$i++) {

    }


}