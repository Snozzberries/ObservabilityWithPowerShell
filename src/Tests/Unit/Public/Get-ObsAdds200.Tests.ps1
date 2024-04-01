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
                function Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
        
                function Get-ADObject {
                    param($LDAPFilter, $Server)
                    if ($LDAPFilter -eq "(serviceprincipalname=kadmin/changepw)" -and $Server -eq "domain1") {
                        return [PSCustomObject]@{ pwdLastSet = (Get-Date).ToFileTimeUtc() }
                    }
                    elseif ($LDAPFilter -eq "(serviceprincipalname=kadmin/changepw)" -and $Server -eq "domain2") {
                        return [PSCustomObject]@{ pwdLastSet = (Get-Date).AddDays(-1).ToFileTimeUtc() }
                    }
                }
            }
    
            It "Should obtain KRBTGT object details for each domain" {
                { Get-ObsAdds200 } | Should -Not -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule