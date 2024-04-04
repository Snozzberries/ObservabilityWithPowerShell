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
        [string]$Identity = "Observability",
        [string[]]$Principals = @((Get-ADComputer $env:COMPUTERNAME))
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $prefixInfo = "[Info][$($MyInvocation.MyCommand.Name)]"
        $prefixError = "[Error][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        Install-KdsRootKey

        Write-Verbose "$prefixVerbose Requesting all service accounts with -Identity $Identity"
        $serviceAccounts = Get-ADServiceAccount -Identity $Identity
        $validGmsa = $false
        foreach($serviceAccount in $serviceAccounts){
            $enabled = $serviceAccount.Enabled
            $class = $serviceAccount.ObjectClass -eq "msDS-GroupManagedServiceAccount"

            if(-not $enabled){
                Write-Verbose "$prefixVerbose Service Account is disabled $($serviceAccount.Name)"
            }
            if(-not $class){
                Write-Verbose "$prefixVerbose Service Account is not a gMSA $($serviceAccount.Name)"
            }
            if($enabled -and $class){
                $gmsaTest = Test-ADServiceAccount -Identity $serviceAccount.Name
                if($gmsaTest){
                    $validGmsa = $true
                    Write-Output "$prefixInfo Service Account appears functional $($serviceAccount.Name)"
                }
            }
        }
        
        try {
            if(-not $validGmsa){
                #What if account exists but is disabled?
                Write-Output "$prefixInfo No valid gMSA found, creating"
                $newGmsa = New-ADServiceAccount -Name $Identity -PrincipalsAllowedToRetrieveManagedPassword $Principals -SamAccountName $Identity
                $gmsaTest = Test-ADServiceAccount -Identity Observability
                if(-not $gmsaTest){
                    throw "$prefixError Failed to successfully test the new gMSA $($newGmsa.Name)"
                }
            }
        }
        catch {
            throw $_
        }
    }
}