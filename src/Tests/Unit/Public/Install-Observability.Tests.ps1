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
    Describe 'Install-Observability Public Function Tests' -Tag Unit {
        Context "When executing Install-Observability" {
            BeforeAll {
                Mock Install-EventLog {}
                Mock Install-TaskScheduler {}
                Mock Install-gMsa {}
                Mock Install-ObsAdds {}
                Mock Install-AzMonitor {}
            }
        
            It "Should execute all installation steps" {
                $modules = Get-Module -ListAvailable
                if($modules -contains "ActiveDirectory"){
                    { Install-Observability } | Should -Not -Throw
                    Assert-VerifiableMock
                }
                else{
                    { Install-Observability } | Should -Throw
                }
            }
        }
    }
} #inModule