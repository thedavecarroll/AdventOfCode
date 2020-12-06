#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

$BoardingPasses = Get-Content -Path $FilePath
$SeatIDs = @()

foreach ($Pass in $BoardingPasses) {
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

    $SeatIDs += $SeatID
}

'Highest SeatID {0}' -f ($SeatIDs | Measure-Object -Maximum).Maximum
