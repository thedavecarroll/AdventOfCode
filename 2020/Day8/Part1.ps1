$FilePath = '.\sample.txt'
#$FilePath = '.\input.txt'

$ProgramCode = Get-Content -Path $FilePath

function Invoke-Program {
    param($ProgramCode)

    $Accumulator = 0
    $CodeLinesExecuted = @()

    :program
    for ($CodeLocation = 0; $CodeLocation -lt $ProgramCode.Count) {
        $null = $ProgramCode[$CodeLocation] -match '(?<Instuction>\w{3}) (?<Operation>\W)(?<Value>\d+)'

        switch ($Matches.Instuction) {
            'nop' {
                $CodeLinesExecuted += $CodeLocation
                $CodeLocation++
            }
            'acc' {
                if ($Matches.Operation -eq '+') {
                    $Accumulator += $Matches.Value
                } else {
                    $Accumulator -= $Matches.Value
                }
                $CodeLinesExecuted += $CodeLocation
                $CodeLocation++
            }
            'jmp' {
                if ($Matches.Operation -eq '+') {
                    $NewLocation = $CodeLocation + $Matches.Value
                } else {
                    $NewLocation = $CodeLocation - $Matches.Value
                }
                if ($NewLocation -notin $CodeLinesExecuted) {
                    $CodeLinesExecuted += $CodeLocation
                    $CodeLocation = $NewLocation
                } else {
                    'CodeBreak - infinite loop found. Accumulator: {0}' -f $Accumulator
                    break program
                }
            }
        }
    }
}

Invoke-Program -ProgramCode $ProgramCode