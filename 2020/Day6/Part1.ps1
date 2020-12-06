#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

$CustomsQuestions = (Get-Content -Path $FilePath -Raw) -Split ([System.Environment]::NewLine * 2)

$AnswersByGroup = foreach ($Group in $CustomsQuestions) {
    $GroupMatches = $Group | Select-String -Pattern '[a-z]' -AllMatches
    ($GroupMatches.Matches | Group-Object -Property Value).Name.Count
}

($AnswersByGroup | Measure-Object -Sum).Sum