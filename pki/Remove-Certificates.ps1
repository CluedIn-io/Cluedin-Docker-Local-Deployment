#Requires -RunAsAdministrator
Set-StrictMode -Version Latest

# # delete from ports 9000/9007
# @(9000,9001,9002,9003,9004,9005,9006,9007) | ForEach-Object {
#     "http delete sslcert ipport=0.0.0.0:$_" | netsh | Out-Null
# }
# remove certs from certstore

Get-ChildItem Cert:\ -recurse |
     Where-Object {$_.getType().Name -eq 'X509Certificate2' -and $_.Subject -match 'CluedIn.Dev.Root'} |
     ForEach-Object { Remove-Item -Path $_.PSPath }

# remove files

Remove-Item $PSScriptRoot\certs -Force -Recurse
