$Inputfile = '.\input.txt'
#$Inputfile = '.\sample.txt'
$Map = Get-Content -Path $Inputfile

$SlopePaths = [ordered]@{
    Path1 = [ordered]@{ Right = 1; Down = 1; Trees = 0}
    Path2 = [ordered]@{ Right = 3; Down = 1; Trees = 0}
    Path3 = [ordered]@{ Right = 5; Down = 1; Trees = 0}
    Path4 = [ordered]@{ Right = 7; Down = 1; Trees = 0}
    Path5 = [ordered]@{ Right = 1; Down = 2; Trees = 0}
}

foreach ($SlopePath in $SlopePaths.Keys) {
    $Location = 0
    for ($p=0;$p -lt $Map.Length;$p = $p + $SlopePaths[$SlopePath].Down) {
        if ($Location -ge $Map[$p].Length) {
            $HorizontalLine = $Map[$p] * ([Math]::Ceiling($Location + 1/$Map[$p].Length) + 1)
        } else {
            $HorizontalLine = $Map[$p] * 2
        }
        $TreeLocation = [regex]::Matches($HorizontalLine,'#').Index
        if ($Location -in $TreeLocation) {
            $SlopePaths[$SlopePath].Trees++
        }

        $Location += $SlopePaths[$SlopePath].Right
    }
}
$SlopePaths | ConvertTo-Json | ConvertFrom-Json
$Trees = 1
$SlopePaths.Values.Trees | ForEach-Object { $Trees *= $_ }
'Result {0}' -f $Trees