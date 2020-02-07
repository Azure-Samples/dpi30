"current location: $(Get-Location)"
"script root: $PSScriptRoot"
"retrieve available modules"
$modules = Get-Module -list
if ($modules.name -notcontains 'az.accounts') {
    Install-Module az.accounts -Scope CurrentUser -Force -SkipPublisherCheck
}
if ($modules.Name -notcontains 'az.resources') {
    Install-Module az.resources -scope currentuser -force -SkipPublisherCheck
}
if ($modules.Name -notcontains 'pester') {
    Install-Module -Name Pester -Force -SkipPublisherCheck
}

# Long Test Password
$testpassword = "(TestThisOne1234567890)" 

# Managed Instance Test Run
$params = @{ managedInstanceName = "dpi30dbmi"; managedInstanceAdminLogin = "testlogin"; jumpboxName = "dpi30dbmi"; jumpboxAdminUsername = "testlogin"; jumpboxDnsLabelPrefix = "dpi30dbmi"; storageAccountName = "dpi30dbmi"; dataFactoryName = "dpi30dbmi"; managedInstanceAdminPassword = $testpassword; jumpboxAdminPassword = $testpassword }
$parameters = @{ ResourceGroupName = "dpi30testrg"; TemplateFile = "./managedinstance/dpi30managedinstance.json"; Parameters = $params }
$script = @{ Path = "./tests/dpi30managedinstance.tests.ps1"; Parameters = $parameters }
Invoke-Pester -Script $script -OutputFile "./Test-dpi30managedinstance.XML" -OutputFormat 'NUnitXML' 

# Modern Data Warehouse Test Run
$params = @{ azureSqlServerName = "dpi30dw"; azureSqlServerAdminLogin = "testlogin"; azureSqlServerAdminPassword = $testpassword; azureSqlDataWarehouseName = "dpi30dw"; databricksWorkspaceName = "dpi30dw"; storageAccountName = "dpi30dw"; dataFactoryName = "dpi30dw"; dataFactoryRegion = "East US" }
$parameters = @{ ResourceGroupName = "dpi30testrg"; TemplateFile = "./moderndatawarehouse/dpi30moderndatawarehouse.json"; Parameters = $params }
$script = @{ Path = "./tests/dpi30moderndatawarehouse.tests.ps1"; Parameters = $parameters }
Invoke-Pester -Script $script -OutputFile "./Test-dpi30moderndatawarehouse.XML" -OutputFormat 'NUnitXML' 

# Simple Test Run
$params = @{ azureSqlServerName = "dpi30simple"; azureSqlServerAdminLogin = "testlogin"; azureSqlServerAdminPassword = $testpassword; azureSqlDatabaseName = "dpi30simple"; storageAccountName = "dpi30simple"; dataFactoryName = "dpi30simple"; dataFactoryRegion = "East US" }
$parameters = @{ ResourceGroupName = "dpi30testrg"; TemplateFile = "./simple/dpi30simple.json"; Parameters = $params }
$script = @{ Path = "./tests/dpi30simple.tests.ps1"; Parameters = $parameters }
Invoke-Pester -Script $script -OutputFile "./Test-dpi30simple.XML" -OutputFormat 'NUnitXML' 