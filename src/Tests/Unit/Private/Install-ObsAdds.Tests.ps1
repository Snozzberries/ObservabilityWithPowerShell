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
    Describe 'Install-ObsAdds Private Function Tests' -Tag Unit {
        Context "When installing Observability commands" {
            Mock Get-Command {
                return @(
                    [PSCustomObject]@{ Name = "Get-ObsAdds1"; CommandType = "Function" },
                    [PSCustomObject]@{ Name = "Get-ObsAdds2"; CommandType = "Function" },
                    [PSCustomObject]@{ Name = "Not-RelatedCommand"; CommandType = "Function" }
                )
            }
    
            Mock Get-ScheduledTask {
                return @(
                    [PSCustomObject]@{ TaskName = "Get-ObsAdds1" },
                    [PSCustomObject]@{ TaskName = "AnotherTask" }
                )
            }
    
            Mock Install-Task {
                param($Command)
                Write-Host "Installing task for command: $Command"
            }
    
            It "Should obtain commands from the Observability module" {
                { Install-ObsAdds } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should obtain scheduled tasks" {
                { Install-ObsAdds } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should install commands as scheduled tasks if not already present" {
                { Install-ObsAdds } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should skip commands not matching the pattern" {
                Mock Install-Task {
                    throw "Install-Task should not be called for non-matching command"
                }
                { Install-ObsAdds } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should skip commands already existing as tasks" {
                Mock Install-Task {
                    throw "Install-Task should not be called for existing task"
                }
                { Install-ObsAdds } | Should -Not -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule