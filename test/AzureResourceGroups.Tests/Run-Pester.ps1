#
# This invokes pester test run.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $TestFilePath,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$true)] $OutputDirectory,
    [string] [Parameter(Mandatory=$true)] $CodeCoverageOutputDirectory,
    [string] [Parameter(Mandatory=$true)] $Username,
    [string] [Parameter(Mandatory=$true)] $Password,
    [string] [Parameter(Mandatory=$true)] $TenantId
)

$segment = $TestFilePath.Split("\")
$testFile = $segment[$segment.Length - 1].Replace(".ps1", "");
$parameters = @{ $ResourceGroupName = $ResourceGroupName; SrcDirectory = $SrcDirectory; Username = $Username; Password = $Password; TenantId = $TenantId }
$script = @{ Path = $TestFilePath; Parameters = $parameters }

Invoke-Pester -Script $script `
    -OutputFile "$OutputDirectory\TEST-$testFile.xml" -OutputFormat NUnitXml `
    -CodeCoverageOutputFile "$CodeCoverageOutputDirectory\Coverage-$testFile.xml" -CodeCoverageOutputFileFormat JaCoCo
