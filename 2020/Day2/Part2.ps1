$Entries = Get-Content -Path .\input.txt
$ValidPassword = [System.Collections.Generic.List[string]]::new()
foreach ($Entry in $Entries) {
    $Min,$Max,$Letter,$Password = $Entry -Split ('\W',4)
    $MatchCount = [regex]::Matches($Password.Trim(),$Letter)
    $PositionCount = 0
    if ($MatchCount.Count) {
        if ($MatchCount.Where{$_.Index + 1 -eq $Min}) {
            $PositionCount++
        }
        if ($MatchCount.Where{$_.Index + 1 -eq $Max}) {
            $PositionCount++
        }
        if ($PositionCount -eq 1) {
            $ValidPassword.Add($Password.Trim())
        }
    }
}
'Valid passwords found {0}' -f $ValidPassword.Count