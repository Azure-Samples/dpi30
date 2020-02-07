Param(
    [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
    [string] [Parameter(Mandatory = $true)] $TemplateFile,
    [hashtable] [Parameter(Mandatory = $true)] $Parameters
)

Describe "DPi30 Managed Instance Deployment Tests" {
    BeforeAll {
        $DebugPreference = "Continue"
    }

    AfterAll {
        $DebugPreference = "SilentlyContinue"
    }

    Context "When Managed Instance deployed with parameters" {
        $output = Test-AzResourceGroupDeployment `
            -ResourceGroupName $ResourceGroupName `
            -TemplateFile $TemplateFile `
            -TemplateParameterObject $Parameters `
            -ErrorAction Stop `
            5>&1
               

        $outstring = ""
        # Find our Response information to get proper information since the amount of information returned can be variable
        foreach ($out in $output) {
            if ($out -match "============================ HTTP RESPONSE ============================") { $outstring = $out }
        }
        $outjson = (($outstring -split "Body:")[1] | ConvertFrom-Json)
        $result = $outjson.properties

        It "Should be deployed successfully" {
            $result.provisioningState | Should -Be "Succeeded"
        }
    }
}