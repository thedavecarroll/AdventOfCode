$Entries = Get-Content -Path .\input.txt
$ValidPassword = [System.Collections.Generic.List[string]]::new()
foreach ($Entry in $Entries) {
    $Min,$Max,$Letter,$Password = $Entry -Split ('\W',4)
    $MatchCount = [regex]::Matches($Password.Trim(),$Letter)
    if ($MatchCount.Count -ge $Min -and $MatchCount.Count -le $Max) {
        $ValidPassword.Add($Password.Trim())
    }
}
'Valid passwords found {0}' -f $ValidPassword.Count
