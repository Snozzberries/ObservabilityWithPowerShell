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
function Install-Observability {
    [CmdletBinding()]
    param (
        # [Parameter(Mandatory = $true,
        #     HelpMessage = 'Helpful Message')]
        # [ValidateNotNull()]
        # [ValidateNotNullOrEmpty()]
        # [string]$YourParameter
    )
    $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
    Write-Verbose "$prefixVerbose Calling [Install-EventLog]"
    Install-EventLog
    Write-Verbose "$prefixVerbose Calling [Install-TaskScheduler]"
    Install-TaskScheduler
    Write-Verbose "$prefixVerbose Validating module dependency"
    if(-not(Get-Module -Name "ActiveDirectory" -Verbose:$false)){
        if(Get-Module -ListAvailable -Verbose:$false|Where-Object {$_.name -eq "ActiveDirectory"}){
            Import-Module -Name "ActiveDirectory" -Verbose:$false
        }
        else{
            throw "[Error] Unable to load dependency module ActiveDirectory"
        }
    }
    Write-Verbose "$prefixVerbose Calling [Install-gMsa]"
    Install-gMsa
    Write-Verbose "$prefixVerbose Calling [Install-ObsAdds]"
    Install-ObsAdds
    Write-Verbose "$prefixVerbose Calling [Install-AzMonitor]"
    Install-AzMonitor
}

