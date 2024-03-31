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
function Get-ObsAdds200 {
    [CmdletBinding()]
    param (
        [string[]]$Domains = (Get-ADForest).Domains
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $logId = 200
    }
    process {
        try {
            $objs = @()
            foreach($domain in $domains){
                $objSplat = @{
                    LDAPFilter = "(serviceprincipalname=kadmin/changepw)"
                    Properties = "pwdLastSet"
                    Server = $domain
                }
                Write-Verbose "$prefixVerbose Obtaining KRBTGT for $domain"
                $krbtgtObj = Get-ADObject @objSplat
                Write-Verbose "$prefixVerbose Converting datetime stamp from $($krbtgtObj.pwdLastSet)"
                $pwdLastSet = [datetime]::FromFileTime($krbtgtObj.pwdLastSet)
                $obj = [PSCustomObject]@{
                    LogId = $logId
                    Domain = $domain
                    pwdLastSet = $pwdLastSet
                }
                Write-Verbose "$prefixVerbose Appending object $($obj|ConvertTo-Json -Compress)"
                $objs += $obj
            }
            Write-Verbose "$prefixVerbose Returing $($objs.Count) objects"
            return $objs
        }
        catch {
            throw $_
        }
    }
}