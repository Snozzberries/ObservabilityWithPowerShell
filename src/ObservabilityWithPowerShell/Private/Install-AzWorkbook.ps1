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
function Install-AzWorkbook {
    [CmdletBinding()]
    param ()
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            Write-Verbose "$prefixVerbose Not currently implemented"
            <#
            {
            "contentVersion": "1.0.0.0",
            "parameters": {
                "workbookDisplayName": {
                "type": "string",
                "defaultValue": "WIP-OpsObserve",
                "metadata": {
                    "description": "The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
                }
                },
                "workbookType": {
                "type": "string",
                "defaultValue": "workbook",
                "metadata": {
                    "description": "The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is 'workbook'"
                }
                },
                "workbookSourceId": {
                "type": "string",
                "defaultValue": "azure monitor",
                "metadata": {
                    "description": "The id of resource instance to which the workbook will be associated"
                }
                },
                "workbookId": {
                "type": "string",
                "defaultValue": "[newGuid()]",
                "metadata": {
                    "description": "The unique guid for this workbook instance"
                }
                }
            },
            "resources": [
                {
                "name": "[parameters('workbookId')]",
                "type": "microsoft.insights/workbooks",
                "location": "[resourceGroup().location]",
                "apiVersion": "2022-04-01",
                "dependsOn": [],
                "kind": "shared",
                "properties": {
                    "displayName": "[parameters('workbookDisplayName')]",
                    "serializedData": "{\"version\":\"Notebook/1.0\",\"items\":[{\"type\":9,\"content\":{\"version\":\"KqlParameterItem/1.0\",\"crossComponentResources\":[\"{Workspaces}\"],\"parameters\":[{\"id\":\"877f0fb1-2f99-4a3a-ab11-604c7148909d\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Subscription\",\"type\":6,\"isRequired\":true,\"multiSelect\":true,\"quote\":\"'\",\"delimiter\":\",\",\"typeSettings\":{\"additionalResourceOptions\":[\"value::all\"],\"includeAll\":false},\"timeContext\":{\"durationMs\":86400000},\"defaultValue\":\"value::all\"},{\"id\":\"314f33c9-077e-4645-a1a0-737c6dfe2979\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Workspaces\",\"type\":5,\"isRequired\":true,\"multiSelect\":true,\"quote\":\"'\",\"delimiter\":\",\",\"query\":\"where type =~ 'microsoft.operationalinsights/workspaces'\\r\\n| summarize by id, name\",\"crossComponentResources\":[\"value::all\"],\"typeSettings\":{\"additionalResourceOptions\":[\"value::all\"],\"showDefault\":false},\"timeContext\":{\"durationMs\":86400000},\"defaultValue\":\"value::all\",\"queryType\":1,\"resourceType\":\"microsoft.resourcegraph/resources\"},{\"id\":\"fb6f6ff3-b8ab-4d13-bb00-a7f1248c8a34\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Period\",\"type\":4,\"isRequired\":true,\"typeSettings\":{\"selectableValues\":[{\"durationMs\":86400000},{\"durationMs\":172800000},{\"durationMs\":259200000},{\"durationMs\":604800000},{\"durationMs\":1209600000},{\"durationMs\":2419200000},{\"durationMs\":2592000000},{\"durationMs\":5184000000},{\"durationMs\":7776000000}]},\"value\":{\"durationMs\":2592000000}},{\"id\":\"1565d087-bf78-449c-9a0d-60b64efdc77a\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Domain\",\"type\":2,\"isRequired\":true,\"query\":\"Event\\r\\n| where EventLog == \\\"ObservabilityWithPowerShell\\\" and EventID == 10\\r\\n| project TimeGenerated, Computer, EventLevelName, EventID, RenderedDescription\\r\\n| extend detail=todynamic(RenderedDescription)\\r\\n| where isnotnull(detail.DNSRoot)\\r\\n| summarize by tostring(detail.DNSRoot)\",\"crossComponentResources\":[\"{Workspaces}\"],\"typeSettings\":{\"additionalResourceOptions\":[\"value::1\"],\"showDefault\":false},\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"Period\",\"defaultValue\":\"value::1\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\"}],\"style\":\"pills\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\"},\"name\":\"parameters - 0\"},{\"type\":11,\"content\":{\"version\":\"LinkItem/1.0\",\"style\":\"tabs\",\"links\":[{\"id\":\"030321d5-c4f1-4217-a483-9e0457a3ba63\",\"cellValue\":\"tab\",\"linkTarget\":\"parameter\",\"linkLabel\":\"Store & Index Object Information\",\"subTarget\":\"store\",\"preText\":\"\",\"style\":\"link\"},{\"id\":\"1ca0d63d-934d-4a1e-99ef-4d57b9b45669\",\"cellValue\":\"tab\",\"linkTarget\":\"parameter\",\"linkLabel\":\"Domain Name System & Service Lookup\",\"subTarget\":\"service\",\"style\":\"link\"},{\"id\":\"8a9b80b1-a4fd-4818-b10c-978194c2e3a4\",\"cellValue\":\"tab\",\"linkTarget\":\"parameter\",\"linkLabel\":\"Central Authentication & Authorization\\t\",\"subTarget\":\"auth\",\"style\":\"link\"},{\"id\":\"967e700e-76f1-40a3-bc16-911010e2a6bf\",\"cellValue\":\"tab\",\"linkTarget\":\"parameter\",\"linkLabel\":\"User & Computer Configuration\",\"subTarget\":\"conf\",\"style\":\"link\"}]},\"name\":\"links - 4\"},{\"type\":12,\"content\":{\"version\":\"NotebookGroup/1.0\",\"groupType\":\"editable\",\"items\":[{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"Event\\r\\n| where EventLog == \\\"ObservabilityWithPowerShell\\\" and EventID == 100\\r\\n| top 1 by TimeGenerated\\r\\n| extend detail=todynamic(RenderedDescription)\\r\\n| mvexpand detail\\r\\n| where detail.$d == '{Domain}'\\r\\n| extend backupDate=unixtime_seconds_todatetime(tolong(replace(@\\\"\\\\D\\\", \\\"\\\", tostring(detail.LastOriginatingChangeTime)))/1000)\\r\\n| top 1 by backupDate asc\\r\\n| extend days=datetime_diff('day',now(),backupDate)\\r\\n| extend title='Days since last backup'\",\"size\":4,\"timeContextFromParameter\":\"Period\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"crossComponentResources\":[\"{Workspaces}\"],\"visualization\":\"tiles\",\"tileSettings\":{\"titleContent\":{\"columnMatch\":\"title\",\"formatter\":1},\"leftContent\":{\"columnMatch\":\"days\",\"formatter\":12,\"formatOptions\":{\"max\":3,\"palette\":\"greenRed\"}},\"secondaryContent\":{\"columnMatch\":\"backupDate\",\"formatter\":6,\"dateFormat\":{\"formatName\":\"shortDatePattern\"}},\"showBorder\":false,\"size\":\"auto\"}},\"customWidth\":\"25\",\"name\":\"repadminshowbackup.txt.01\"},{\"type\":1,\"content\":{\"json\":\"### repadminshowbackup.txt.01\\r\\n\\r\\n**Description:** The number of days since the last domain backup.\\r\\n\\r\\n**Governance:** Domain backup *must* occur once every 3 days.\\r\\n\\r\\n**Technical:** Configure backups at least 1 time per day.\"},\"customWidth\":\"75\",\"name\":\"text - 1\"}]},\"conditionalVisibility\":{\"parameterName\":\"tab\",\"comparison\":\"isEqualTo\",\"value\":\"store\"},\"name\":\"store\"},{\"type\":12,\"content\":{\"version\":\"NotebookGroup/1.0\",\"groupType\":\"editable\",\"items\":[{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"Event\\r\\n| where EventLog == \\\"ObservabilityWithPowerShell\\\" and EventID == 200\\r\\n| top 1 by TimeGenerated\\r\\n| project TimeGenerated, Computer, EventLevelName, EventID, RenderedDescription\\r\\n| extend detail=todynamic(RenderedDescription)\\r\\n| where detail.$d == '{Domain}'\\r\\n| extend pwdLastSet=unixtime_seconds_todatetime(tolong(replace(@\\\"\\\\D\\\", \\\"\\\", tostring(detail.pwdLastSet.value)))/1000)\\r\\n| extend days=datetime_diff('day',now(),pwdLastSet)\\r\\n| extend title='Days since last password change'\",\"size\":4,\"timeContextFromParameter\":\"Period\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"crossComponentResources\":[\"{Workspaces}\"],\"visualization\":\"tiles\",\"tileSettings\":{\"titleContent\":{\"columnMatch\":\"title\",\"formatter\":1},\"leftContent\":{\"columnMatch\":\"days\",\"formatter\":12,\"formatOptions\":{\"max\":365,\"palette\":\"greenRed\"}},\"secondaryContent\":{\"columnMatch\":\"pwdLastSet\",\"formatter\":6,\"dateFormat\":{\"formatName\":\"shortDatePattern\"}},\"showBorder\":false,\"size\":\"auto\"}},\"customWidth\":\"25\",\"name\":\"get-adkrbtgt.json.01\"},{\"type\":1,\"content\":{\"json\":\"### get-adkrbtgt.json.01\\r\\n\\r\\n**Description:** The number of days since the last password change for the KRBTGT user.\\r\\n\\r\\n**Governance:** Secret material *must* be rotated once per year.\\r\\n\\r\\n**Technical:** Configure scheduled task to rotate user password once per quarter.\"},\"customWidth\":\"75\",\"name\":\"text - 8\"}]},\"conditionalVisibility\":{\"parameterName\":\"tab\",\"comparison\":\"isEqualTo\",\"value\":\"service\"},\"name\":\"service\"},{\"type\":12,\"content\":{\"version\":\"NotebookGroup/1.0\",\"groupType\":\"editable\",\"items\":[{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"Event\\r\\n| where EventLog == \\\"ObservabilityWithPowerShell\\\" and EventID == 300\\r\\n| top 1 by TimeGenerated\\r\\n| project TimeGenerated, Computer, EventLevelName, EventID, RenderedDescription\\r\\n| extend detail=todynamic(RenderedDescription)\\r\\n| mv-expand detail\\r\\n| where detail.$d == '{Domain}' and detail.objectClass == \\\"certificationAuthority\\\"\\r\\n| extend detail.cn, notAfter=unixtime_seconds_todatetime(tolong(replace(@\\\"\\\\D\\\", \\\"\\\", tostring(detail.NotAfter)))/1000)\\r\\n| extend days=(datetime_diff('day',now(),notAfter)*-1)\\r\\n| extend title=\\\"Days until expiration\\\"\",\"size\":4,\"timeContextFromParameter\":\"Period\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"crossComponentResources\":[\"{Workspaces}\"],\"visualization\":\"tiles\",\"tileSettings\":{\"titleContent\":{\"columnMatch\":\"title\",\"formatter\":1},\"leftContent\":{\"columnMatch\":\"days\",\"formatter\":12,\"formatOptions\":{\"max\":30,\"palette\":\"redGreen\"}},\"secondaryContent\":{\"columnMatch\":\"detail_cn\"},\"showBorder\":false,\"size\":\"auto\"}},\"customWidth\":\"25\",\"name\":\"get-adconfiguration.json.16\"},{\"type\":1,\"content\":{\"json\":\"### get-adconfiguration.json.16\\r\\n\\r\\n**Description:** The number of days until expiration of a certificate in the Enterprise RootCA Container.\\r\\n\\r\\n**Governance:** Static secret material *must* have a validity of greater than 30 days.\\r\\n\\r\\n**Technical:** Configure scheduled task to update certificates within 90 days of expiration.\"},\"customWidth\":\"75\",\"name\":\"text - 1\"}]},\"conditionalVisibility\":{\"parameterName\":\"tab\",\"comparison\":\"isEqualTo\",\"value\":\"auth\"},\"name\":\"auth\"},{\"type\":12,\"content\":{\"version\":\"NotebookGroup/1.0\",\"groupType\":\"editable\",\"items\":[{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"Event\\r\\n| where EventLog == \\\"ObservabilityWithPowerShell\\\" and EventID == 400\\r\\n| top 1 by TimeGenerated\\r\\n| project TimeGenerated, Computer, EventLevelName, EventID, RenderedDescription\\r\\n| extend detail=todynamic(RenderedDescription)\\r\\n| mv-expand detail\\r\\n| where detail.DomainName == '{Domain}' and detail.GpoStatus == 0\\r\\n| extend modifed=unixtime_seconds_todatetime(tolong(replace(@\\\"\\\\D\\\", \\\"\\\", tostring(detail.ModificationTime)))/1000)\\r\\n| extend days=datetime_diff('day',now(),modifed)\\r\\n| extend detail.DisplayName, detail.Owner\\r\\n| where days >= 3\\r\\n| summarize count(detail) by tostring(detail_Owner)\\r\\n| extend title=\\\"Number of stale & disabled policies\\\"\",\"size\":4,\"timeContextFromParameter\":\"Period\",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"crossComponentResources\":[\"{Workspaces}\"],\"visualization\":\"tiles\",\"tileSettings\":{\"titleContent\":{\"columnMatch\":\"title\",\"formatter\":1},\"leftContent\":{\"columnMatch\":\"count_detail\",\"formatter\":12,\"formatOptions\":{\"max\":0,\"palette\":\"greenRed\"}},\"secondaryContent\":{\"columnMatch\":\"detail_Owner\"},\"showBorder\":false,\"size\":\"auto\"}},\"customWidth\":\"25\",\"name\":\"get-gpo.json.01\"},{\"type\":1,\"content\":{\"json\":\"### get-gpo.json.01\\r\\n\\r\\n**Description:** The number of Group Policy Objects by Owner that are disabled without modification in the past 3 days.\\r\\n\\r\\n**Governance:** Disabled resources *must* be deleted within 3 days if unused.\\r\\n\\r\\n**Technical:** Configure scheduled task to delete objects.\"},\"customWidth\":\"75\",\"name\":\"text - 1\"}]},\"conditionalVisibility\":{\"parameterName\":\"tab\",\"comparison\":\"isEqualTo\",\"value\":\"conf\"},\"name\":\"conf\"}],\"isLocked\":false,\"fallbackResourceIds\":[\"azure monitor\"]}",
                    "version": "1.0",
                    "sourceId": "[parameters('workbookSourceId')]",
                    "category": "[parameters('workbookType')]"
                }
                }
            ],
            "outputs": {
                "workbookId": {
                "type": "string",
                "value": "[resourceId( 'microsoft.insights/workbooks', parameters('workbookId'))]"
                }
            },
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
            }
            #>
        }
        catch {
            throw $_
        }
    }
}