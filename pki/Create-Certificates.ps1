#Requires -RunAsAdministrator
param(
    # Folder where to store certificates 
    [Parameter(Mandatory=$false)]
    [string]
    $Folder="certs",
    # Trust root certificate in local machine
    [Parameter(Mandatory=$false)]
    [Switch]
    $Trust=$false
)

$secret = $null

$certsFolder = Join-Path $PSScriptRoot -ChildPath $Folder
$server_certs_vars = Join-Path -Path $certsFolder -ChildPath 'server-certs.vars'
$scripts = Join-Path $PSScriptRoot -ChildPath scripts -Resolve

Set-StrictMode -Version Latest

if(-Not (Test-Path -Path $certsFolder)){
    New-Item -ItemType Directory -Path $PSScriptRoot -Name $Folder -Force
}

# Create certificates (crt, key)
& docker run -v ${scripts}:/scripts -v ${certsFolder}:/mount --rm --workdir /mount smallstep/step-cli:0.8.6 bash -c /scripts/create.sh

# Transform into pkcs12 (pfx)
@('server','website') | ForEach-Object {
    & docker run -v ${certsFolder}:/mount --rm --workdir /mount --entrypoint=sh frapsoft/openssl -c "openssl pkcs12 -export -in CluedIn.Dev.$_.crt -inkey CluedIn.Dev.$_.key -out CluedIn.Dev.$_.pfx -passout pass:$secret"
}

$serverPfx = Join-Path -Path $certsFolder -ChildPath 'Cluedin.Dev.server.pfx' -Resolve

$certBase64=[Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$serverPfx"))
if($secret){
    $secretBase64=[Convert]::ToBase64String($secret)
} else {
   $secretBase64=''
}

if(Test-Path $server_certs_vars){
    Remove-Item $server_certs_vars -Force
}

@('CERTVALUE_API',
'CERTVALUE_AUTH',
'CERTVALUE_PUBLIC',
'CERTVALUE_WEBHOOK') | ForEach-Object {
    "$_=$certBase64" >> $server_certs_vars
}
"CERT_PASSWORD=$secretBase64" >> $server_certs_vars


# Trust root certificate
if($Trust){
    Import-Certificate -FilePath ${certsFolder}/root.crt -CertStoreLocation Cert:\LocalMachine\Root
}

# # Install server certificate for ports 9000/9007
# $cert = Import-PfxCertificate -FilePath certs/Cluedin.Dev.server.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $secret
# $cert_thp = $cert.Thumbprint
# $guid = [guid]::NewGuid()

# @(9000,9001,9002,9003,9004,9005,9006,9007) | ForEach-Object {
#     "http delete sslcert ipport=0.0.0.0:$_" | netsh | Out-Null
#     "http add sslcert ipport=0.0.0.0:$_ certhash=$cert_thp appid={$guid} certstorename=MY" | netsh
# }




# Install website certificate
    # Import-PfxCertificate -FilePath certs/Cluedin.Dev.website.pfx -CertStoreLocation Cert:\LocalMachine\My

# Display installed CluedIn certificates
# Get-ChildItem Cert:\ -recurse |
#     Where-Object { $_.getType().Name -eq 'X509Certificate2' -and $_.Subject -like '*cluedin*' } |
#     Select-Object Subject, Issuer , Thumbprint, DnsNameList, NotAfter, PSPath
