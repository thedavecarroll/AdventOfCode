$Passports = (Get-Content -Path .\input.txt -Raw) -Split ([System.Environment]::NewLine * 2)
$PassportMatch = @()
$PassportMatch += 'byr:(?<BirthYear>\S+)'
$PassportMatch += 'iyr:(?<IssueYear>\S+)'
$PassportMatch += 'eyr:(?<ExpirationYear>\S+)'
$PassportMatch += 'hgt:(?<Height>\S+)'
$PassportMatch += 'hcl:(?<HairColor>\S+)'
$PassportMatch += 'ecl:(?<EyeColor>\S+)'
$PassportMatch += 'pid:(?<PassportId>\S+)'
$PassportMatch += 'cid:(?<CountryId>\S+)'

$InvalidPassport = 0
$ValidPassport = 0
foreach ($Passport in $Passports) {
    $PassportFields = [regex]::Matches($Passport,($PassportMatch -join '|'))
    if ($PassportFields.Groups.Where{$_.Name -ne 0 -and $_.Success}.Count -eq 7) {
        if ($PassportFields.Groups.Where{$_.Name -eq 'CountryId' -and $_.Success}.Count -eq 0) {
            $ValidPassport++
        } else {
            $InvalidPassport++
        }
    } elseif  ($PassportFields.Groups.Where{$_.Name -ne 0 -and $_.Success}.Count -eq 8) {
        $ValidPassport++
    } else {
        $InvalidPassport++
    }
    #$PassportFields.Groups.Where{$_.Name -ne 0 -and $_.Success}
    #'-' * 40
}

'{0} Valid Passports' -f $ValidPassport
'{0} Invalid Passports' -f $InvalidPassport
