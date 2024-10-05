# Set subscription context
$subscriptions= Get-Content "C:\Users\INRKANOJ\Desktop\Work\Alerts-automation\subscription.txt"


foreach ($subscription in $subscriptions){
Set-AzContext -Subscription "$subscription"

# Get all tickets for the subscription
$ticket = Get-AzSupportTicket -Filter "Status eq 'Open'"
$ticket
}
