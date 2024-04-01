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
    Describe 'Install-KdsRootKey Private Function Tests' -Tag Unit {
        Context "When requesting KDS Root Keys" {
            BeforeAll {        
                function Test-KdsRootKey {
                    return $true
                }
                function Get-KdsRootKey {
                    return @(
                        [PSCustomObject]@{ KeyId = "Key1"; IsFormatValid = $true; EffectiveTime = (Get-Date).AddDays(-1) },
                        [PSCustomObject]@{ KeyId = "Key2"; IsFormatValid = $true; EffectiveTime = (Get-Date).AddDays(1) }
                    )
                }
            }
    
            It "Should request KDS Root Keys" {
                { Install-KdsRootKey } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should detect functional KDS Root Keys" {
                $result = Install-KdsRootKey
                $result | Should -BeLike "*KDS Root Key appears functional*"
                Assert-VerifiableMock
            }
        }
        Context "Fail to create" {
            It "Should throw an error if adding a new KDS Root Key fails" {
                BeforeAll {
                    function Add-KdsRootKey {
                        throw "Failed to add KDS Root Key"
                    }
                }
                { Install-KdsRootKey } | Should -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule