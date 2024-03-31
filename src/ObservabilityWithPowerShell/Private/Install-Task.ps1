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
        [string]$Source="Observability",
        [string]$gMSA="$((Get-ADDomain).NetBIOSName)\$source`$",
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            Write-Verbose "$prefixVerbose Attempting match for $command"
            $match = $Command -match "[0-9]+$"
            if(-not $match){
                Write-Verbose "$prefixVerbose Match failed"
                throw "$prefixError Unable to identify an event ID using $command"
            }
            $eventId = $Matches.0
            $writeEvent = "Write-EventLog -LogName '$LogName' -EntryType Information -Source '$Source' -Category 0 -EventId $eventId -Message"
            Write-Verbose "$prefixVerbose Created $script"
            $script = "$command|ForEach-Object{$writeEvent (`$_|ConvertTo-Json -Compress)}"

            $binary = Get-Command powershell.exe
            $actionSplat = @{
                Execute  = $binary.Source
                Argument = "-Command `"& {$script}`""
            }
            $actions = New-ScheduledTaskAction @actionSplat
            $at = (Get-Date).AddSeconds(10)
            Write-Verbose "$prefixVerbose Set first run $at"
            $trigger = New-ScheduledTaskTrigger -Daily -At $at
            $repeate = New-ScheduledTaskTrigger -Once -At $at -RepetitionDuration (New-TimeSpan -Hours 23) -RepetitionInterval (New-TimeSpan -Hours 1)
            $trigger.Repetition = $repeate.Repetition
            Write-Verbose "$prefixVerbose Setting run as principal to $gMSA"
            $principal = New-ScheduledTaskPrincipal -UserId "$gMSA" -RunLevel Highest -LogonType Password
            $settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun -ExecutionTimeLimit (New-TimeSpan -Minutes 15)
            $task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings
            Write-Verbose "$prefixVerbose Registering scheduled task as $Command"
            Register-ScheduledTask "$Command" -TaskPath "\$FolderName" -InputObject $task
        }
        catch {
            throw $_
        }
    }
}