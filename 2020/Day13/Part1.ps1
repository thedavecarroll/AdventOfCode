#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

$BusSchedule = Get-Content -Path $FilePath

function Get-DepartureTime {
    param($BusSchedule)

    [int]$NextDepart = $BusSchedule[0]
    $Buses = $BusSchedule[1].Split(',').ForEach{ if ($_ -ne 'x') { $_ } }
    $BusesInService = [ordered]@{}

    foreach ($Bus in $Buses) {
        [int]$LastDepartTime = $NextDepart + ($Buses | Measure-Object -Maximum).Maximum
        $BusTimes = @()
        $WaitTime = $LastDepartTime
        $BusTimes += for ($Time = 0;$Time -lt $LastDepartTime;$Time = $Time + [int]$Bus) {
            $Time
            if ($Time -ge $NextDepart) {
                $CurrentTimeDiff = $Time - $NextDepart
                if ($WaitTime -ge $CurrentTimeDiff) {
                    $WaitTime = $CurrentTimeDiff
                }
            }
        }

        $BusesInService.Add($Bus,[ordered]@{DepartureTimes = $BusTimes;WaitTime = $WaitTime})
    }

    $BusesInService
}

$Schedule = Get-DepartureTime -BusSchedule $BusSchedule
$ShortestWaitTime = ($Schedule.GetEnumerator() | ForEach-Object { $_.value.WaitTime } | Measure-Object -Minimum).Minimum
$NextDepartingBus = $Schedule.GetEnumerator().Where{$_.value.WaitTime -eq $ShortestWaitTime }.Name

'BusId: {0}, WaitTime: {1} = {2}' -f $NextDepartingBus,$ShortestWaitTime,($NextDepartingBus * $ShortestWaitTime)

