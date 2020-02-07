<#
.Synopsis
DPi30 Decision and Deployment Tree

.Description
Script that will walk you through determining the proper DPi30 Template and help you deploy it step by step.
#>

#Included files to make our script significantly more readable.
$IncludeScripts = 
    "$PSScriptRoot/includes/validation.ps1",
    "$PSScriptRoot/includes/determinetemplate.ps1",
    "$PSScriptRoot/includes/deployresourcegroup.ps1",
    "$PSScriptRoot/includes/deploymoderndatawarehouse.ps1",
    "$PSScriptRoot/includes/deploysimple.ps1",
    "$PSScriptRoot/includes/deploymanagedinstance.ps1"

foreach ($script in $IncludeScripts) {
    try {
        . ($script)
    }
    catch {
        Write-Error "Error loading $script" -ErrorAction Stop   
    }
}
#try {
#    . ("$PSScriptRoot/includes/validation.ps1")
#    . ("$PSScriptRoot/includes/determinetemplate.ps1")
#    . ("$PSScriptRoot/includes/deployresourcegroup.ps1")
#    . ("$PSScriptRoot/includes/deploymoderndatawarehouse.ps1")
#    . ("$PSScriptRoot/includes/deploysimple.ps1")
#    . ("$PSScriptRoot/includes/deploymanagedinstance.ps1")
#}
#catch {
#    Write-Error "Error while loading supporting PowerShell Scripts" -ErrorAction Stop
#}

function DeployTemplate {
    # Moved initial deployment tree to secondary function to allow for easier expansion if we have more templates in the future
    Param(
        # The Template name we intend to deploy
        $template
    )
    Clear-Host
    # Create our resource group to deploy our azure resources to
    $resourceGroupInformation = DeployResourceGroup
    if ($template -eq "moderndatawarehouse") {
        DeployDWTemplate -ResourceGroupName $resourceGroupInformation.ResourceGroupName -DataFactoryRegion $resourceGroupInformation.DataFactoryRegion
    }
    if ($template -eq "simple") {
        DeploySimpleTemplate -ResourceGroupName $resourceGroupInformation.ResourceGroupName -DataFactoryRegion $resourceGroupInformation.DataFactoryRegion
    }
    if ($template -eq "managedinstance") {
        DeployManagedInstanceTemplate -ResourceGroupName $resourceGroupInformation.ResourceGroupName -DataFactoryRegion $resourceGroupInformation.DataFactoryRegion
    }
}

function SubscriptionSelection {
    $InputMessage = "`r`nSubscription number"
    $SubSelection = Read-Host $InputMessage
    $valid = IntValidation -UserInput $SubSelection
    while(!($valid.Result)) {
        Write-Host $valid.Message -ForegroundColor Yellow
        $SubSelection = Read-Host $InputMessage
        $valid = IntValidation -UserInput $SubSelection
    }
    while([int32]$SubSelection -ge $subcount) {
        Write-Host "Please select a valid subscription number, $SubSelection is not an option" -ForegroundColor Yellow
        $SubSelection = SubscriptionSelection
    }
    return $SubSelection
}

# Our code entry point, We verify the subscription and move through the steps from here.
Clear-Host
$currentsub = Get-AzContext
$currentsubfull = $currentsub.Subscription.Name + " (" + $currentsub.Subscription.Id + ")"
Write-Host "Welcome to the DPi30 Deployment Wizard!"
Write-Host "Before we get started, we need to select the subscription for this deployment:`r`n"

#Gathering subscription selection, validating input and changing to another subscription if needed
$rawsubscriptionlist = Get-AzSubscription | Where-Object {$_.State -ne "Disabled"} | Sort-Object -property Name | Select-Object Name, Id 
$subscriptionlist = [ordered]@{}
$subscriptionlist.Add(1, "CURRENT SUBSCRIPTION: $($currentsubfull)")
$subcount = 2
foreach ($subscription in $rawsubscriptionlist) {
    $subname = $subscription.Name + " (" + $subscription.Id + ")"
    if($subname -ne $currentsubfull) {
        $subscriptionlist.Add($subcount, $subname)
        $subcount++
    }
}
$subscriptionlist.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key))" "$($_.Value)"}

$InputMessage = "`r`nSubscription number"
$SubSelection = Read-Host $InputMessage
$valid = IntValidation -UserInput $SubSelection -OptionCount $subscriptionlist.Count
while(!($valid.Result)) {
    Write-Host $valid.Message -ForegroundColor Yellow
    $SubSelection = Read-Host $InputMessage
    $valid = IntValidation -UserInput $SubSelection -OptionCount $subscriptionlist.Count
}

if ($SubSelection -ne 1) {
    $selectedsub = $subscriptionlist.[int]$SubSelection
    $selectedsubid = $selectedsub.Substring($selectedsub.Length - 37).TrimEnd(")")
    $changesub = Select-AzSubscription -Subscription $selectedsubid
    Write-Host "`r`nSuccessfully changed to Subscription $($changesub.Name)" -ForegroundColor Green
} else {
    Write-Host "`r`nContinuing with current Subscription $($currentsubfull)" -ForegroundColor Green   
}
Start-Sleep -s 2 #Quick sleep before a new section and clear host

#Printing template based upon responses and confirming whether to proceed
Clear-Host
$template = DetermineTemplate
switch ($template) {
    "moderndatawarehouse" {
        $templatedescription = $datawarehousedescription
        $templatetype = "Modern Data Warehouse"
        break
    }
    "simple" {
        $templatedescription = $simpledescription
        $templatetype = "Azure SQL Database"
        break
    }
    "managedinstance" {
        $templatedescription = $managedinstancedescription
        $templatetype = "Azure SQL Managed Instance"
        break 
    }
}
Write-Host "`r`nBased on your answers we suggest the deployment of " -NoNewLine
Write-Host $templatetype -ForegroundColor Cyan 
Write-Host "This template will deploy the following to your Azure Subscription: " -NoNewLine 
Write-Host "$currentsubfull`r`n" -ForegroundColor Cyan 
Write-Host $templatedescription -ForegroundColor Cyan 

$confirmation = ProceedValidation

if ($confirmation -eq "y") {
    Write-Host "`r`nProceeding with the $($templatetype) deployment template" -ForegroundColor Green
    Start-Sleep -s 2 #Quick sleep before a new section and clear host
    DeployTemplate -template $template
} else {
  exit
}

