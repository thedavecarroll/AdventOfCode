$FilePath = '.\samplepart2.txt'
#$FilePath = '.\input.txt'

$BusSchedule = Get-Content -Path $FilePath

#https://www.reddit.com/r/adventofcode/comments/kcb3bb/2020_day_13_part_2_can_anyone_tell_my_why_this/
#https://github.com/dfinke/powershell-algorithms/tree/master/src/algorithms/math
function leastCommonMultiple {
    [Alias('lcm')]
    [cmdletbinding()]
    param([double]$a, [double]$b)

    function euclideanAlgorithm($originalA, $originalB) {
        $a = [Math]::Abs($originalA)
        $b = [Math]::Abs($originalB)

        if ($a -eq 0 -and $b -eq 0) {
            return $null
        }

        if ($a -eq 0 -and $b -ne 0) {
            return $b
        }

        if ($a -ne 0 -and $b -eq 0) {
            return $a
        }

        # Normally we need to do subtraction ($a - $b) but to prevent
        # recursion occurs to often we may shorten subtraction to ($a % $b).
        # Since ($a % $b) normally means that we've subtracted $b from a
        # many times until the difference became less then a.

        if ($a -gt $b) {
            return euclideanAlgorithm ($a % $b) $b
        }

        return euclideanAlgorithm ($b % $a) $a
    }

    if ($a -eq 0 -and $b -eq 0) {
        return 0
    }

    [Math]::Abs($a * $b) / (euclideanAlgorithm $a $b)
}

function Get-DepartureTime {
    param([string]$Schedule)

    $Buses = $Schedule -Split ','
    $BusDiff = [ordered]@{}
    $Step = 1
    foreach ($Bus in $Buses) {
        if ($Bus -eq 'x') {
            $Step++
            continue
        } else {
            $BusDiff.Add($Bus,$Step)
            $Step = 1
        }
    }

    do {

    } while ($TimeMatch)

    $BusDiff
}

foreach ($Schedule in $BusSchedule) {
    Get-DepartureTime -Schedule $Schedule
    '-' * 40
}

