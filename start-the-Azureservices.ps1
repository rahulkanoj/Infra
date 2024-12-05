 Author:    Rahulsingh Kanoj
# Created on:   26/07/2024
# This Script is used to start the Azure services PP Environment.


$variablePath = "Variable.txt"
$values = Get-Content $variablePath | Out-String | ConvertFrom-StringData

#Start Webapp
Write-Host "Starting webapp $($values.webappname) `n"
az webapp start --name $values.webappname --resource-group $values.resourceGroupName
Write-Host "Please find the hostnames of running webapps `n"
az webapp list --resource-group $values.resourceGroupName --query "[?state=='Running'].{Name:defaultHostName}" -o table
Write-Host "`n"
#Scale up App-Service plan
Write-Host "Scaling up App-Service plan $($values.MyAppServicePlan) `n"
az appservice plan update --name $values.MyAppServicePlan --resource-group $values.resourceGroupName --sku B1
Write-Host "Please find the names of App-Service plan whose SKU Size == B1 `n"
az appservice plan list  --resource-group $values.resourceGroupName --query "[?sku.size=='B1'].{Name:name}" -o table
Write-Host "`n"
#Start Application gateway
Write-Host "Starting Application gateway $($values.myapplicationgateway) `n"
az network application-gateway start -g $values.resourceGroupName -n $values.myapplicationgateway
Write-Host "Please find the names of Running Application gateways `n"
$output=(az network application-gateway list -g $values.resourceGroupName --query "[?operationalState=='Running'].{id:id}" -o tsv)
$output.Split('/') | Select-Object -Last 1
Write-Host "`n"
#Start Aks Cluster
Write-Host "Starting Aks Cluster $($values.myAKSCluster) `n"
az aks get-credentials --resource-group $values.resourceGroupName --name $values.myAKSCluster --overwrite-existing
az aks start --name $values.myAKSCluster --resource-group $values.resourceGroupName
Write-Host "Please find the AKS Cluster Status `n"
az aks list --query "[].{Name:name, Power:powerState.code}" -o table
Write-Host "`n"
#Start All Function apps.
Write-Host "Starting the Function apps `n"
$functionname= Get-Content "In-function.txt"
foreach ($name in $functionname){
az functionapp start --name $name --resource-group $values.resourceGroupName
}
Write-Host "Please find the default host name and state for all function apps `n"
az functionapp list -g $values.resourceGroupName --query "[].{hostName: defaultHostName, state: state}" -o table
Write-Host "`n"
Write-Host "Start operation have been completed"
