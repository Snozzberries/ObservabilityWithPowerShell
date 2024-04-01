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
            Mock Install-EventLog {}
            Mock Install-TaskScheduler {}
            Mock Install-gMsa {}
            Mock Install-ObsAdds {}
            Mock Install-Monitor {}
    
            It "Should execute all installation steps" {
                { Install-Observability } | Should -Not -Throw
                Assert-VerifiableMock
            }
    
            It "Should call Install-EventLog" {
                Install-Observability
                Assert-MockCalled Install-EventLog -Exactly 1 -Scope It
            }
    
            It "Should call Install-TaskScheduler" {
                Install-Observability
                Assert-MockCalled Install-TaskScheduler -Exactly 1 -Scope It
            }
    
            It "Should call Install-gMsa" {
                Install-Observability
                Assert-MockCalled Install-gMsa -Exactly 1 -Scope It
            }
    
            It "Should call Install-ObsAdds" {
                Install-Observability
                Assert-MockCalled Install-ObsAdds -Exactly 1 -Scope It
            }
    
            It "Should call Install-Monitor" {
                Install-Observability
                Assert-MockCalled Install-Monitor -Exactly 1 -Scope It
            }
        }
    }
} #inModule