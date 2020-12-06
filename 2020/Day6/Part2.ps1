#$FilePath = '.\sample.txt'
$FilePath = '.\input.txt'

$CustomsQuestions = (Get-Content -Path $FilePath -Raw) -Split ([System.Environment]::NewLine * 2)

$AnsweredByAll = foreach ($Group in $CustomsQuestions) {
    $PersonsPerGroup = $Group.Split([System.Environment]::NewLine).Count
    $GroupMatches = $Group | Select-String -Pattern '[a-z]' -AllMatches
    $Responses = $GroupMatches.Matches | Group-Object -Property Value
    foreach ($Response in $Responses) {
        if ($Response.Count -eq $PersonsPerGroup) {
            1
        }
    }
}

($AnsweredByAll | Measure-Object -Sum).Sum