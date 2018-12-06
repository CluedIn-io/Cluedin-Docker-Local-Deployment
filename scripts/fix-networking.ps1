param([string] $envFile)

if(-not (Test-Path $envFile)){
    throw "$envFile not found"
}

$internalDockerIp = (gwmi win32_networkadapterconfiguration | where {$_.ipaddress -ne $null -and $_.defaultipgateway -ne $null} | select -First 1).IPAddress[0]
if ( -not $internalDockerIp ){
    Throw "Cannot pint host.docker.internal, maybe Docker is not installed correctly?"
}

(Get-Content $envFile) | ForEach-Object {
    $_ -replace "(\d{1,3}\.){3}\d{1,3}",$internalDockerIp
}  | Set-Content $envFile