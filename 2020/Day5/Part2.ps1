#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'
$BoardingPasses = Get-Content -Path $FilePath

$AllBoardingPasses = foreach ($Pass in $BoardingPasses) {
    $SeatRow = $Pass.Substring(0,7).ToCharArray()
    $SeatColumn = $Pass.Substring(7,3).ToCharArray()

    $Row = 0..127
    foreach ($Section in $SeatRow) {
        switch ($Section) {
            F {
                $Row = $Row | Select-Object -First ([math]::Ceiling($Row.Count/2))
            }
            B {
                $Row = $Row | Select-Object -Last ([math]::Ceiling($Row.Count/2))
            }
        }
    }

    $Column = 0..7
    foreach ($Section in $SeatColumn) {
        switch ($Section) {
            L {
                $Column = $Column | Select-Object -First ([math]::Ceiling($Column.Count/2))
            }
            R {
                $Column = $Column | Select-Object -Last ([math]::Ceiling($Column.Count/2))
            }
        }
    }

    $SeatID = $Row * 8 + $Column

    #'{0}: row {1}, column {2}, seat ID {3}' -f $Pass,$Row,$Column,$SeatID

    [PSCustomObject]@{
        BoardingPass = $Pass
        Row = $Row
        Column = $Column
        SeatID = $SeatID
    }

}

[int]$MyRow = ($AllBoardingPasses | Group-Object -Property Row | Where-Object { $_.Count -ne 8 })[1].Name

$MyRowSeats = $AllBoardingPasses.Where{$_.Row -eq $MyRow} | Sort-Object -Property Column
$MyRowColumn = for ($c=0;$c -le 7;$c++) {
    if ($MyRowSeats[$c].Column -ne $c) {
        $c
        break
    }
}

$MyRow * 8 + $MyRowColumn
