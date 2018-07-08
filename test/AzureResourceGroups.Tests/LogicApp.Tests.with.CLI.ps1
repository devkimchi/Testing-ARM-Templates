﻿#
# This tests whether the ARM template for Logic App has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $TemplateFile,
    [string] [Parameter(Mandatory=$true)] $TemplateParameterFile,
    [hashtable] [Parameter(Mandatory=$true)] $Parameters
)

Describe "Logic App Deployment Tests" {
    # Tests whether the cmdlet returns value or not.
    Context "When Logic App deployed with parameters" {
        $output = az group deployment validate `
            -g $ResourceGroupName `
            --template-file $TemplateFile `
            --parameters `@$TemplateParameterFile `
            | ConvertFrom-Json
        
        $result = $output.properties

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