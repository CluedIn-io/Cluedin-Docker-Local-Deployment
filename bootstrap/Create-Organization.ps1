param(
    [string]$Name = "foobar",
    [string]$Email = "admin@foobar.com",
    [string]$UserName = $Email,
    [string]$Pwd = "foobar23",
    [string]$Endpoint = "https://localhost:9001"
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest `
        -Method POST `
        -Uri "$Endpoint/api/account/new" `
        -UseBasicParsing `
        -Headers @{
            "Content-Type" = "application/x-www-form-urlencoded"; 
            "cache-control" = "no-cache"} `
            -Body @{ 
                "username"="$UserName";
                "password"="$Pwd";
                "organizationName"="$Name";
                "grant_type"="password";
                "allowEmailDomainSignup"="false";
                "confirmpassword"="$Pwd";
                "email"="$Email";
                "emailDomain"="$Name.com";
                "applicationSubDomain"="$Name"}