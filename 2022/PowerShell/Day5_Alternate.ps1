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

function Get-StackData {
    param ([string[]]$DataSet)

    $Regex = [Regex]::new('\[(\w+)\]')
    $Columns = foreach ($Line in $DataSet) {
        foreach ($Match in $Regex.Matches($Line)) {
            $Match | Select-Object Index,Value
        }
    }

    $ColumnIndices = $Columns.Index | Sort-Object -Unique
    $ColumnCount = $ColumnIndices.Count

    $Stacks = [ordered]@{}
    for ($i=0; $i -lt $ColumnCount;$i++) {
        $Index = $ColumnIndices[$i]
        $ColumnValue = $Columns.Where{$_.Index -eq $Index}.Value | ForEach-Object {
            $_.Replace('[','').Replace(']','')
        }
        [array]::Reverse($ColumnValue)
        $Stacks.Add($i,[System.Collections.Stack]::new(@($ColumnValue)))
    }
    $Stacks
}

$SampleData = @{}
if ($UseSampleData.IsPresent) {
    $SampleData.Add('UseSampleData',$true)
}

$CrateInfo = Get-DataSet @SampleData
$CrateMoves = Get-CrateMoves -DataSet $CrateInfo
$ColumnData = Get-StackData -DataSet $CrateInfo
foreach ($Move in $CrateMoves) {
    for ($MoveCount = 1; $MoveCount -le $Move.Move; $MoveCount++) {
        $TopCrate = $ColumnData.Item($Move.From - 1).Pop()
        $ColumnData.Item($Move.To - 1).Push($TopCrate)
    }
}
$TopOfStacks = foreach ($Key in $ColumnData.Keys) {
    $ColumnData.Item($Key).Pop()
}
'Part 1: {0}' -f ($TopOfStacks -join '')

$ColumnData = Get-StackData -DataSet $CrateInfo
foreach ($Move in $CrateMoves) {
    $TopCrates = for ($MoveCount = 1; $MoveCount -le $Move.Move; $MoveCount++) {
        $ColumnData.Item($Move.From - 1).Pop()
    }
    [Array]::Reverse($TopCrates)
    foreach ($Crate in $TopCrates) {
        $ColumnData.Item($Move.To - 1).Push($Crate)
    }
}
$TopOfStacks = foreach ($Key in $ColumnData.Keys) {
    $ColumnData.Item($Key).Pop()
}
'Part 2: {0}' -f ($TopOfStacks -join '')