#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

$DockData = (Get-Content -Path $FilePath -Raw ).Split('mask = ') | Select-Object -Skip 1

# https://www.powershellmagazine.com/2012/10/16/converting-numbers-to-binary-and-back/

function Get-DecimalResult {
    param(
        [ValidateLength(36,36)]
        [string]$BitMask,
        [Int64]$Number
    )

    $BitMaskArray = $BitMask.ToCharArray()
    $BitNumber = [System.Convert]::ToString($Number,2).PadLeft(36,'0').ToCharArray()
    $Result = @()
    for ($i=0;$i -lt $BitMaskArray.Count;$i++) {
        if ($BitMaskArray[$i] -ne 'X') {
            if($BitMaskArray[$i] -eq '1') {
                $Result += 1
            } else {
                $Result += 0
            }
        } else {
            $Result += $BitNumber[$i]
        }
    }
    [PSCustomObject]@{
        DecimalValue = $Number
        BitValue = $BitNumber -join ''
        BitMask = $BitMask
        BitResult = -join $Result
        DecimalResult = [System.Convert]::ToInt64((-join $Result),2)
    }
}

$MemoryAddresses = @{}

foreach ($Dataset in $DockData) {
    $BitMask,$Number = $Dataset.Split([System.Environment]::NewLine,2)

    foreach ($Address in $Number.Split([System.Environment]::NewLine)) {
        $null = $Address -match '\[(?<MemLocation>\d+)\] = (?<Decimal>\d+)'
        $Data = Get-DecimalResult -BitMask $BitMask -Number $Matches.Decimal

        if ($MemoryAddresses.ContainsKey($Matches.MemLocation)) {
            $MemoryAddresses[$Matches.MemLocation] = $Data.DecimalResult
        } else {
            $MemoryAddresses.Add($Matches.MemLocation,$Data.DecimalResult)
        }

    }

}

$MemoryAddresses
''
'Sum of all values in Memory: {0}' -f ($MemoryAddresses.Values | Measure-Object -Sum).Sum
