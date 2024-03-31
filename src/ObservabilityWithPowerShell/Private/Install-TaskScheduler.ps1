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
function Install-TaskScheduler {
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
            Write-Verbose "$prefixVerbose Connecting to Task Scheduler Service"
            $scheduleObject = New-Object -ComObject Schedule.Service
            $scheduleObject.Connect()

            Write-Verbose "$prefixVerbose Checking for '$FolderName'"
            $scheduleObject.GetFolder("\$FolderName")|Out-Null

            Write-Warning "$prefixInfo '$FolderName' already exists, no work needed"
            Write-EventLog @log -EventId 20 -Message "$prefixInfo '$FolderName' already exists"
        }
        Catch [System.IO.FileNotFoundException] {
            Write-Verbose "$prefixVerbose '$FolderName' not found, creating at root"
            $rootFolder = $scheduleObject.GetFolder("\")
            $rootFolder.CreateFolder("$FolderName")|Out-Null

            Write-Verbose "$prefixVerbose Writing creation event log entry"
            Write-EventLog @log -EventId 2 -Message "$prefixInfo Created Task Scheduler Folder '$FolderName'"
        }
        catch {
            throw $_
        }
    }
}