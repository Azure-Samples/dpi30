<#
.Synopsis
DPi30 Simple Template Deployment

.Description
Function that will walk through all the required information to deploy the simple template
#>

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

$simpledescription = @"
    * SQL Azure Hyperscale Database (Gen 5 2 Cores, 1 readable secondary)
    * Azure Storage Account (Blob Storage)
    * Azure Data Factory
"@

function DeploySimpleTemplate {
    # Function to gather information and deploy the Simple Template
    Param(
        # The resource group name that the template will be deployed to
        $ResourceGroupName,
        # The data factory region determined by the Geography chosen 
        $DataFactoryRegion
    )
    
    Write-Host "`r`nNow let's get the Azure SQL Database template deployed, just a few questions and we can get this kicked off."
    $InputMessage = "`r`nWhat would you like to name the Database Server?"
    $dbservername = Read-Host $InputMessage
    $valid = DatabaseServerNameValidation -Name $dbservername
    while(!($valid.Result)){
        # Validation loop (Keep trying until you get the name right)
        Write-Host $valid.Message -ForegroundColor Yellow
        $dbservername = Read-Host $InputMessage
        $valid = DatabaseServerNameValidation -Name $dbservername
    }

    $InputMessage = "`r`nWhat username would you like to use for the Database Server?"
    $dbadminlogin = Read-Host $InputMessage
    $valid = DatabaseLoginNameValidation -Name $dbadminlogin
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $dbadminlogin = Read-Host $InputMessage
        $valid = DatabaseLoginNameValidation -Name $dbadminlogin
    }

    $dbadminpassword = Read-Host "Password" -AsSecureString

    $InputMessage = "`r`nWhat would you like to name the Database?"
    $dbname = Read-Host $InputMessage
    $valid = DatabaseNameValidation -Name $dbname
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $dbname = Read-Host $InputMessage
        $valid = DatabaseNameValidation -Name $dbname
    }

    $InputMessage = "`r`nWhat would you like to name the Blob storage account?"
    $storagename = Read-Host $InputMessage
    $valid = StorageAccountNameValidation -Name $storagename
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Yellow
        $storagename = Read-Host $InputMessage
        $valid = StorageAccountNameValidation -Name $storagename
    }

    $InputMessage = "`r`nWhat would you like to name the Data Factory?"
    $dfname = Read-Host $InputMessage
    $valid = DataFactoryNameValidation -Name $dfname 
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Yellow
        $dfname = Read-Host $InputMessage
        $valid = DataFactoryNameValidation -Name $dfname 
    }
    
    Write-Host "`r`nOk! That's everything, Let's confirm:"
    $confirmtext = @"

    Resource Group Name:             $ResourceGroupName
    Database Server Name:            $dbservername
    Database Server Login:           $dbadminlogin
    Database Name:                   $dbname
    Blob Storage Account Name:       $storagename
    Data Factory Name:               $dfname

    To re-run in case of failure you can use:

"@

    $redeploytext = @"
    New-AzResourceGroupDeployment -ResourceGroupName `"$ResourceGroupName`" -TemplateFile `"$PSScriptRoot/../simple/dpi30simple.json`" -azureSqlServerName `"$dbservername`" -azureSqlServerAdminLogin `"$dbadminlogin`" -azureSqlDatabaseName `"$dbname`" -storageAccountName `"$storagename`" -dataFactoryName `"$dfname` -dataFactoryRegion `"$DataFactoryRegion`"
"@

    Write-Host $confirmtext 
    Write-Host $redeploytext -ForegroundColor Cyan

    $confirmation = ProceedValidation
    if ($confirmation -eq "y") {
        Write-Host "Deploying Template, this will take a few minutes..."
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile "$PSScriptRoot/../simple/dpi30simple.json" -azureSqlServerName $dbservername -azureSqlServerAdminLogin $dbadminlogin -azureSqlServerAdminPassword $dbadminpassword -azureSqlDatabaseName $dbname -storageAccountName $storagename -dataFactoryName $dfname -dataFactoryRegion $DataFactoryRegion
    }
}