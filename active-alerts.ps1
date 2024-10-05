pw#Install required Azure modules if not already installed
#if (-not (Get-Module -Name Az.Monitor -ErrorAction SilentlyContinue)) {
#    Install-Module -Name Az.Monitor -Force -AllowClobber
#}
#if (-not (Get-Module -Name Az.AlertsManagement -ErrorAction SilentlyContinue)) {
#    Install-Module -Name Az.AlertsManagement -Force -AllowClobber
#}

# Authenticate to Azure
# Connect-AzAccount -UseDeviceAuthentication

# Set subscription context
$subscriptions= Get-Content "C:\Users\INRKANOJ\Desktop\Work\Alerts-automation\subscription.txt"


foreach ($subscription in $subscriptions){
Set-AzContext -Subscription "$subscription"

# Get all alerts for the subscription
$alerts = Get-AzAlert -IncludeContext $true -MonitorCondition "Fired"

# Iterate through the alerts
foreach ($alert in $alerts) {
    $subscriptionName = (Get-AzContext).Subscription.Name
	$name = $alert.Name
	$Timestamp = $alert.StartDateTime
	$sev = $alert.Severity
    $uniID = $alert.Id -replace '/','%2F'
    $link = "https://portal.azure.com/#view/Microsoft_Azure_Monitoring_Alerts/AlertDetails.ReactView/alertId~/"+$uniID
	$data =	"Name: $name`nTimestamp: $Timestamp`nSeverity: $sev`nLink: $link`n`n"
    Out-File -filePath .\alerts.txt -InputObject $data -Append


}
}
