param([string] $envFile)

if(-not (Test-Path $envFile)){
    throw "$envFile not found"
}

$pingInternalDocker = ping -n 1 host.docker.internal | select-string -pattern "Reply from ([\d\.]+):"
if ( -not $pingInternalDocker ){
    Throw "Cannot pint host.docker.internal, maybe Docker is not installed correctly?"
}

$internalDockerIp = ${pingInternalDocker}.Matches[0].Groups[1].Value

(Get-Content $envFile) | ForEach-Object {
    $_ -replace "(\d{1,3}\.){3}\d{1,3}",$internalDockerIp
}  | Set-Content $envFile