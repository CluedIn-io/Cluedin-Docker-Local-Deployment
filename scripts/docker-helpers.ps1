function Set-DockerEngine {
    param(
        # Sets Docker Engine to Windows
        [Parameter(ParameterSetName='Windows')]
        [Switch]
        $Windows,
        # Sets Docker Engine to Linux
        [Parameter(ParameterSetName='Linux')]
        [Switch]
        $Linux
    )

    if($Windows){
        $flag = '-SwitchWindowsEngine'
    }
    elseif ($Linux) {
        $flag = '-SwitchLinuxEngine'
    }
    else {
        Write-Error "You need to specify either Windows or Linux"
    }

    & "$Env:ProgramFiles\Docker\Docker\DockerCli.exe" $flag
}

function Get-DockerEngine {
    docker version -f '{{.Server.Os}}'
    & "$Env:ProgramFiles\Docker\Docker\DockerCli.exe" -Version
}


function Edit-HostFile {
    & notepad C:\windows\system32\drivers\etc\hosts
}