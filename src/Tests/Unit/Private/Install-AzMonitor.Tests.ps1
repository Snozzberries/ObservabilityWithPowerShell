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
            It "Should not throw" {
                { Install-AzMonitor } | Should -Not -Throw
            }
        }
    
        Context "Information Output" {
            It "Should output the Azure Arc installation information" {
                $output = Install-AzMonitor
                $output.Count | Should -Be 2
                $output | ForEach-Object {
                    $_ | Should -BeLike "*Ensure Azure*"
                }
            }
        }
    }
} #inModule