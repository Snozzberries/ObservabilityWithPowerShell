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
    Describe 'Install-gMsa Private Function Tests' -Tag Unit {
        BeforeAll {
            Mock Install-KdsRootKey {}
        }

        Context "When requesting service accounts" {
            BeforeAll {
                Mock Get-ADServiceAccount {
                    return @(
                        [PSCustomObject]@{ Name = "Observability"; Enabled = $true; ObjectClass = "msDS-GroupManagedServiceAccount" }
                    )
                }
            }

            It "Should request service accounts with the specified identity" {
                { Install-gMsa -Identity "Observability" } | Should -Not -Throw
                Assert-VerifiableMock
            }

            It "Should detect functional service accounts" {
                BeforeAll {
                    Mock Test-ADServiceAccount {
                        return $true
                    }
                }
                $result = { Install-gMsa -Identity "Observability" } | Should -PassThru
                $result | Should -Contain "Service Account appears functional Observability"
                Assert-VerifiableMock
            }

            It "Should create a new gMSA if none found" {
                BeforeAll {
                    Mock New-ADServiceAccount {
                        return [PSCustomObject]@{ Name = "Observability" }
                    }
                    Mock Test-ADServiceAccount {
                        return $true
                    }
                }
                $result = { Install-gMsa -Identity "Observability" } | Should -PassThru
                $result | Should -Contain "No valid gMSA found, creating"
                Assert-VerifiableMock
            }

            It "Should throw an error if new gMSA creation fails" {
                BeforeAll {
                    Mock New-ADServiceAccount {
                        throw "Failed to create gMSA"
                    }
                }
                { Install-gMsa -Identity "Observability" } | Should -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule