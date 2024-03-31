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
function Install-gMsa {
    [CmdletBinding()]
    param (
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
            Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
            #Make sure AD WS is enabled and 9389 is allowed
            New-ADServiceAccount -Name "$Source" -PrincipalsAllowedToRetrieveManagedPassword (Get-ADComputer $env:COMPUTERNAME) -SamAccountName "$Source"
            Test-ADServiceAccount -Identity Observability
        }
        catch {
            throw $_
        }
    }
}