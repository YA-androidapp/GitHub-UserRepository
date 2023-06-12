# Copyright (c) 2023 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.


$user = 'ya-androidapp'
$filepath = 'result.txt'


if( $(Test-Path $filepath) -eq $True ){
    Remove-Item $filepath
}

foreach ($page in 1..10) {
    $request = Invoke-RestMethod -Method Get -ContentType "application/json" "https://api.github.com/users/$user/repos?page=$page&per_page=100" | where { ($_.size -le 100000)}
    $request | Select-Object -Property name | ConvertTo-Csv | Select -Skip 2 | Out-File $filepath -Encoding UTF-8 -Append
}


if (Test-Path $filepath) {
    Get-Content $filepath -Encoding UTF8 | ForEach-Object {
        $repo = $_ -replace '"',''
        Write-Host "$repo"
    }
}

if (Test-Path $filepath) {
    Get-Content $filepath -Encoding UTF8 | ForEach-Object {
        $repo = $_ -replace '"',''
        git clone "https://github.com/$user/$repo"
    }
}