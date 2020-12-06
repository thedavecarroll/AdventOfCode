$Entries = Get-Content -Path .\input.txt | ForEach-Object { [int]$_}

:first
for ($Num1 = 0;$Num1 -le $Entries.Count; $Num1++) {
    :second
    for ($Num2 = 0;$Num2 -le $Entries.Count; $Num2++) {
        if (($Entries[$Num1] + $Entries[$Num2]) -eq 2020) {
            '{0} + {1} = 2020' -f $Entries[$Num1],$Entries[$Num2]
            '{0} x {1} = {2}' -f $Entries[$Num1],$Entries[$Num2],($Entries[$Num1] * $Entries[$Num2])
            break first
        }
    }
}