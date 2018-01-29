#
# This tests whether the ARM template for Logic App has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $TemplateFile,
    [hashtable] [Parameter(Mandatory=$true)] $Parameters
)

Describe "Logic App Deployment Tests" {
    # Init
    BeforeAll {
        $DebugPreference = "Continue"
    }

    # Teardown
    AfterAll {
        $DebugPreference = "SilentlyContinue"
    }

    # Tests whether the cmdlet throws an exception or not.
    Context "When Logic App deployed without parameters" {
        try {
            $output = Test-AzureRmResourceGroupDeployment `
                          -ResourceGroupName $ResourceGroupName `
                          -TemplateFile $TemplateFile `
                          -logicAppName1 $null `
                          -logicAppName2 $null `
                          -ErrorAction Stop `
                           5>&1
        }
        catch {
            $ex = $_.Exception | Format-List -Force
        }

        It "Should throw exception" {
            $ex | Should -Not -Be $null
            $ex.Message | Should -Not -Be ([string]::Empty)
        }
    }

    # Tests whether the cmdlet returns value or not.
    Context "When Logic App deployed with parameters" {
        $output = Test-AzureRmResourceGroupDeployment `
                      -ResourceGroupName $ResourceGroupName `
                      -TemplateFile $TemplateFile `
                      -TemplateParameterObject $Parameters `
                      -ErrorAction Stop `
                       5>&1
        $result = (($output[32] -split "Body:")[1] | ConvertFrom-Json).properties

        It "Should be deployed successfully" {
            $result.provisioningState | Should -Be "Succeeded"
        }

        It "Should have name of" {
            $expected = $Parameters.LogicAppName1 + "-" + $Parameters.LogicAppName2
            $resource = $result.validatedResources[0]

            $resource.name | Should -Be $expected
        }
    }
}
