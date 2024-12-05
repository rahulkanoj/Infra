$Subscription=""
$MyResourceGroup=""
$l="West Europe"
az account set --subscription $Subscription
az account show --output table

Write-Host "Deletion of Function apps in progress `n"
$funclist=(az functionapp list --resource-group "$MyResourceGroup" --query "[].{FunctionName:repositorySiteName}" -o tsv)
foreach ($functions in $funclist) {
$functions
#az functionapp delete --name $functions --resource-group "$MyResourceGroup"
}
Write-Host "Function apps have been deleted `n"

Write-Host "Deletion of App Service Plan is started `n"
$planlist=(az appservice plan list --resource-group $MyResourceGroup --query "[].{Name:name}" -o tsv)
foreach ($plans in $planlist) {
$plans
#az appservice plan delete --name $plans --resource-group $MyResourceGroup
}
Write-Host "Deletion of App Service Plan is completed `n"

Write-Host "Deletion of API Management service is started `n"
$APIMlist=(az apim list --resource-group $MyResourceGroup --query "[].{Name:name}" -o tsv)
$APIMlist.l
foreach ($APIM in $APIMlist) {
#az apim delete -n $APIM -g $MyResourceGroup
#az apim deletedservice purge --location $l --service-name $APIM
}
Write-Host "Deletion of API Management service has been completed `n"
