[CmdletBinding()]
param([switch]$UseSampleData)
function Get-DataSet {
    param([switch]$UseSampleData)
    $DataFile = $UseSampleData.IsPresent ? '..\PuzzleInput\day4_sample.txt' : '..\PuzzleInput\day4.txt'
    Get-Content -Path $DataFile
}

$SampleData = @{}
if ($UseSampleData.IsPresent) {
    $SampleData.Add('UseSampleData',$true)
}
$AssignmentPairs = Get-DataSet @SampleData

[int]$Contained = $ElfOneStart = $ElfOneEnd = $ElfTwoStart = $ElfTwoEnd = 0
foreach ($Pair in $AssignmentPairs) {
    $ElfOne,$ElfTwo = $Pair.Split(',')
    $ElfOneStart,$ElfOneEnd,$ElfTwoStart,$ElfTwoEnd = $ElfOne.Split('-') + $ElfTwo.Split('-')
    if ($ElfOneStart -ge $ElfTwoStart -and $ElfOneEnd -le $ElfTwoEnd) {
        $Contained++
    } elseif ($ElfTwoStart -ge $ElfOneStart -and $ElfTwoEnd -le $ElfOneEnd) {
        $Contained++
    }
}
'Assignment pairs contained in the other: {0}' -f $Contained

[int]$Overlap = $ElfOneStart = $ElfOneEnd = $ElfTwoStart = $ElfTwoEnd = 0
foreach ($Pair in $AssignmentPairs) {
    $ElfOne,$ElfTwo = $Pair.Split(',')
    $ElfOneStart,$ElfOneEnd,$ElfTwoStart,$ElfTwoEnd = $ElfOne.Split('-') + $ElfTwo.Split('-')
    if ($ElfOneStart -in $ElfTwoStart..$ElfTwoEnd) {
        $Overlap++
    } elseif ($ElfOneEnd -in $ElfTwoStart..$ElfTwoEnd) {
        $Overlap++
    } elseif ($ElfTwoStart -in $ElfOneStart..$ElfOneEnd) {
        $Overlap++
    } elseif ($ElfTwoEnd -in $ElfOneEnd..$ElfOneEnd) {
        $Overlap++
    }
}
'Assignment pairs with overlap: {0}' -f $Overlap

function Find-Overlap {
    param(
        [long]$FirstStart,[long]$FirstEnd,
        [long]$SecondStart,[long]$SecondEnd
    )
    [Math]::Max(0,[Math]::Min($FirstEnd,$SecondEnd) - [Math]::Max($FirstStart,$SecondStart) + 1)
}

[long]$Overlap = $ElfOneStart = $ElfOneEnd = $ElfTwoStart = $ElfTwoEnd = 0
foreach ($Pair in $AssignmentPairs) {
    $ElfOne,$ElfTwo = $Pair.Split(',')
    $ElfOneStart,$ElfOneEnd,$ElfTwoStart,$ElfTwoEnd = $ElfOne.Split('-') + $ElfTwo.Split('-')
    if (Find-Overlap $ElfOneStart $ElfOneEnd $ElfTwoStart $ElfTwoEnd) {
        $Overlap++
    }
}
'Using [Math]. Assignment pairs with overlap: {0}' -f $Overlap