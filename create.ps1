<#
.SYNOPSIS
    Starts a Cluedin Environment
.DESCRIPTION
    Invokes the Docker Compose file defining all the Linux containers running dependencies for Cluedin. Then it will switch to Windows containers and start the CluedIn back end server passing collection of environment variables defined in an variables file to override settings in the server.
    Finally, it adds the correct IP address for the backend server to the hosts file.
.EXAMPLE
    PS C:\> ./create.ps1
    Start CluedIn with default settings
.EXAMPLE
    PS C:\> ./create.ps1 -ServerImageTag custom
    It will use the image cluedin/cluedin-server:custom to create the container for the CluedIn server
.INPUTS
    EnvVarsFile - Override the file with the environment settings to pass to the CluedIn server
    ServerImageTag - Define the image tag to use for the CluedIn server
#>
[CmdletBinding()]
param(
    $CluedInEnvVarsFile = "./cluedin-env.vars",
    $DomainVarsFile = "./domains.vars",
    $ServerImageTag = "latest"
    )
    $ErrorActionPreference="Stop"
    
    $root = $PSScriptRoot
    $scripts = Join-Path $root 'scripts'
    
    . $scripts\docker-helpers.ps1
    . $scripts\hosts-helpers.ps1
    . $scripts\Set-Environment.ps1 $DomainVarsFile
    

$cluedin_server_image = "cluedin/cluedin-server:$ServerImageTag"
$serverContainerName = "cluedin_server"

Set-DockerEngine -Linux

Write-Host "Starting up dependencies"

& docker-compose up -d

Set-DockerEngine -Windows

# Hack for not having host.docker.internal available inside the cluedin Windows container
& $scripts\fix-networking.ps1 $CluedInEnvVarsFile

Write-Host "Starting CluedIn container. Using image $cluedin_server_image"

& docker run -d -l cluedin -e AuthServerUrl -e ServerUrl -e ServerPublicApiUrl -e JobServerDashboardUrl --env-file $CluedInEnvVarsFile --name $serverContainerName $cluedin_server_image > $null

$IP = & docker inspect $serverContainerName -f '{{.NetworkSettings.Networks.nat.IPAddress}}'

Write-Host "Cluedin container started with IP $IP"

# Modify hosts file with the IP of the container that just started. 
# This IP changes every time the container starts

@("ServerUrl", "AuthServerUrl", "ServerPublicApiUrl", "JobServerDashboardUrl") | Foreach-Object {
    # Capture the IP
    $value = [Environment]::GetEnvironmentVariable("$_")
    if ( $value  -match  "(?:http[s]?:\/\/)?(?<hostname>[^:]+)") {

        Add-HostFileContent $IP ${Matches}.hostname

    }        
}
# Add access to the frontend
Add-HostFileContent "127.0.0.1" "app.cluedin.test cluedin.cluedin.test test.cluedin.test"

Write-Host "You should be able to browse Cluedin using 'http://app.cluedin.test'"
Write-Host "You can check the Cluedin server logs 'docker logs -f cluedin_server'"