param([switch]$serverOnly)

$root = $PSScriptRoot
$scripts = Join-Path $root 'scripts'

. $scripts\docker-helpers.ps1
. $scripts\hosts-helpers.ps1

if (-Not $serverOnly){
    Set-DockerEngine -Linux
    
    Write-Host "Removing linux conatiner dependencies"
    & docker-compose down 2>&1 > $null
}

Set-DockerEngine -Windows

$name = "cluedin_server"

$IP = & docker inspect $name -f '{{.NetworkSettings.Networks.nat.IPAddress}}' 2> $null

if($?){
    Write-Host "Stopping $name"
    & docker stop $name 2>&1 > $null
    
    Write-Host "Removing $name"
    & docker rm $name 2>&1 > $null
    
    Remove-HostFileContent $IP
    
}
else {
    Write-Warning "CluedIn container did not exist, so nothing to remove."
}
