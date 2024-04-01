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
function Install-ObsAdds {
    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', 'Get-ObsAdds')]
    param (
        [string]$Source="Observability"
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            Write-Verbose "$prefixVerbose Obtaining commands from module"
            $commands = Get-Command -Module ObservabilityWithPowerShell
            Write-Verbose "$prefixVerbose Obtaining scheduled tasks"
            $tasks = Get-ScheduledTask -TaskPath "\$Source"
            foreach($command in $commands){
                if($command.Name -notmatch "Get-ObsAdds[0-9]+"){
                    Write-Verbose "$prefixVerbose Command does not match pattern, skipping $($command.Name)"
                    continue
                }
                if($command.Name -in $tasks.TaskName){
                    Write-Verbose "$prefixVerbose Command already exists as task, skipping $($command.Name)"
                    continue
                }
                Write-Verbose "$prefixVerbose Installing $($command.Name)"
                Install-Task -Command $command.Name
            }
        }
        catch {
            throw $_
        }
    }
}