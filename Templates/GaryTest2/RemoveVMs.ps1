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
$uniqueName = Get-Date -format "mmss"
# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
$ErrorActionPreference = "stop"
$ResourceGroupName = "GaryTestLabRG037817"
$ResourceGroupLocation = "westus"
"Login to the subscription with your Azure account..."
# Make connection to Azure
	$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
	Select-AzureRmProfile -Path "$scriptDir\credential.json"
	#Select-AzureRmSubscription -SubscriptionName $subscriptionName
	#Get-AzureRmresourceGroup | Select ResourceGroupName
	#$temp=Get-AzureRmLocation | sort Location | Select Location

#TODO: Use the line below instead of Login above, once you're authenticated.
#Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Out-Null

  $timestamp = Get-Date -format "ddmmss"
 $vmName = "auto" + $timestamp;
   $nicName = $vmName + "Nic";
   $DeploymentParam = @{
		Name = "autodeploygroup" + $timestamp;
		ResourceGroupName = $ResourceGroupName;
		Force = $true;
		Verbose = $true;
		TemplateFile = "$scriptDir\CreateVMTemplate.json";
		TemplateParameterObject = @{
			
			

		};
   }
 
"Start deploying the demo lab using the ARM templates..."
$lastRgDeployment = New-AzureRmResourceGroupDeployment @DeploymentParam;

#New-AzureRmResourceGroupDeployment -Name $uniqueName -ResourceGroupName $ResourceGroupName -TemplateFile .\Templates\azuredeploy.json -TemplateParameterFile .\Templates\azuredeploy.parameters.json -Verbose -Force

#get the most recent deployment for the resource group
#$lastRgDeployment = Get-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName |
   # Sort Timestamp -Descending |
     #   Select -First 1        
Write-Output $lastRgDeployment
