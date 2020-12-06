$Inputfile = '.\input.txt'
#$Inputfile = '.\sample.txt'
$Map = Get-Content -Path $Inputfile

$Trees = 0
$Location = 0
foreach ($Line in $Map) {
    if ($Location -ge $Line.Length) {
        $HorizontalLine = $Line * ([Math]::Ceiling($Location/$Line.Length) + 1)
    } else {
        $HorizontalLine = $Line * 2
    }
    $TreeLocation = [regex]::Matches($HorizontalLine,'#').Index
    if ($Location -in $TreeLocation) {
        $HorizontalLine.Remove($Location,1).Insert($Location,'X')
        $Trees++
    } else {
        $HorizontalLine.Remove($Location,1).Insert($Location,'O')
    }
    $Location += 3
}
'{0} trees encountered' -f $Trees