
$root = $PSScriptRoot
$scripts = Join-Path $root 'scripts'

. $scripts\docker-helpers.ps1
. $scripts\hosts-helpers.ps1

Set-DockerEngine -Linux

& docker-compose stop

Set-DockerEngine -Windows
$name = "cluedin_server"

& docker inspect $name  2>&1 > $null

if ($?){
    Write-Host "Stopping $name"    
    & docker stop  $name        
}
else {
    Write-Warning "Container $name does not exist so cannot be stopped"
    Write-Host "You can create it invoking create.ps1"
}

