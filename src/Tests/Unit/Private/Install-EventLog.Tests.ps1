[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
param()
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
    Describe 'Install-EventLog Private Function Tests' -Tag Unit {
        Context "When installing a new Event Log" {
            BeforeAll {
                function New-EventLog {}
                function Write-EventLog {}
                function Limit-EventLog {}
            }
            $logName = "System"
            $sources = @("EventLog")
            It "Should not throw" {
                { Install-EventLog -LogName $logName -Source $sources } | Should -Not -Throw
            }
        }
    } #describe_Install-EventLog
} #inModule