[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
param()
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

            function Get-ADComputer {
                return "computer1"
            }

            Mock Install-KdsRootKey {}

            function Test-ADServiceAccount {
                return $true
            }
        }

        Context "When requesting service accounts" {
            BeforeAll {
                function Get-ADServiceAccount {
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
                $result = Install-gMsa -Identity "Observability"
                $result | Should -BeLike "*Service Account appears functional*"
                Assert-VerifiableMock
            }
        }

        Context "Create gMSAs" {
            BeforeAll {
                function New-ADServiceAccount {
                    return [PSCustomObject]@{ Name = "Unknown" }
                }

                function Get-ADServiceAccount {
                    return @()
                }
                function Get-ADDomain {}
            }

            It "Should create a new gMSA if none found" {
                $result = Install-gMsa -Identity "Unknown"
                $result | Should -BeLike "*No valid gMSA found, creating*"
                Assert-VerifiableMock
            }
        }

        Context "Fail to create gMSA" {
            It "Should throw an error if new gMSA creation fails" {
                BeforeAll {
                    function New-ADServiceAccount {
                        throw "Failed to create gMSA"
                    }
                }
                { Install-gMsa -Identity "Observability" } | Should -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule