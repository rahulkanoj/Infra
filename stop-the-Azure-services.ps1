# Author:    Rahulsingh Kanoj
# Created:   27/07/2024
# This Script is used to stop the Azure services of PP Environment.

$variablePath = "Variable.txt"
$values = Get-Content $variablePath | Out-String | ConvertFrom-StringData

#Stop Webapp
Write-Host "Stopping webapp $($values.webappname) `n"
az webapp stop --name $values.webappname --resource-group $values.resourceGroupName
Write-Host "Please find the hostnames of Stopped webapps `n"
az webapp list --resource-group $values.resourceGroupName --query "[?state=='Stopped'].{Name:defaultHostName}" -o table
Write-Host "`n"
#Scale Down App-Service plan
Write-Host "Scaling down App-Service plan $($values.MyAppServicePlan) `n"
az appservice plan update --name $values.MyAppServicePlan --resource-group $values.resourceGroupName --sku F1
Write-Host "Please find the names of App-Service plan whose SKU Size == F1 `n"
az appservice plan list  --resource-group $values.resourceGroupName --query "[?sku.size=='F1'].{Name:name}" -o table
Write-Host "`n"

#Stop Application gateway
Write-Host "Stopping Application gateway $($values.myapplicationgateway) `n"
az network application-gateway stop -g $values.resourceGroupName -n $values.myapplicationgateway
Write-Host "Please find the names of Stopped Application gateway `n"
$output=(az network application-gateway list -g $values.resourceGroupName --query "[?operationalState=='Stopped'].{id:id}"  -o tsv)
$output.Split('/') | Select-Object -Last 1
Write-Host "`n"

#Stop Aks Cluster
Write-Host "Stopping Aks Cluster $($values.myAKSCluster) `n"
az aks get-credentials --resource-group $values.resourceGroupName --name $values.myAKSCluster --overwrite-existing
az aks stop --name $values.myAKSCluster --resource-group $values.resourceGroupName
Write-Host "Please find the AKS Cluster Status `n"
az aks list --query "[].{Name:name, Power:powerState.code}" -o table
Write-Host "`n"

#Stop All Function apps.
Write-Host "Stopping the Function apps `n"
$functionname= Get-Content "In-function.txt"
foreach ($name in $functionname){
az functionapp stop --name $name --resource-group $values.resourceGroupName
}
Write-Host "Please find the default host name and state for all function apps `n"
az functionapp list -g $values.resourceGroupName --query "[].{hostName: defaultHostName, state: state}" -o table
Write-Host "`n"

Write-Host "Stop operation have been completed"
