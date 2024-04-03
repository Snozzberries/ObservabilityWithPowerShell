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
    Install-EventLog
    Install-TaskScheduler
    if(-not(Get-Module -name "ActiveDirectory")){
        if(Get-Module -ListAvailable|Where-Object {$_.name -eq "ActiveDirectory"}){
            Import-Module -Name "ActiveDirectory"
        }else{
            throw "[Error] Unable to load dependency module ActiveDirectory"
        }
    }
    Install-gMsa
    Install-ObsAdds
    Install-AzMonitor
}

