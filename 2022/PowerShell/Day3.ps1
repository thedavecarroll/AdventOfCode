function Get-DataSet {
    param([switch]$UseSampleData)
    $DataFile = $UseSampleData.IsPresent ? '..\PuzzleInput\day3_sample.txt' : '..\PuzzleInput\day3.txt'
    Get-Content -Path $DataFile
}
$Rucksacks = Get-DataSet
$Priority = [char]'a'..[char]'z' + [char]'A'..[char]'Z'


$Sum = 0
foreach ($Sack in $Rucksacks) {
    $CompartmentItemCount = $Sack.Length / 2
    $Compartment1 = $Sack.ToCharArray() | Select-Object -First $CompartmentItemCount
    $Compartment2 = $Sack.ToCharArray() | Select-Object -Last $CompartmentItemCount
    $CommonItem = (Compare-Object -ReferenceObject $Compartment1 -DifferenceObject $Compartment2 -IncludeEqual | Where-Object SideIndicator -eq '==').InputObject[0]
    $Sum += $Priority.IndexOf([char]$CommonItem) + 1
}
'Part 1:'
'Sum of priorites is : {0}' -f $Sum
''

$Sum = 0
for ($i=0;$i -lt $Rucksacks.Count;$i += 3) {
    $Elf1 = $Rucksacks[$i].ToCharArray()
    $Elf2 = $Rucksacks[$i+1].ToCharArray()
    $Elf3 = $Rucksacks[$i+2].ToCharArray()
    $CompareBadge = (Compare-Object -ReferenceObject $Elf1 -DifferenceObject $Elf2 -IncludeEqual | Where-Object SideIndicator -eq '==').InputObject
    $CompareBadge = (Compare-Object -ReferenceObject $CompareBadge -DifferenceObject $Elf3 -IncludeEqual | Where-Object SideIndicator -eq '==').InputObject[0]
    $Sum += $Priority.IndexOf([char]$CompareBadge) + 1
}
'Part 2:'
'Sum of priorites is : {0}' -f $Sum
