#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

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
    'Program terminated successfully. Accumulator: {0}' -f $Accumulator
}
$Output = Invoke-Program -ProgramCode $ProgramCode

$InstructionChangedOnLine = @()
$Attempts = 0

while ($Output -match 'CodeBreak') {

    $UpdatedCode = $ProgramCode.Clone()

    for ($CodeLine=0;$CodeLine -le $UpdatedCode.Count;$CodeLine++) {
        if ($CodeLine -notin $InstructionChangedOnLine) {
            if ($UpdatedCode[$CodeLine] -match 'nop') {
                $UpdatedCode[$CodeLine] = $UpdatedCode[$CodeLine] -replace 'nop','jmp'
                $InstructionChangedOnLine += $CodeLine
                $Instruction = 'nop > jmp'
                break
            } elseif ($UpdatedCode[$CodeLine] -match 'jmp') {
                $UpdatedCode[$CodeLine] = $UpdatedCode[$CodeLine] -replace 'jmp','nop'
                $InstructionChangedOnLine += $CodeLine
                $Instruction = 'jmp > nop'
                break
            }
        }
    }

    $Output = Invoke-Program -ProgramCode $UpdatedCode
    $Attempts++
}

$Output
if ($Attempts -gt 0) {
    'Found program corruption after {0} attempts. Changed original code on line {1} from {2}.' -f $Attempts,(($InstructionChangedOnLine | Select-Object -Last 1)+1),$Instruction
    #$UpdatedCode
}
