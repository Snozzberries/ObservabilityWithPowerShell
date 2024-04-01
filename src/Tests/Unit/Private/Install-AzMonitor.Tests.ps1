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
    Describe 'Install-AzMonitor Private Function Tests' -Tag Unit {
        Context "Verbose Output" {
            It "Should output the correct verbose message" {
                $output = { Install-AzMonitor } | Should -PassThru -Verbose
                $output | Should -Contain "Not currently implemented"
            }
        }
    
        Context "Information Output" {
            It "Should output the Azure Arc installation information" {
                $output = { Install-AzMonitor } | Should -PassThru
                $output | Should -Contain "Ensure Azure Arc is installed if not running in Azure"
                $output | Should -Contain "Ensure Azure Monitor Agent is installed"
            }
        }
    }
} #inModule