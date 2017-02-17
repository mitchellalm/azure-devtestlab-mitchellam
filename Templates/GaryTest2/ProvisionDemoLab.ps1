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
workflow RemoveIt {
 param(
   $labVMs,
   [string]$scriptDir
 )
        # Delete the VMs.
        foreach -parallel -throttlelimit 20  ($labVM in $labVMs)
        {
            $resourceName = $labVM.ResourceName
            $resourceType = $labVM.ResourceType
            $resourceId = $labVM.ResourceId
             Write-Output "in loop - $scriptDir "
            InlineScript {
            $credential = "$using:scriptDir\credential.json"
	        Select-AzureRmProfile -Path $credential
                Remove-AzureRmResource -ResourceId $using:resourceId -Force
                Write-Output "name: $using:resourceName - type:  $using:resourceType"

            }
        }

}

#
# Powershell Configurations
#
write-host I got here
$uniqueName = Get-Date -format "HHmmss"
# Note: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
$ErrorActionPreference = "stop"
$ResourceGroupName = "UltimateLabRG381127"
$ResourceGroupLocation = "westus2"
"Login to the subscription with your Azure account..."
# Make connection to Azure
	$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
	Select-AzureRmProfile -Path "$scriptDir\credential.json"
	#Select-AzureRmSubscription -SubscriptionName $subscriptionName
	#Get-AzureRmresourceGroup | Select ResourceGroupName
	#$temp=Get-AzureRmLocation | sort Location | Select Location

#TODO: Use the line below instead of Login above, once you're authenticated.
#Select-AzureRmSubscription -SubscriptionId $SubscriptionId | Out-Null

"Creating new resource group for the demo lab..."
#New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Force

"Start deploying the demo lab using the ARM templates..."
#New-AzureRmResourceGroupDeployment -Name $uniqueName -ResourceGroupName $ResourceGroupName -TemplateFile .\azuredeploy.json -TemplateParameterFile .\azuredeploy.parameters.json -Verbose -Force
#New-AzureRmResourceGroupDeployment -Name $uniqueName -ResourceGroupName $ResourceGroupName -TemplateFile .\labdeploy.json -Verbose -Force



# Delete all the VMs in a lab

# Delete all the VMs in a lab

# Values to change
$subscriptionId = "352b4bd5-2f5d-4e82-ab23-37e96afc58b1"
$labResourceGroup = "GeneralTestLabRG681101"
$labName = "GeneralTestLab"



# Select the Azure subscription that contains the lab. This step is optional
# if you have only one subscription.
Select-AzureRmSubscription -SubscriptionId $subscriptionId

# Get the lab that contains the VMs to delete.
$lab = Get-AzureRmResource -ResourceId ('subscriptions/' + $subscriptionId + '/resourceGroups/' + $labResourceGroup + '/providers/Microsoft.DevTestLab/labs/' + $labName)

# Get the VMs from that lab.
# Get the VMs from that lab.
$global:labVMs
$labVMs = Get-AzureRmResource | Where-Object { 
          $_.ResourceType -eq 'microsoft.devtestlab/labs/virtualmachines' -and
          $_.ResourceName -like "$($lab.ResourceName)/*"}

RemoveIt -labVMs $global:labVMs -scriptDir $PSScriptRoot

