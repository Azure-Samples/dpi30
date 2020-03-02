<#
.Synopsis
DPi30 Deploy Modern Data Warehouse

.Description
Function that will walk through all the required information to deploy the modern data warehouse template
#>

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

$datawarehousedescription = @"
    * Azure Data Factory
    * Azure Data Lake Gen 2
    * Azure Databricks
    * Azure Synapse Analytics (formerly Azure Data Warehouse)
"@

function DeployDWTemplate {
    # Function to gather information and deploy the Modern Data Warehouse Template
    Param(
        # The resource group name that the template will be deployed to
        $ResourceGroupName,
        # The data factory region determined by the Geography chosen 
        $DataFactoryRegion
    )
   
    Write-Host "`r`nNow let's get the Modern Data Warehouse template deployed, just a few questions and we can get this kicked off."
    
    $InstanceMessage = "`r`nWhat would you like to name the Data Warehouse Server?"
    $dbservername = Read-Host $InstanceMessage
    $valid = DatabaseServerNameValidation -Name $dbservername
    while(!($valid.Result)){
        # Validation loop (Keep trying until you get the name right)
        Write-Host $valid.Message -ForegroundColor Red
        $dbservername = Read-Host $InstanceMessage
        $valid = DatabaseServerNameValidation -Name $dbservername
    }

    $InstanceMessage = "`r`nWhat username would you like to use for the Data Warehouse Server?"
    $dbadminlogin = Read-Host $InstanceMessage
    $valid = DatabaseLoginNameValidation -Name $dbadminlogin
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Red
        $dbadminlogin = Read-Host $InstanceMessage
        $valid = DatabaseLoginNameValidation -Name $dbadminlogin
    }

    $dbadminpassword = Read-Host "Password" -AsSecureString
    
    $InstanceMessage = "`r`nWhat would you like to name the Data Warehouse?"
    $dwname = Read-Host $InstanceMessage
    $valid = DatabaseNameValidation -Name $dwname
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Red
        $dwname = Read-Host $InstanceMessage
        $valid = DatabaseNameValidation -Name $dwname
    }

    $InstanceMessage = "`r`nWhat would you like to name the Databricks Workspace?"
    $databricksname = Read-Host $InstanceMessage
    $valid = DatabricksNameValidation -Name $databricksname
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Red
        $databricksname = Read-Host $InstanceMessage
        $valid = DatabricksNameValidation -Name $databricksname
    }

    $InstanceMessage = "`r`nWhat would you like to name the Data Lake storage account?"
    $storagename = Read-Host $InstanceMessage
    $valid = StorageAccountNameValidation -Name $storagename
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Red
        $storagename = Read-Host $InstanceMessage
        $valid = StorageAccountNameValidation -Name $storagename
    }

    $InstanceMessage = "`r`nWhat would you like to name the Data Factory?"
    $dfname = Read-Host $InstanceMessage
    $valid = DataFactoryNameValidation -Name $dfname 
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Red
        $dfname = Read-Host $InstanceMessage
        $valid = DataFactoryNameValidation -Name $dfname 
    }
    Write-Host "`r`nOk! That's everything, Let's confirm:"
    $confirmtext = @"

    Resource Group Name:             $ResourceGroupName
    Datawarehouse Server Name:       $dbservername
    Datawarehouse Server Login:      $dbadminlogin
    Datawarehouse Name:              $dwname
    Databricks Workspace Name:       $databricksname
    Data Lake Storage Account Name:  $storagename
    Data Factory Name:               $dfname

    To re-run in case of failure you can use:

"@

    $redeploytext = @"
    New-AzResourceGroupDeployment -ResourceGroupName `"$ResourceGroupName`" -TemplateFile `"$PSScriptRoot/../moderndatawarehouse/dpi30moderndatawarehouse.json`" -azureSqlServerName `"$dbservername`" -azureSqlServerAdminLogin `"$dbadminlogin`" -azureSqlDataWarehouseName `"$dwname`" -databricksWorkspaceName `"$databricksname`" -storageAccountName `"$storagename`" -dataFactoryName `"$dfname`" -dataFactoryRegion `"$DataFactoryRegion`"
"@

    Write-Host $confirmtext
    Write-Host $redeploytext -ForegroundColor Cyan
    $confirmation = ProceedValidation
    if ($confirmation -eq "y") {
        Write-Host "Deploying Template, the deployment will take a few minutes..."
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile "$PSScriptRoot/../moderndatawarehouse/dpi30moderndatawarehouse.json" -azureSqlServerName $dbservername -azureSqlServerAdminLogin $dbadminlogin -azureSqlServerAdminPassword $dbadminpassword -azureSqlDataWarehouseName $dwname -databricksWorkspaceName $databricksname -storageAccountName $storagename -dataFactoryName $dfname -dataFactoryRegion $DataFactoryRegion
    }
}