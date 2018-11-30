
function Add-HostFileContent {
    [CmdletBinding()]
    param(
        [Parameter(
          Mandatory=$True,
          Position=0)][string]$IPAddress,
         [Parameter(
           Mandatory=$True,
           Position=1)][string]$hostname,
        [Parameter(
           Mandatory=$False,
           Position=2)][string]$file = $(Join-Path -Path $($env:windir) -ChildPath "system32\drivers\etc\hosts")
        )               

    if (-not (Test-Path -Path $file)){            
        Throw "Hosts file not found"            
    }            

    if ($IPAddress -notmatch "(\d{1,3}\.){3}\d{1,3}" ){
        Throw "$IPAddress not a valid IP"        
    }

    $pattern = "^.*\b$hostname\b.*$"
    
    if(-Not(Select-String -Pattern $pattern -Path $file -Encoding ASCII)){        
        Write-Verbose "Adding entry for $IPAddress mapped to $hostname in $file"
        Add-Content $file "$IPAddress $hostname #automatically generated" -Encoding ASCII
    }
    else{
        Write-Verbose "Skipping entry for $IPAddress mapped to $hostname, as already in $file"
    }
    
}

function Remove-HostFileContent {
    [CmdletBinding()]
    param(
        [Parameter(
          Mandatory=$True,
          Position=0)][string]$IPAddress,
        [Parameter(
           Mandatory=$False,
           Position=1)][string]$file = $(Join-Path -Path $($env:windir) -ChildPath "system32\drivers\etc\hosts")
        )
    $ErrorActionPreference = "Stop"
    
    if (-not (Test-Path -Path $file)){            
        Throw "Hosts file not found"            
    }

    if ($IPAddress -notmatch "(\d{1,3}\.){3}\d{1,3}" ){
        Throw "$IPAddress not a valid IP"        
    }
    
    $pattern = "^\s*" + ($IPAddress -replace "\.","\.") + "\s"
    
    Copy-Item $file "$file.original"    
    
    (Get-Content -Path $file) |        
        Select-String -Pattern $pattern -NotMatch -Encoding ASCII |
        Set-Content -Path $file -Force -Encoding ASCII        

    Remove-Item "$file.original"
}

