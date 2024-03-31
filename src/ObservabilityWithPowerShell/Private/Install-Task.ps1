<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    C:\PS>
    Example of how to use this cmdlet
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    ObservabilityWithPowerShell
#>
function Install-Task {
    [CmdletBinding()]
    param (
        [string]$FolderName="ObservabilityWithPowerShell",
        [string]$LogName="ObservabilityWithPowerShell",
        [string]$Source="Observability"
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $prefixInfo = "[Info][$($MyInvocation.MyCommand.Name)]"

        $log = @{
            LogName   = $LogName
            EntryType = "Information"
            Source    = $source
            Category  = 0
        }
    }
    process {
        try {
            #foreach command foreach object returned write event log
            $command = Get-Command powershell.exe
            $at = (Get-Date).AddSeconds(10)
            $actions = New-ScheduledTaskAction -Execute $command.Source -Argument "-Command `"& {Write-EventLog -LogName 'Sentinel' -EntryType Information -Source '$source' -Category 0 -EventId 10 -Message (Get-SmbOpenFile|ConvertTo-Json)}`""
            $trigger = New-ScheduledTaskTrigger -Daily -At $at
            $trigger.Repetition = (New-ScheduledTaskTrigger -Once -At $at -RepetitionDuration (New-TimeSpan -Hours 23) -RepetitionInterval (New-TimeSpan -Hours 1)).Repetition
            $principal = New-ScheduledTaskPrincipal -UserId "TEST\Sentinel$" -RunLevel Highest -LogonType Password
            $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun -ExecutionTimeLimit (New-TimeSpan -Minutes 15)
            $task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings
            Register-ScheduledTask "Get-SMBConnection" -TaskPath "\Sentinel" -InputObject $task
        }
        catch {
            throw $_
        }
    }
}