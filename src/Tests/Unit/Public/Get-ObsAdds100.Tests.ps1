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
                function Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
        
                function Get-ADRootDSE {
                    param($Server)
                    if ($Server -eq "domain1") {
                        return [PSCustomObject]@{ NamingContexts = @("DC=domain1,DC=com", "CN=Configuration,DC=domain1,DC=com") }
                    }
                    elseif ($Server -eq "domain2") {
                        return [PSCustomObject]@{ NamingContexts = @("DC=domain2,DC=com", "CN=Configuration,DC=domain2,DC=com") }
                    }
                }
            }

        }
    }
} #inModule