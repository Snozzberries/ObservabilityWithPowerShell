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
    Describe 'Install-Tasks Private Function Tests' -Tag Unit {
        <#Context "When installing task" {
            BeforeAll {
                Mock Get-ADDomain {
                    return [PSCustomObject]@{ NetBIOSName = "TestDomain" }
                }
        
                Mock Get-Command {
                    return [PSCustomObject]@{ Source = "powershell.exe" }
                }
        
                Mock New-ScheduledTaskAction {}
                Mock New-ScheduledTaskTrigger {}
                Mock New-ScheduledTaskPrincipal {}
                Mock New-ScheduledTaskSettingsSet {}
                Mock New-ScheduledTask {}
                Mock Register-ScheduledTask {}
            }
        
            It "Should attempt to match the provided command" {
                { Install-Task -Command "Get-ObsAdds1" } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should create the script for the scheduled task" {
                { Install-Task -Command "Get-ObsAdds1" } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should set the scheduled task properties correctly" {
                { Install-Task -Command "Get-ObsAdds1" } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should register the scheduled task with the specified command" {
                { Install-Task -Command "Get-ObsAdds1" } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should throw an error if unable to identify an event ID using the command" {
                { Install-Task -Command "InvalidCommand" } | Should -Throw
                Assert-VerifiableMock
            }
        }#>
    }
} #inModule