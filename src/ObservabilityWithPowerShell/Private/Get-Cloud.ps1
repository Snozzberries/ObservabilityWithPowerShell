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
function Get-Cloud {
    [CmdletBinding()]
    param ()
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            $azure = $false
            $imdsSplat = @{
                Uri        = "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
                Headers    = @{"Metadata"="true"}
                Method     = "GET"
                TimeoutSec = 3
            }
            Write-Verbose "$prefixVerbose Attempting connection to Azure IMDS"
            $imds = Invoke-RestMethod @imdsSplat
            if($imds.compute.azEnvironment -eq "AzurePublicCloud"){
                Write-Verbose "$prefixVerbose Successfully identified as Azure Commercial Cloud"
                $azure = $true
                return $azure
            }elseif($imds.compute.azEnvironment -like "Azure*"){
                Write-Verbose "$prefixVerbose Identified as a restricted Azure Cloud"
                $azure = $true
                return $azure
            }else{
                Write-Verbose "$prefixVerbose Unable to identify as an Azure VM attempting Azure Arc install"
                return $azure
            }
        }
        catch {
            throw $_
        }
    }
}