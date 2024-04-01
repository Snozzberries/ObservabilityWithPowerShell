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
    Describe 'Get-ObsAdds10 Public Function Tests' -Tag Unit {
        Context "When obtaining domain details" {
            BeforeAll {
                Mock Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
                
        
                Mock Get-ADDomain {
                    param($Server)
                    if ($Server -eq "domain1") {
                        return [PSCustomObject]@{ DNSRoot = "domain1.com"; DistinguishedName = "DC=domain1,DC=com"; Name = "domain1"; DomainMode = "Windows2008Domain" }
                    }
                    elseif ($Server -eq "domain2") {
                        return [PSCustomObject]@{ DNSRoot = "domain2.com"; DistinguishedName = "DC=domain2,DC=com"; Name = "domain2"; DomainMode = "Windows2012R2Domain" }
                    }
                }
            }
    
            It "Should obtain domain details for each domain" {
                { Get-ObsAdds10 } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should append replication object with LogId and Domain properties" {
                $result = { Get-ObsAdds10 } | Should -Not -Throw
                $result | Should -BeOfType [array]
                $result | Should -HaveCount 2
                $result | ForEach-Object {
                    $_ | Should -HaveMember "LogId"
                    $_ | Should -HaveMember "Domain"
                }
                Assert-VerifiableMock
            }
        }
    }
} #inModule