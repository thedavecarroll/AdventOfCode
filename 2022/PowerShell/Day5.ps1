[CmdletBinding()]
param([switch]$UseSampleData)
function Get-DataSet {
    param([switch]$UseSampleData)
    $DataFile = $UseSampleData.IsPresent ? '..\PuzzleInput\day5_sample.txt' : '..\PuzzleInput\day5.txt'
    Get-Content -Path $DataFile
}

function  Get-CrateMoves {
    param ([string[]]$DataSet)
    $MoveRegex = '(?<Move>\d+) from (?<From>\d+) to (?<To>\d+)'
    foreach ($Line in $DataSet) {
        if ($Line -match $MoveRegex) {
            $Matches | Select-Object Move,From,To
        }
    }
}

function Get-ColumnData {
    param ([string[]]$DataSet)

    $Regex = [Regex]::new('\[(\w+)\]')
    $Columns = foreach ($Line in $DataSet) {
        foreach ($Match in $Regex.Matches($Line)) {
            $Match | Select-Object Index,Value
        }
    }

    $ColumnIndices = $Columns.Index | Sort-Object -Unique
    $ColumnCount = $ColumnIndices.Count

    $ColumnData = [ordered]@{}
    for ($i=0; $i -lt $ColumnCount;$i++) {
        $Index = $ColumnIndices[$i]
        $ColumnValue = $Columns.Where{$_.Index -eq $Index}.Value
        [array]::Reverse($ColumnValue)
        $ColumnData.Add($i,$ColumnValue)
    }
    $ColumnData
}

$SampleData = @{}
if ($UseSampleData.IsPresent) {
    $SampleData.Add('UseSampleData',$true)
}

$CrateInfo = Get-DataSet @SampleData
$CrateMoves = Get-CrateMoves -DataSet $CrateInfo

$ColumnData = Get-ColumnData -DataSet $CrateInfo
foreach ($Move in $CrateMoves) {
    $FromColumn = $Move.From - 1
    $ToColumn = $Move.To - 1
    for ($MoveCount = 1; $MoveCount -le $Move.Move; $MoveCount++) {
        [array]$FromCratesList = $ColumnData.Item($FromColumn)
        [array]$ToCratesList = $ColumnData.Item($ToColumn)
        $TopCrate = $FromCratesList | Select-Object -Last 1
        $ColumnData.Item($FromColumn) = $FromCratesList | Select-Object -SkipLast 1
        $ColumnData.Item($ToColumn) = $ToCratesList + $TopCrate
    }
}
$TopOfStacks = foreach ($Key in $ColumnData.Keys) {
    $TopCrate = $ColumnData.Item($Key) | Select-Object -Last 1
    $TopCrate.Replace('[','').Replace(']','')
}
'Part 1: {0}' -f ($TopOfStacks -join '')

$ColumnData = Get-ColumnData -DataSet $CrateInfo
foreach ($Move in $CrateMoves) {
    $FromColumn = $Move.From - 1
    $ToColumn = $Move.To - 1
    [array]$FromCratesList = $ColumnData.Item($FromColumn)
    [array]$ToCratesList = $ColumnData.Item($ToColumn)
    $TopCrates = $FromCratesList | Select-Object -Last $Move.Move
    $ColumnData.Item($FromColumn) = $FromCratesList | Select-Object -SkipLast $Move.Move
    $ColumnData.Item($ToColumn) = $ToCratesList + $TopCrates
}
$TopOfStacks = foreach ($Key in $ColumnData.Keys) {
    $TopCrate = $ColumnData.Item($Key) | Select-Object -Last 1
    $TopCrate.Replace('[','').Replace(']','')
}
'Part 2: {0}' -f ($TopOfStacks -join '')