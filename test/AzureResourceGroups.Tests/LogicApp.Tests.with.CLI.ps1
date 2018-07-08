#
# This tests whether the ARM template for Logic App has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$true)] $Username,
    [string] [Parameter(Mandatory=$true)] $Password,
    [string] [Parameter(Mandatory=$true)] $TenantId
)

Describe "Logic App Deployment Tests" {
    # Init
    BeforeAll {
        az login --service-principal -u $Username -p $Password -t $TenantId
    }

    # Teardown
    AfterAll {
    }

    # Tests whether the cmdlet returns value or not.
    Context "When Logic App deployed with parameters" {
        $output = az group deployment validate `
            -g $ResourceGroupName `
            --template-file $SrcDirectory\LogicApp.json `
            --parameters `@$SrcDirectory\LogicApp.parameters.json `
            | ConvertFrom-Json
        
        $result = $output.properties

        It "Should be deployed successfully" {
            $result.provisioningState | Should -Be "Succeeded"
        }

        It "Should have name of" {
            $expected = "log-app"
            $resource = $result.validatedResources[0]

            $resource.name | Should -Be $expected
        }
    }
}
