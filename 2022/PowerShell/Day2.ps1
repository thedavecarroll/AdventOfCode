function Get-DataSet {
    param([switch]$UseSampleData)
    $DataFile = $UseSampleData.IsPresent ? '..\PuzzleInput\day2_sample.txt' : '..\PuzzleInput\day2.txt'
    Get-Content -Path $DataFile
}

function Get-RoundScore {
    [CmdletBinding()]
    param(
        [string]$Round,
        [switch]$PlayResult
    )
    $Matrix = @{
        Rock = @{
            Symbols = 'A','X'
            Beats = 'Scissors'
            Score = 1
        }
        Paper = @{
            Symbols = 'B','Y'
            Beats = 'Rock'
            Score = 2
        }
        Scissors = @{
            Symbols = 'C','Z'
            Beats = 'Paper'
            Score = 3
        }
    }
    $Opponent,$Player = $Round.Split(' ')
    $OpponentHand = $Matrix.GetEnumerator() | Where-Object { $_.Value.Symbols -contains $Opponent}

    if ($PlayResult.IsPresent) {
        $PlayerHand = switch ($Player) {
            # Lose
            'X' { $Matrix.GetEnumerator() | Where-Object { $_.Key -eq $OpponentHand.Value.Beats } ; break }
            # Draw
            'Y' { $OpponentHand; break }
            # Win
            'Z' { $Matrix.GetEnumerator() | Where-Object { $_.Value.Beats -eq $OpponentHand.Key}; break}
        }
    } else {
        $PlayerHand = $Matrix.GetEnumerator() | Where-Object { $_.Value.Symbols -contains $Player}
    }

    # Score
    if ($OpponentHand.Key -eq $PlayerHand.Key) {
        3 + $PlayerHand.Value.Score # Draw
    } elseif ($PlayerHand.Value.Beats -eq $OpponentHand.Key) {
        6 + $PlayerHand.Value.Score # Player Wins
    } elseif ($OpponentHand.Value.Beats -eq $PlayerHand.Key) {
        0 + $PlayerHand.Value.Score # Player loses
    }
}

$RPSRounds = Get-DataSet

$Scores = foreach ($Round in $RPSRounds) {
    Get-RoundScore -Round $Round
}
$TotalScore = ($Scores | Measure-Object -Sum).Sum
'Part 1:'
'Total score is : {0}' -f $TotalScore
''

$Scores = foreach ($Round in $RPSRounds) {
    Get-RoundScore -Round $Round -PlayResult
}
'Part 2:'
$TotalScore = ($Scores | Measure-Object -Sum).Sum
'Total score is : {0}' -f $TotalScore