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
function Get-ObsAdds10 {
    [CmdletBinding()]
    param (
        [string[]]$Domains = (Get-ADForest).Domains
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $logId = 10
    }
    process {
        try {
            $objs = @()
            foreach($domain in $domains){
                Write-Verbose "$prefixVerbose Obtaining domain details for $domain"
                $obj = Get-ADDomain -Server $domain
                $selectSplat = @{
                    InputObject = $obj
                    Property = @("DNSRoot","DistinguishedName","Name","DomainMode")
                }
                $obj = Select-Object @selectSplat
                $obj|Add-Member -MemberType NoteProperty -Name "LogId" -Value $logId
                $obj|Add-Member -MemberType NoteProperty -Name "Domain" -Value $domain
                Write-Verbose "$prefixVerbose Appending replication object $($obj|ConvertTo-Json -Compress)"
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