<#
.Synopsis
DPi30 Managed Instance Template Deployment

.Description
Function that will walk through all the required information to deploy the managed instance template
#>

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

$managedinstancedescription = @"
    * SQL Managed Instance (General Purpose, Gen 5 4 Cores)
    * Azure Storage Account (Blob Storage)
    * Azure Data Factory
    * Virtual Machine Jump Box (B2ms, with SSMS and Self Hosted Integration Runtime)
    * Virtual Network to support the Managed Instance
"@

function DeployManagedInstanceTemplate {
    # Function to gather information and deploy the Managed Instance Template
    Param(
        # The resource group name that the template will be deployed to
        $ResourceGroupName,
        # The data factory region determined by the Geography chosen 
        $DataFactoryRegion
    )
    
    Write-Host "`r`nNow let's get the Managed Instance template deployed, just a few questions and we can get this kicked off."
    
    $InstanceMessage = "`r`nWhat would you like to name the Managed Instance?"
    $dbservername = Read-Host $InstanceMessage
    $valid = DatabaseServerNameValidation -Name $dbservername
    while(!($valid.Result)){
        # Validation loop (Keep trying until you get the name right)
        Write-Host $valid.Message -ForegroundColor Yellow
        $dbservername = Read-Host $InstanceMessage
        $valid = DatabaseServerNameValidation -Name $dbservername
    }

    $InstanceMessage = "`r`nWhat username would you like to use for the Managed Instance?"
    $dbadminlogin = Read-Host $InstanceMessage
    $valid = DatabaseLoginNameValidation -Name $dbadminlogin
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $dbadminlogin = Read-Host $InstanceMessage
        $valid = DatabaseLoginNameValidation -Name $dbadminlogin
    }

    $dbadminpassword = Read-Host "Password" -AsSecureString

    $InstanceMessage = "`r`nWhat would you like to name the Blob storage account?"
    $storagename = Read-Host $InstanceMessage
    $valid = StorageAccountNameValidation -Name $storagename
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Yellow
        $storagename = Read-Host $InstanceMessage
        $valid = StorageAccountNameValidation -Name $storagename
    }

    $InstanceMessage = "`r`nWhat would you like to name the Data Factory?"
    $dfname = Read-Host $InstanceMessage
    $valid = DataFactoryNameValidation -Name $dfname 
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Yellow
        $dfname = Read-Host $InstanceMessage
        $valid = DataFactoryNameValidation -Name $dfname 
    }

    $InstanceMessage = "`r`nWhat would you like to name the Jump Box Virtual Machine?"
    $jumpboxname = Read-Host $InstanceMessage
    $valid = VMNameValidation -Name $jumpboxname 
    while(!($valid.Result)){ 
        Write-Host $valid.Message -ForegroundColor Yellow
        $jumpboxname = Read-Host $InstanceMessage
        $valid = VMNameValidation -Name $jumpboxname 
    }

    $InstanceMessage = "`r`nWhat username would you like to use for the Virtual Machine?"
    $vmadminlogin = Read-Host $InstanceMessage
    $valid = DatabaseLoginNameValidation -Name $vmadminlogin
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $vmadminlogin = Read-Host $InstanceMessage
        $valid = DatabaseLoginNameValidation -Name $vmadminlogin
    }

    $vmadminpassword = Read-Host "Password" -AsSecureString

    $InstanceMessage = "`r`nWhat DNS Prefix (beginning of the host name) would you like to use for the Virtual Machine?"
    $vmdnsprefix = Read-Host $InstanceMessage
    $valid = DNSPrefixValidation -Name $vmdnsprefix
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $vmdnsprefix = Read-Host $InstanceMessage
        $valid = DNSPrefixValidation -Name $vmdnsprefix
    }

    $InstanceMessage = "`r`nWhat name would you like to use for the Virtual Network?"
    $vnetname = Read-Host $InstanceMessage
    $valid = vNetNameValidation -Name $vnetname
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $vnetname = Read-Host $InstanceMessage
        $valid = vNetNameValidation -Name $vnetname
    }

    $InstanceMessage = "`r`nWhat address range would you like to use for the Virtual Network? (ex. 10.0.0.0/16)"
    $vnetaddressrange = Read-Host $InstanceMessage
    $valid = CIDRValidation -Name $vnetaddressrange
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $vnetaddressrange = Read-Host $InstanceMessage
        $valid = CIDRValidation -Name $vnetaddressrange
    }

    $InstanceMessage = "`r`nWhat subnet name would you like to use for the Virtual Machine?"
    $vmsubnetname = Read-Host $InstanceMessage
    $valid = AzureNetworkingNameValidation -Name $vmsubnetname
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $vmsubnetname = Read-Host $InstanceMessage
        $valid = AzureNetworkingNameValidation -Name $vmsubnetname
    }

    $InstanceMessage = "`r`nWhat address range would you like to use for the Virtual Machine Subnet? (Must be included in the Virtual Network Subnet range of $vnetaddressrange)"
    $vmsubnetaddressrange = Read-Host $InstanceMessage
    $valid = CIDRValidation -Name $vmsubnetaddressrange
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $vmsubnetaddressrange = Read-Host $InstanceMessage
        $valid = CIDRValidation -Name $vmsubnetaddressrange
    }

    $InstanceMessage = "`r`nWhat subnet name would you like to use for the Managed Instance?"
    $misubnetname = Read-Host $InstanceMessage
    $valid = AzureNetworkingNameValidation -Name $misubnetname
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $misubnetname = Read-Host $InstanceMessage
        $valid = AzureNetworkingNameValidation -Name $misubnetname
    }

    $InstanceMessage = "`r`nWhat address range would you like to use for the Managed Instance Subnet? (Must be included in the Virtual Network Subnet range of $vnetaddressrange)"
    $misubnetaddressrange = Read-Host $InstanceMessage
    $valid = CIDRValidation -Name $misubnetaddressrange
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        $misubnetaddressrange = Read-Host $InstanceMessage
        $valid = CIDRValidation -Name $misubnetaddressrange
    }
    
    Write-Host "`r`nOk! That's everything, Let's confirm:"
    $confirmtext = @"

    Resource Group Name:             $ResourceGroupName
    Managed Instance Server Name:    $dbservername
    Managed Instance Server Login:   $dbadminlogin
    Blob Storage Account Name:       $storagename
    Data Factory Name:               $dfname
    Jumpbox VM Name:                 $jumpboxname
    Jumpbox Admin Login:             $vmadminlogin
    Jumpbox DNS Prefix:              $vmdnsprefix
    Virtual Network Name:            $vnetname
    Virtual Network Address Range:   $vnetaddressrange
    Virtual Network Subnet Name:     $vmsubnetname
    VM Subnet Range:                 $vmsubnetaddressrange
    Managed Instance Subnet Name:    $misubnetname
    Managed Instance Subnet Range:   $misubnetaddressrange

    To re-run in case of failure you can use:

"@

    $redeploytext = @"
    New-AzResourceGroupDeployment -ResourceGroupName `"$ResourceGroupName`" -TemplateFile `"$PSScriptRoot/../managedinstance/dpi30managedinstance.json`" -managedInstanceName `"$dbservername`" -managedInstanceAdminLogin `"$dbadminlogin`" -storageAccountName `"$storagename`" -dataFactoryName `"$dfname`" -dataFactoryRegion `"$DataFactoryRegion`" -jumpboxName `"$jumpboxname`" -jumpboxAdminUsername `"$vmadminlogin`" -jumpboxDnsLabelPrefix `"$vmdnsprefix`" -virtualNetworkName `"$vnetname`" -virtualNetworkAddressPrefix `"$vnetaddressrange`" -defaultSubnetName `"$vmsubnetname`" -defaultSubnetPrefix `"$vmsubnetaddressrange`" -managedInstanceSubnetName `"$misubnetname`" -managedInstanceSubnetPrefix `"$misubnetaddressrange`"
"@

    Write-Host $confirmtext
    Write-Host $redeploytext -ForegroundColor Cyan
    $confirmation = ProceedValidation
    if ($confirmation -eq "y") {
        Write-Host "Deploying Template, the deployment will take up to 3 hours."
        New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile "$PSScriptRoot/../managedinstance/dpi30managedinstance.json" -managedInstanceName $dbservername -managedInstanceAdminLogin $dbadminlogin -managedInstanceAdminPassword $dbadminpassword -storageAccountName $storagename -dataFactoryName $dfname -dataFactoryRegion $DataFactoryRegion -jumpboxName $jumpboxname -jumpboxAdminUsername $vmadminlogin -jumpboxAdminPassword $vmadminpassword -jumpboxDnsLabelPrefix $vmdnsprefix -virtualNetworkName $vnetname -virtualNetworkAddressPrefix $vnetaddressrange -defaultSubnetName $vmsubnetname -defaultSubnetPrefix $vmsubnetaddressrange -managedInstanceSubnetName $misubnetname -managedInstanceSubnetPrefix $misubnetaddressrange
    }
}