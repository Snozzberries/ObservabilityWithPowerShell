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
    Describe 'Get-ObsAdds200 Public Function Tests' -Tag Unit {
        Context "When obtaining KRBTGT object details" {
            BeforeAll {
                Mock Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
        
                Mock Get-ADObject {
                    param($LDAPFilter, $Server)
                    if ($LDAPFilter -eq "(serviceprincipalname=kadmin/changepw)" -and $Server -eq "domain1") {
                        return [PSCustomObject]@{ pwdLastSet = [DateTime]::ToFileTimeUtc((Get-Date)) }
                    }
                    elseif ($LDAPFilter -eq "(serviceprincipalname=kadmin/changepw)" -and $Server -eq "domain2") {
                        return [PSCustomObject]@{ pwdLastSet = [DateTime]::ToFileTimeUtc((Get-Date).AddDays(-1)) }
                    }
                }
            }
    
            It "Should obtain KRBTGT object details for each domain" {
                { Get-ObsAdds200 } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should append object with LogId, Domain, and pwdLastSet properties" {
                $result = { Get-ObsAdds200 } | Should -Not -Throw
                $result | Should -BeOfType [array]
                $result | Should -HaveCount 2
                $result | ForEach-Object {
                    $_ | Should -HaveMember "LogId"
                    $_ | Should -HaveMember "Domain"
                    $_ | Should -HaveMember "pwdLastSet"
                }
                Assert-VerifiableMock
            }
        }
    }
} #inModule