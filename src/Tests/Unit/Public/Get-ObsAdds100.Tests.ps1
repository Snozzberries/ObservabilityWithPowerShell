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
    Describe 'Get-ObsAdds100 Public Function Tests' -Tag Unit {
        Context "When obtaining RootDSE entry and replication data" {
            BeforeAll {
                Mock Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
        
                Mock Get-ADRootDSE {
                    param($Server)
                    if ($Server -eq "domain1") {
                        return [PSCustomObject]@{ NamingContexts = @("DC=domain1,DC=com", "CN=Configuration,DC=domain1,DC=com") }
                    }
                    elseif ($Server -eq "domain2") {
                        return [PSCustomObject]@{ NamingContexts = @("DC=domain2,DC=com", "CN=Configuration,DC=domain2,DC=com") }
                    }
                }
        
                Mock [System.DirectoryServices.ActiveDirectory.DomainController]::FindOne {
                    return [PSCustomObject]@{ 
                        GetReplicationMetadata = {
                            return [PSCustomObject]@{
                                Item = {
                                    param($Property)
                                    if ($Property -eq "dsaSignature") {
                                        return [PSCustomObject]@{ lastOriginatingChangeTime = Get-Date }
                                    }
                                }
                            }
                        }
                    }
                }
            }
    
            It "Should obtain RootDSE entry and replication data for each domain and naming context" {
                { Get-ObsAdds100 } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should append replication object with LogId, Domain, NamingContext, and lastOriginatingChangeTime properties" {
                $result = { Get-ObsAdds100 } | Should -Not -Throw
                $result | Should -BeOfType [array]
                $result | Should -HaveCount 4  # Each domain has 2 naming contexts
                $result | ForEach-Object {
                    $_ | Should -HaveMember "LogId"
                    $_ | Should -HaveMember "Domain"
                    $_ | Should -HaveMember "NamingContext"
                    $_ | Should -HaveMember "lastOriginatingChangeTime"
                }
                Assert-VerifiableMock
            }
        }
    }
} #inModule