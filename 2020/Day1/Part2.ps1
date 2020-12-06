$Entries = Get-Content -Path .\input.txt | ForEach-Object { [int]$_}

:first
for ($Num1 = 0;$Num1 -le $Entries.Count; $Num1++) {
    :second
    for ($Num2 = 0;$Num2 -le $Entries.Count; $Num2++) {
        :third
        for ($Num3 = 0;$Num3 -le $Entries.Count; $Num3++) {
            if (($Entries[$Num1] + $Entries[$Num2] + $Entries[$Num3]) -eq 2020) {
                '{0} + {1} + {2} = 2020' -f $Entries[$Num1],$Entries[$Num2],$Entries[$Num3]
                '{0} x {1} x {2} = {3}' -f $Entries[$Num1],$Entries[$Num2],$Entries[$Num3],($Entries[$Num1] * $Entries[$Num2] * $Entries[$Num3])
                break first
            }
        }
    }
}