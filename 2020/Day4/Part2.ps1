$Inputfile = '.\input.txt'
#$Inputfile = '.\invalidpassports.txt'
#$Inputfile = '.\validpassports.txt'
$Passports = (Get-Content -Path $Inputfile -Raw) -Split ([System.Environment]::NewLine * 2)

$PassportMatch = [ordered]@{
    PassportId = 'pid:(?<PassportId>\d{9}\b)'
    CountryId = 'cid:(?<CountryId>\w+)'
    IssueYear = 'iyr:(?<IssueYear>(201[0-9]|2020))'
    ExpirationYear = 'eyr:(?<ExpirationYear>(202[0-9]|2030))'
    BirthYear = 'byr:(?<BirthYear>(19[2-9][0-9]|200[0-2]))'
    #Height = 'hgt:(?<Height>(?<HeightValue>\d{2,3})(?<HeightUnit>(cm|in)))'
    Height = 'hgt:((?<Height>(1[5-8][0-9]|19[0-3])cm|59|6[0-9]|7[0-6]in))'
    HairColor = 'hcl:(?<HairColor>#[a-f\d]{6})'
    EyeColor = 'ecl:(?<EyeColor>(amb|blu|brn|gry|grn|hzl|oth))'
}
$Fields = 'PassportId','CountryId','IssueYear','ExpirationYear','BirthYear','Height','HeightValue','HeightUnit','HairColor','EyeColor'
$InvalidPassport = 0
$ValidPassport = 0
$MissingCountryId = 0

foreach ($Passport in $Passports) {
    $PassportFields = foreach ($PassportField in $Passport.Split('\s')) {
        foreach ($Key in $PassportMatch.Keys) {
            [regex]::Matches($PassportField,$PassportMatch.$Key).Groups.Where{$_.Name -in $Fields -and $_.Success -eq $true}
        }
    }

    # FieldsPresent
    if ($PassportFields.Count -le 6) {
        $InvalidPassport++
        continue
    }
    if ($PassportFields.Where{$_.Name -ne 'CountryId'}.Count -le 6 ) {
        $InvalidPassport++
        continue
    }

    # CountryId Missing
    if ($PassportFields.Where{$_.Name -eq 'CountryId'}.Count -eq 0) {
        $MissingCountryId++
    }

    <#
    # Height Value in Range
    $HeightValue = $PassportFields.Where{$_.Name -match 'HeightValue'}[0]
    $HeightUnit = $PassportFields.Where{$_.Name -match 'HeightUnit'}[0]
    # cm
    if ($HeightUnit -eq 'cm' -and $HeightValue -notmatch '1[5-8][0-9]|19[0-3]' ) {
        $InvalidPassport++
        continue
    }
    # in
    if ($HeightUnit -eq 'in' -and $HeightValue -notmatch '(59|6[0-9]|7[0-6])' ) {
        $InvalidPassport++
        continue
    }
    #>

    $PassportData = [ordered]@{}
    foreach ($Key in $PassportMatch.Keys) {
        [string]$FieldData = $PassportFields.Where{$_.Name -eq $Key }[0]
        if ($FieldData){
            if ($Key -eq 'PassportId' -and $FieldData.Length -gt 9) {
                $InvalidPassport++
                continue
            }
            $PassportData.Add($Key,$FieldData)
        }
    }
    #[PsCustomObject]$PassportData

    $ValidPassport++
}

'{0} Valid Passports' -f $ValidPassport
'{0} Invalid Passports' -f $InvalidPassport
'{0} Missing CountryId' -f $MissingCountryId