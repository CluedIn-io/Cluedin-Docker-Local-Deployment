
$root = $PSScriptRoot
$scripts = Join-Path $root 'scripts'

. $scripts\docker-helpers.ps1
. $scripts\hosts-helpers.ps1


Set-DockerEngine -Windows
$name = "cluedin_server"

& docker inspect $name  2>&1 > $null

if ($?){
    Write-Host "Starting $name"    
    & docker start $name
    
    
    Set-DockerEngine -Linux    
    & docker-compose up
}
else {
    Write-Warning "You need to create the environment first invoking create.ps1 with admin rights"
}
