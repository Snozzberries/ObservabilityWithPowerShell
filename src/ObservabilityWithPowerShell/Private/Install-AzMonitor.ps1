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
            Write-Verbose "$prefixVerbose Not currently implemented"
            Write-Output "$prefixInformation Ensure Azure Arc is installed if not running in Azure https://learn.microsoft.com/en-us/azure/azure-arc/servers/onboard-powershell"
            Write-Output "$prefixInformation Ensure Azure Monitor Agent is installed https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-manage"
            <#
            $azure = Get-Cloud
            #Requires -Modules Az.Accounts
            #Connect-AzAccount -DeviceCode

            #Check for Sub
            #Check for RG or create
            #Check for LAW or create
            ##Check for Data Collection Rule with data source "ObservabilityWithPowerShell!*" or create
            ###Check for resource in DCR or add
            ##Check for Workbook or call Install-AzWorkbook

            Search-AzGraph
            resources
            | where resourceGroup in~ ("RG-ComputeModernOperations")
            | where type in~ ("microsoft.compute/virtualmachines","microsoft.hybridcompute/machines","microsoft.compute/virtualmachinescalesets","microsoft.azurestackhci/virtualmachines","microsoft.connectedvmwarevsphere/virtualmachines","microsoft.containerservice/managedclusters","microsoft.compute/virtualmachinescalesets/virtualmachines")
            | where location in~ ("eastus","eastus2","southcentralus","westus2","westus3","australiaeast","southeastasia","northeurope","swedencentral","uksouth","westeurope","centralus","southafricanorth","centralindia","eastasia","japaneast","koreacentral","canadacentral","francecentral","germanywestcentral","italynorth","norwayeast","polandcentral","switzerlandnorth","uaenorth","brazilsouth","israelcentral","qatarcentral","northcentralus","westus","japanwest","westcentralus","southafricawest","australiacentral","australiacentral2","australiasoutheast","koreasouth","southindia","westindia","canadaeast","francesouth","germanynorth","norwaywest","switzerlandwest","ukwest","uaecentral","brazilsoutheast")

            | where type  !in~ ('microsoft.web/serverfarms', 'microsoft.network/loadbalancers')
                        or (type =~ 'microsoft.web/serverfarms' and tolower(sku.tier) !in~ ('free', 'shared', 'consumption')) 
                        or (type =~ 'microsoft.network/loadbalancers' and tolower(sku.name) == 'standard')
            | order by tolower(name) asc
            | project id,name,location,type,kind,properties,sku

            #Checks for AuthZ, Network, Storage

            if($azure){
                #Requires -Modules Az.Compute
                #Set-AzVMExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -TypeHandlerVersion <version-number> -EnableAutomaticUpgrade $true
            }else{
                #Requires -Modules Az.ConnectedMachine
                #https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-manage?tabs=azure-powershell#virtual-machine-extension-details
                #Connect-AzConnectedMachine -ResourceGroupName myResourceGroup -Name myMachineName -Location <region>
                #New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -EnableAutomaticUpgrade
            }
            #>
        }
        catch {
            throw $_
        }
    }
}