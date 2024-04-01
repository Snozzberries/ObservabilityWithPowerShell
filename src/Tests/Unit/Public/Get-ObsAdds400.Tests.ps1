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
    Describe 'Get-ObsAdds400 Public Function Tests' -Tag Unit {
        Context "When obtaining Group Policy Objects" {
            BeforeAll {
                function Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
        
                function Get-ADDomain {
                    param($Server)
                    if ($Server -eq "domain1") {
                        return [PSCustomObject]@{ InfrastructureMaster = "DC1.domain1.com" }
                    }
                    elseif ($Server -eq "domain2") {
                        return [PSCustomObject]@{ InfrastructureMaster = "DC1.domain2.com" }
                    }
                }
        
                function Get-GPO {
                    param($Server)
                    if ($Server -eq "DC1.domain1.com") {
                        return @(
                            [PSCustomObject]@{ DisplayName = "GPO1"; GpoId = "1" },
                            [PSCustomObject]@{ DisplayName = "GPO2"; GpoId = "2" }
                        )
                    }
                    elseif ($Server -eq "DC1.domain2.com") {
                        return @(
                            [PSCustomObject]@{ DisplayName = "GPO3"; GpoId = "3" }
                        )
                    }
                }
            }
    
            It "Should obtain Group Policy Objects for each domain" {
                { Get-ObsAdds400 } | Should -Not -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule