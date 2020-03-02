<#
.Synopsis
DPi30 Deploy Resource Group

.Description
Initial Resource Group deployment that determines geography and region and finally creates the resource group where all Azure resources will be deployed.
#>

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
function DeployResourceGroup {
    # Function to gather information and deploy the resource group
    
    Write-Host "`r`nFirst, let's create a Resource Group to put all these services in."
    $InputMessage = "`r`nWhat would you like the Resource Group named"
    $ResourceGroupName = Read-Host $InputMessage
    $valid = ResourceGroupNameValidation -Name $ResourceGroupName
    while(!($valid.Result)) {
        Write-Host $valid.Message -ForegroundColor Yellow
        $ResourceGroupName = Read-Host $InputMessage
        $valid = ResourceGroupNameValidation -Name $ResourceGroupName
    }
    $ExistingResourceGroup = Get-AzResourceGroup -ResourceGroupName $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if($notPresent) {
        
        $geographyselection = GeographySelection

        #Prompting for region selection.
        $rawlocationlist = ((Get-AzLocation | Where-Object Providers -like "Microsoft.Databricks" | Where-Object Providers -like "Microsoft.Sql" | Where-Object DisplayName -like "* $($geographyselection.GeoRegion)*")) | Sort-Object -property DisplayName | Select-Object DisplayName
        Write-Host "`r`nHere are the regions available for deployment:`r`n"
        $locationlist = [ordered] @{}

        for($i=0;$i -lt $rawlocationlist.Length;$i++)
        {
            $locationlist.Add($i + 1, $rawlocationlist[$i].DisplayName)
        }
        $locationlist.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key))" "$($_.Value)"}
        #Validating numeric input for rg region
        $InputMessage = "`r`nRegion Number"
        $rglocation = Read-Host $InputMessage
        $valid = IntValidation -UserInput $rglocation -OptionCount $locationlist.Count
        while(!($valid.Result)){
            Write-Host $valid.Message -ForegroundColor Yellow
            $rglocation = Read-Host $InputMessage
            $valid = IntValidation -UserInput $rglocation -OptionCount $locationlist.Count
        }  
                
        $rglocation = $locationlist.[int]$rglocation
        #Got our Region for resource group deployment
        # Assign to prevent object being returned in function
        $resourcegroupreturnhold = New-AzResourceGroup -Name $ResourceGroupName -Location $rglocation -Tag @{dpi30="True"}
        Write-Host "`r`nYour new Resource Group '$($ResourceGroupName)' has been deployed to $($rglocation)" -ForegroundColor Green
        $resourceGroupInformation = @{ResourceGroupName = $ResourceGroupName; DataFactoryRegion = $geographyselection.DataFactoryRegion}
        return $resourceGroupInformation
    } else {
        Write-Host "`r`nThe resource group '$($ResourceGroupName)' already exists in $($ExistingResourceGroup.Location)" -ForegroundColor Yellow
        $InputMessage = "`r`nWould you like to use the existing Resource Group?"
        $confirmation = Read-Host $InputMessage
        $valid = BoolValidation -UserInput $confirmation
        while(!($valid.Result)) {
            Write-Host $valid.Message -ForegroundColor Yellow
            $confirmation = Read-Host $InputMessage
            $valid = BoolValidation -UserInput $confirmation
        }
        if ($confirmation -eq 'y') {
            Write-Host "`r`nWe need to select a location for the Azure Data Factory to be deployed. " -NoNewLine
            $geographyselection = GeographySelection
            $resourceGroupInformation = @{ResourceGroupName = $ResourceGroupName; DataFactoryRegion = $geographyselection.DataFactoryRegion}
            return $resourceGroupInformation
        } else {
            Write-Host "`r`nOk, let's start this part over" -ForegroundColor Yellow
            $resourceGroupInformation = DeployResourceGroup
            return $resourceGroupInformation
        }
    }
}

function GeographySelection {
     $geographylist = [ordered]@{
            [int]"1" = "US"
            [int]"2" = "Europe"
            [int]"3" = "Asia"
        }
        $datafactoryregions = @{
            "US" = "East US"
            "Europe" = "NorthEurope"
            "Asia" = "Southeast Asia"
        }
        #Prompting for geography selection, result will select default Data Factory region and list regions for that geography
        Write-Host "Which geography would you like to deploy in?`r`n"
        $geographylist.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key))" "$($_.Value)"}
        
        #Validating numeric input for RG geography
        $InputMessage = "`r`nGeography Number"
        $geographyselection = Read-Host $InputMessage
        $valid = IntValidation -UserInput $geographyselection -OptionCount $geographylist.Count
        while(!($valid.Result)){
            Write-Host $valid.Message -ForegroundColor Yellow
            $geographyselection = Read-Host $InputMessage
            $valid = IntValidation -UserInput $geographyselection -OptionCount $geographylist.Count
        }
        #$datafactoryregion = $datafactoryregions[$geographylist.[int]$geographyselection]

        return @{GeoRegion = $geographylist.[int]$geographyselection; DataFactoryRegion = $datafactoryregions[$geographylist.[int]$geographyselection]}
}