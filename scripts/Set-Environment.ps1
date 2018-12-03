[CmdletBinding()]
param(
    [string]$path,
    [string]$scope='Process'
)

$regex = "^\W*([^=]+)=(.*)$"

Select-String -Pattern $regex -Path $path | ForEach-Object {
    $key=$_.Matches.Groups[1].Value
    $value=$_.Matches.Groups[2].Value
    $key -split ',' | ForEach-Object {        
        [Environment]::SetEnvironmentVariable("$_", "$value", $scope)
    }
}
