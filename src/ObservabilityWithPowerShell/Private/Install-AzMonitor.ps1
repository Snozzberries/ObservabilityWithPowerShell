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
function Install-AzMonitor {
    [CmdletBinding()]
    param (
        [string]$FolderName="ObservabilityWithPowerShell",
        [string]$LogName="ObservabilityWithPowerShell",
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
            $azure = Get-Cloud
            #Requires -Modules Az.Accounts
            Connect-AzAccount -DeviceCode
            if($azure){
                #Requires -Modules Az.Compute
                Set-AzVMExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -TypeHandlerVersion <version-number> -EnableAutomaticUpgrade $true
            }else{
                #Requires -Modules Az.ConnectedMachine
                New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -EnableAutomaticUpgrade
            }
        }
        catch {
            throw $_
        }
    }
}