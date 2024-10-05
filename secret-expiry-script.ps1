# Author:    Rahulsingh Kanoj
# Created:   04.07.2024
#This Script is used to check the expiring client secrets of Service Principals.


#Enter the path of file which contains service principal names.
$displayname= Get-Content ".\List_Of_ServicePrincipals.txt"
Write-Host "Hold on we are Validating expiration data...`n"
$date = Get-Date -UFormat("%m-%d-%y")

## Iterate through the service principals and gets the app ID
foreach ($name in $displayname){
Write-Host "Checking for $($name) `n"
$appID = (az ad app list --display-name $name --query "[].{spID:appId}" --output tsv)

## Iterate through the appID and gets the details of passwordCredentials

foreach ($id in $appID) {
$application=(az ad app show --id $id --query "{appId: appId,passwordCredentials: passwordCredentials}" -o json | ConvertFrom-Json)
foreach ($passwordCredential in $application.passwordCredentials)
    {
         if ($passwordCredential.endDateTime -eq $null) {
        
      } else {

$currentDate = Get-Date
$dateToCheck = $passwordCredential.endDateTime
$daysToChekAgainst=30;

$daysUntilDate = (New-TimeSpan -Start $currentDate -End $dateToCheck).Days


##Condition will check keyexpiration against 30days.
#if (($daysUntilDate -lt $daysToChekAgainst) -and ($daysUntilDate -gt 0)) {
if (($daysUntilDate -lt $daysToChekAgainst)) {
    Write-Output "  No Of Days left:  $daysUntilDate "
 Write-Output "  Type: Password"
        Write-Output "  Value: $($passwordCredential.value)"
        Write-Output "  End date time: $($passwordCredential.endDateTime)"
  ##Write-Output "  Secret ID: $($passwordCredential.keyId)"
  Write-Output "  Display-Name: $($name)"
  Write-Host "================================================================== `n"

#Below lines will append the above output to Serviceprincipal-$($date).txt file
  $data =	"No Of Days left: $daysUntilDate`nEnd date time: $($passwordCredential.endDateTime)`nDisplay-Name: $($name)`n`n"
  Out-File -filePath .\Serviceprincipal-$($date).txt -InputObject $data -Append
  
}
          
    
  }
}
}
}

Write-Host "The Process is compeleted"

ls
