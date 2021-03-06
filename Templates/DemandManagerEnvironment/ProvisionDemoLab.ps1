Param(
    # Azure subscription ID associated with the Dev/Test lab instance.
    [ValidateNotNullOrEmpty()]
    [string]
    $SubscriptionId,

    #Name for the new resource group where the lab will be created 
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupName,

    #Location for the resource group to be created. e.g. West US 
    [ValidateNotNullOrEmpty()]
    [string]
    $ResourceGroupLocation
)

##################################################################################################

#
# Powershell Configurations
#
write-host I got here
$uniqueName = Get-Date -format "HHmmss"
# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
$ErrorActionPreference = "stop"
$ResourceGroupName = "GaryTestLabRG037817"
$ResourceGroupLocation = "westus"
"Login to the subscription with your Azure account..."
# Make connection to Azure
	$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
	Select-AzureRmProfile -Path "C:\AzureProfiles\ChauEA.json"
	#Select-AzureRmSubscription -SubscriptionName $subscriptionName
	#Get-AzureRmresourceGroup | Select ResourceGroupName
	#$temp=Get-AzureRmLocation | sort Location | Select Location

#TODO: Use the line below instead of Login above, once you're authenticated.
#Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Out-Null

"Creating new resource group for the demo lab..."
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Force

"Start deploying the demo lab using the ARM templates..."
New-AzureRmResourceGroupDeployment -Name $uniqueName -ResourceGroupName $ResourceGroupName -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.json -Verbose -Force