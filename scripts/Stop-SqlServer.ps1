
# Stop local sql server instance to let docker use the same ports
@( "SQLSERVERAGENT", "MSSQLSERVER", "SQLTELEMETRY", "ReportServer" ) | ForEach-Object {

    $serviceName = $_

    Get-Service |
        Where-Object { ( $_.Name -eq "$serviceName" ) -and ( $_.Status -eq "Running" ) } |
        Stop-Service
}
