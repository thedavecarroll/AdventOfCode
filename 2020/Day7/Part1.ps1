#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

$Rules = Get-Content -Path $FilePath
function Get-CanContain {
    param($BagColor)
    foreach ($Rule in $Rules) {
        $ContainerBag,$InsideBags = $Rule -Split (' bags contain',2)
        if ($InsideBags -match 'no other') {
            continue
        }
        $AllBags = [regex]::Matches($InsideBags,'\d+ (?<Color>\w+\s\w+)').Groups.Where{$_.Success -and $_.Name -eq 'Color'}.Value
        if ($AllBags -contains $BagColor) {
            $ContainerBag
            Get-CanContain -BagColor $ContainerBag
        }
    }
}

$CanContain = Get-CanContain -BagColor 'shiny gold' | Sort-Object -Unique
'{0} bags can contain a shiny gold bag' -f $CanContain.Count