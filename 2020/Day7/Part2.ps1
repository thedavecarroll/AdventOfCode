#$FilePath = '.\part2sample.txt'
$FilePath = '.\sample.txt'
#$FilePath = '.\input.txt'

$Rules = Get-Content -Path $FilePath
$CheckedBags = @()

function Get-RequiredBagCount {
    param($BagColor)

    $RequiredBags = 0

    if ($CheckedBags -contains $BagColor) {
        continue
    }
    $ColorRule = $Rules.Where{$_ -match "^$BagColor"}
    $ContainerBag,$InsideBags = $ColorRule -Split ('bags contain',2)

    $AllBags = [regex]::Matches($InsideBags,'(?<BagCount>\d+) (?<BagColor>\w+\s\w+)')

    if ($InsideBags -match 'no other') {
        continue
    }

    foreach ($Bag in $AllBags) {
        [int]$BagCount = $Bag.Groups.Where{$_.Name -eq 'BagCount'}.Value
        $Name = $Bag.Groups.Where{$_.Name -eq 'BagColor'}.Value
        $CheckedBags += $Name
        $RequiredBags += $BagCount * (Get-RequiredBagCount -BagColor $Name)
    }
}

Get-RequiredBagCount -BagColor 'shiny gold' # | Measure-Object -Sum

#'{0} bags can contain a shiny gold bag' -f $CanContain.Count
