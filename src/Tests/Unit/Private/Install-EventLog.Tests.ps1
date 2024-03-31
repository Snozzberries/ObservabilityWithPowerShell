#Requires -RunAsAdministrator
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
            It "Should create a new Event Log with specified name and sources" {
                $logName = "TestLog"
                $sources = @("Source1", "Source2")

                { Install-EventLog -LogName $logName -Sources $sources } | Should -Not -Throw
                $eventLog = Get-EventLog -List | Where-Object { $_.Log -eq $logName }

                $eventLog | Should -Not -Be $null
                $eventLog.Log | Should -Be $logName

                $eventSources = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$logName | ForEach-Object { $_.pschildname }
                $sources | ForEach-Object{ $eventSources | Should -Contain $_}
            }

            It "Should throw an error if the Event Log already exists" {
                $logName = "TestLog"
                $sources = @("Source1", "Source2")

                { Install-EventLog -LogName $logName -Sources $sources } | Should -Throw
            }

            It "Should continue with new sources if configured to do so" {
                $logName = "TestLog"
                $existingSources = @("Source1", "Source2")
                $newSources = @("Source3")

                { Install-EventLog -LogName $logName -Sources $existingSources } | Should -Throw
                $eventSources = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$logName | ForEach-Object { $_.pschildname }
                $existingSources | ForEach-Object{ $eventSources | Should -Contain $_}

                { Install-EventLog -LogName $logName -Sources $newSources -ContinueOnNewSources $true } | Should -Not -Throw
                $eventSources = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$logName | ForEach-Object { $_.pschildname }
                $newSources | ForEach-Object{ $eventSources | Should -Contain $_}
            }
        }

        Context "When configuring an existing Event Log" {
            It "Should configure the limits if the Event Log is new" {
                $logName = "TestLog"
                $size = 20MB
                $sizeKB = 20KB
                $overflowAction = "OverwriteOlder"

                { Install-EventLog -LogName $logName -Size $size -OverflowAction $overflowAction } | Should -Not -Throw
                $eventLog = Get-EventLog -List | Where-Object { $_.Log -eq $logName }

                $eventLog.MaximumKilobytes | Should -Be $sizeKB
                $eventLog.OverflowAction | Should -Be $overflowAction
            }

            It "Should throw if modifying the event log with no new sources" {
                $logName = "TestLog"
                $size = 50MB
                $overflowAction = "DoNotOverwrite"

                { Install-EventLog -LogName $logName -Size $size -OverflowAction $overflowAction } | Should -Throw
            }
        }
    } #describe_Install-EventLog
} #inModule