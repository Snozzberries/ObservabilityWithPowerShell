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
function Install-EventLog {
    [CmdletBinding()]
    param (
        [string]$LogName="ObservabilityWithPowerShell",
        [string[]]$Sources=@("Observability"),
        [string]$OverflowAction="OverwriteAsNeeded",
        [int]$Size=20MB,
        [bool]$ContinueOnNewSources=$true
    )
    begin {
        $prefixError = "[Error][$($MyInvocation.MyCommand.Name)]"
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $prefixInfo = "[Info][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            Write-Verbose "$prefixVerbose Obtaining Event Log List"
            $logs=Get-EventLog -List
            Write-Verbose "$prefixVerbose Obtained $($logs.count) Event Logs"

            Write-Verbose "$prefixVerbose Checking for existing log"
            if ($logs.Log -contains $LogName) {
                Write-Verbose "$prefixVerbose The '$LogName' Log Name already exists"
                $exists = $true

                Write-Verbose "$prefixVerbose Obtaining Log Sources for $LogName"
                $existing = (Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName).pschildname
                Write-Verbose "$prefixVerbose Obtained $($existing.count) log sources"

                Write-Verbose "$prefixVerbose Identifying any overlapping event sources"
                $compare = Compare-Object $existing $sources -IncludeEqual
                Write-Verbose "$prefixVerbose $($compare.count) event sources"
                $overlap = ($compare|Where-Object{$_.SideIndicator -eq "=="}).InputObject

                if ($ContinueOnNewSources -and $overlap) {
                    Write-Verbose "$prefixVerbose Skipping existing event sources"
                    $Sources = ($compare|Where-Object{$_.SideIndicator -eq "=>"}).InputObject
                }

                if ($overlap -and $Sources.Count -eq 0) {
                    Write-Verbose "$prefixVerbose Found existing event sources, throwing error"
                    throw "$prefixError $($overlap.count) Log Sources already exist in the $LogName log"
                }
            }

            Write-Verbose "$prefixVerbose Registering $($sources.count) event sources"
            foreach ($source in $sources) {
                Write-Verbose "$prefixVerbose Registering '$source' event source in '$LogName'"
                New-EventLog -LogName $LogName -Source $source -ErrorAction Stop

                $log = @{
                    LogName   = $LogName
                    EntryType = "Information"
                    Source    = $source
                    Category  = 0
                    EventId   = 1
                    Message   = "$prefixInfo Implementing $LogName with source $source"
                }
                Write-Verbose "$prefixVerbose Writing '$source' event log entry"
                Write-EventLog @log
            }

            if (-not $exists) {
                Write-Verbose "$prefixVerbose First run configuration"

                Write-Verbose "$prefixVerbose Configuring limits for the '$LogName' Event Log"
                Limit-EventLog -LogName $LogName -OverflowAction $OverflowAction -MaximumSize $Size
            }
        }
        catch {
            throw $_
        }
    }
}