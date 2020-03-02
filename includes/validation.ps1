<#
.Synopsis
DPi30 Validation Functions

.Description
Functions to validate the naming conventions and requirements of resources created by the DPi30
#>

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

### Validation Functions ###
function ResourceGroupNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Resource Group name restrictions: alphanumeric characters, periods, underscores, hyphens and parenthesis and cannot end in a period, less than 90 characters
    if ($Name -cmatch "^[\w\-\.\(\)]{1,90}[^\.]$"){
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Resource Group name restrictions: alphanumeric characters, periods, underscores, hyphens and parenthesis and cannot end in a period, less than 90 characters"}
    }
}

function StorageAccountNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Storage Account name restrictions: Lower case leters or numbers, 3 to 24 characters
    if ($Name -cmatch "^[a-z0-9]{3,24}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Storage Account name restrictions: Lower case leters or numbers, 3 to 24 characters"}
    }
}

function DatabricksNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Databricks name restrictions: Alphanumeric characters, underscores, and hyphens are allowed, and the name must be 1-30 characters long.
    if ($Name -cmatch "^[\w-]{1,30}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Databricks name restrictions: Alphanumeric characters, underscores, and hyphens are allowed, and the name must be 1-30 characters long."}
    }
}

function DatabaseNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Database name restrictions: Alphanumeric characters, underscores 1-128 characters long.
    if ($Name -cmatch "^[\w]{1,128}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Database name restrictions: Alphanumeric characters, underscores 1-128 characters long."}
    }
}

function DatabaseServerNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Database Server name restrictions: Your server name can contain only lowercase letters, numbers, and '-', but can't start or end with '-' or have more than 63 characters.
    if ($Name -cmatch "^[^-][a-z0-9-]{1,63}(?<!-)$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Database Server name restrictions: Your server name can contain only lowercase letters, numbers, and '-', but can't start or end with '-' or have more than 63 characters."}
    }
}

function DatabaseLoginNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Login name restrictions: Your login name must not include non-alphanumeric characters and must not start with numbers or symbols
    if ($Name -cmatch "^[^0-9][a-zA-Z0-9]{1,128}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Login name restrictions: Your login name must not include non-alphanumeric characters and must not start with numbers or symbols"}
    }
}

function DataFactoryNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Data Factory name restrictions: contain only letters, numbers and hyphens. The first and last characters must be a letter or number.
    if ($Name -cmatch "^[^-][a-zA-Z0-9]{1,128}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Data Factory name restrictions: contain only letters, numbers and hyphens. The first and last characters must be a letter or number."}
    }
}

function VMNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Virtual Machine name restrictions: Alphanumeric characters, underscores, and hyphens are allowed, and the name must be 1-15 characters long.
    if ($Name -cmatch "^[\w-]{1,15}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Virtual Machine name restrictions: Alphanumeric characters, underscores, and hyphens are allowed, and the name must be 1-15 characters long."}
    }
}

function DNSPrefixValidation {
    Param(
        # Name to verify
        $Name
    )
    # DNS Prefix restrictions: Alphanumeric characters and hyphens are allowed, and the name must be 1-15 characters long.
    if ($Name -cmatch "^[a-zA-Z0-9-]{1,15}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="DNS Prefix restrictions: Alphanumeric characters and hyphens are allowed, and the name must be 1-15 characters long."}
    }
}

function vNetNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Virtual Network name restrictions: Alphanumeric characters, periods, underscores, and hyphens are allowed, and the name must be 2-64 characters long.
    if ($Name -cmatch "^[\w\.-]{2,64}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Virtual Network name restrictions: Alphanumeric characters, periods, underscores, and hyphens are allowed, and the name must be 2-64 characters long."}
    }
}

function AzureNetworkingNameValidation {
    Param(
        # Name to verify
        $Name
    )
    # Azure Network items name restrictions: Alphanumeric characters, periods, underscores, and hyphens are allowed, and the name must be 2-80 characters long.
    if ($Name -cmatch "^[\w\.-]{2,80}$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Azure Network items name restrictions: Alphanumeric characters, periods, underscores, and hyphens are allowed, and the name must be 2-64 characters long."}
    }
}

function CIDRValidation {
    Param(
        # Name to verify
        $Name
    )
    # Cidr validation regex from http://blog.markhatton.co.uk/2011/03/15/regular-expressions-for-ip-addresses-cidr-ranges-and-hostnames/
    if ($Name -cmatch "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$") {
        return @{Result=$true; Message="Valid"}
    } else {
        return @{Result=$false; Message="Please use valid CIDR notation. Example: 10.0.0.0/16"}
    }
}

#Validate yes or no question input
function BoolValidation {
    Param(
        #User input
        $UserInput
    )
    $validbool = @("y", "n", "yes", "no")
    if ($UserInput.ToLower() -in $validbool) {
        return @{Result=$true; Message="Valid"}
    }
    else {
        return @{Result=$false; Message="Please answer Yes(y) or No(n)"}
    }
}

#Validate integer based question input both as an input value but also the number of options available
function IntValidation {
    Param(
        #User input
        $UserInput,
        #Options Count to verify its within range
        $OptionCount
    )
    $intref = 0
    if( [int32]::TryParse( $UserInput , [ref]$intref ) -and [int32]$UserInput -le $OptionCount -and [int32]$UserInput -gt 0) {
        return @{Result=$true; Message="Valid"}
    }
    else {
      return @{Result=$false; Message="Please enter a valid selection number"}
    }
}

#Validating the input of a yes no for continuing with deployment, more specific than a normal boolean situation.
function ProceedValidation {
    $InputMessage = "`r`nWould you like to continue? "
    Write-Host $InputMessage -NoNewLine
    $confirmation = Read-Host
    $valid = BoolValidation -UserInput $confirmation
    while(!($valid.Result)){
        Write-Host $valid.Message -ForegroundColor Yellow
        Write-Host $InputMessage -NoNewLine
        $confirmation = Read-Host
        $valid = BoolValidation -UserInput $confirmation
    }
    if($confirmation.ToLower().SubString(0,1) -eq "n"){
        #Stop script because they said no on continuing
        Write-Host "Stopping!!! Any resources that were created up until this point were not removed and would require you to cleanup if desired" -ForegroundColor Red
        exit
    } else {
        return $confirmation.ToLower().SubString(0,1)
    }
    
}

### End Validation Functions ###