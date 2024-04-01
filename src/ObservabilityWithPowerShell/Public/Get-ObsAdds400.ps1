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
function Get-ObsAdds400 {
    [CmdletBinding()]
    param (
        [string[]]$Domains = (Get-ADForest).Domains
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $logId = 400
    }
    process {
        try {
            $objs = @()
            foreach($domain in $domains){
                Write-Verbose "$prefixVerbose Identifying the Infrastrcuture Master in $domain"
                $domainController = (Get-ADDomain -Server $domain).InfrastructureMaster
                Write-Verbose "$prefixVerbose Obtaining group policy objects from $domainController"
                $gpos = Get-GPO -All -Server $domainController
                $gpos|Add-Member -MemberType NoteProperty -Name "LogId" -Value $logId
                $gpos|Add-Member -MemberType NoteProperty -Name "Domain" -Value $domain
                Write-Verbose "$prefixVerbose Appending $($gpos.Count) objects $($obj|ConvertTo-Json -Compress)"
                $objs += $gpos|Select-Object *
            }
            Write-Verbose "$prefixVerbose Returing $($objs.Count) objects"
            return $objs
        }
        catch {
            throw $_
        }
    }
}