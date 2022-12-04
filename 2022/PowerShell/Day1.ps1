function Get-DataSet {
    param([switch]$UseSampleData)
    $DataFile = $UseSampleData.IsPresent ? '..\PuzzleInput\day1_sample.txt' : '..\PuzzleInput\day1.txt'
    Get-Content -Path $DataFile
}

function Get-ElfCalories {
    param([string[]]$Data)
    $Elves = @{}
    $ElfCount = 1
    for ($i=0;$i -le $Data.Count;$i++) {
        $ElfNumber = 'Elf-{0}' -f $ElfCount
        if ($Data[$i] -ne '') {
            if (-Not $Elves.ContainsKey($ElfNumber)) {
                [int]$Elves[$ElfNumber] = $Data[$i]
            } else {
                [int]$Elves[$ElfNumber] = $Elves[$ElfNumber] + $Data[$i]
            }
        } else {
            $ElfCount++
        }
    }
    $Elves
}

$Elves = Get-ElfCalories -Data (Get-DataSet)

$MaxCalories = ($Elves.GetEnumerator() | Measure-Object -Maximum Value).Maximum
$TheElf = ($Elves.GetEnumerator() | Where-Object Value -eq $MaxCalories).Name
'Part 1:'
'{0} carries the maximum Calories with {1}' -f $TheElf,$MaxCalories
''

$Top3Elves = $Elves.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 3
$TotalCalories = ($Top3Elves | Measure-Object Value -Sum).Sum
'Part 2:'
'The 3 elves carrying the most Calories are carrying a total {0}' -f $TotalCalories
'They are: {0}' -f ($Top3Elves.Name -join ', ')