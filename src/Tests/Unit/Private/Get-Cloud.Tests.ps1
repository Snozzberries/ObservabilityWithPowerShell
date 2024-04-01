#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'ObservabilityWithPowerShell'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'ObservabilityWithPowerShell' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Get-Cloud Private Function Tests' -Tag Unit {
        Context "When connecting to Azure IMDS" {
            BeforeAll {
                Mock -CommandName Invoke-RestMethod {
                    return @{
                        compute = @{
                            azEnvironment = "AzurePublicCloud"
                        }
                    }
                }
            }
    
            It "Should identify Azure Commercial Cloud" {
                $result = Get-Cloud
                $result | Should -BeExactly $true
                Assert-VerifiableMock
            }
        }
    
        Context "When identified as restricted Azure Cloud" {
            BeforeAll {
                Mock Invoke-RestMethod {
                    return @{
                        compute = @{
                            azEnvironment = "AzureRestrictedCloud"
                        }
                    }
                }
            }
    
            It "Should identify as a restricted Azure Cloud" {
                $result = Get-Cloud
                $result | Should -BeExactly $true
                Assert-VerifiableMock
            }
        }
    
        Context "When not identified as Azure VM or Azure Arc" {
            BeforeAll {
                Mock Invoke-RestMethod {
                    return @{
                        compute = @{
                            azEnvironment = "SomeOtherCloud"
                        }
                    }
                }
            }
    
            It "Should not be identified as Azure Cloud" {
                $result = Get-Cloud
                $result | Should -BeExactly $false
                Assert-VerifiableMock
            }
        }
    }        
} #inModule