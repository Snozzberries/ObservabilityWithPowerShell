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
function Get-ObsAdds100 {
    [CmdletBinding()]
    param (
        [string[]]$Domains = (Get-ADForest).Domains
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $logId = 100
    }
    process {
        try {
            $objs = @()
            foreach($domain in $domains){
                Write-Verbose "$prefixVerbose Obtaining RootDSE entry from $domain"
                $rootDse = Get-ADRootDSE -Server $domain
                foreach($nc in $rootDse.NamingContexts){
                    $obj = [PSCustomObject]@{
                        LogId = $logId
                        Domain = $domain
                        NamingContext = $nc
                        lastOriginatingChangeTime = $null
                    }

                    $dirContext = [System.DirectoryServices.ActiveDirectory.DirectoryContext]::new("Domain",$domain)
                    $domainController = [System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($dirContext)
                    Write-Verbose "$prefixVerbose Obtaining replication data from $domainController for $nc"
                    $replMetadata = $domainController.GetReplicationMetadata($nc)
                    $sig = $replMetadata.Item("dsaSignature")
                    $obj.lastOriginatingChangeTime = $sig.lastOriginatingChangeTime

                    Write-Verbose "$prefixVerbose Appending replication object $($obj|ConvertTo-Json -Compress)"
                    $objs += $obj
                }
            }
            Write-Verbose "$prefixVerbose Returing $($objs.Count) objects"
            return $objs
        }
        catch {
            throw $_
        }
    }
}