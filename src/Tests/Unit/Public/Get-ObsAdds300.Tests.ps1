#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'ObservabilityWithPowerShell'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'ObservabilityWithPowerShell' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Get-ObsAdds300 Public Function Tests' -Tag Unit {
        Context "When obtaining Root CA Objects" {
            BeforeAll {
                function Get-ADForest {
                    return [PSCustomObject]@{ Domains = @("domain1", "domain2") }
                }
        
                function Get-ADRootDSE {
                    param($Server)
                    if ($Server -eq "domain1") {
                        return [PSCustomObject]@{ defaultNamingContext = "DC=domain1,DC=com" }
                    }
                    elseif ($Server -eq "domain2") {
                        return [PSCustomObject]@{ defaultNamingContext = "DC=domain2,DC=com" }
                    }
                }
        
                function Get-ADObject {
                    param($SearchBase, $Server)
                    if ($SearchBase -eq "CN=Certification Authorities,CN=Public Key Services,CN=Services,CN=Configuration,DC=domain1,DC=com" -and $Server -eq "domain1") {
                        return @(
                            [PSCustomObject]@{ caCertificate = [System.Text.Encoding]::UTF8.GetBytes("CertificateData1"); CN = "CA1"; ObjectClass = "certificationAuthority"; Created = (Get-Date); Modified = (Get-Date) },
                            [PSCustomObject]@{ caCertificate = [System.Text.Encoding]::UTF8.GetBytes("CertificateData2"); CN = "CA2"; ObjectClass = "certificationAuthority"; Created = (Get-Date); Modified = (Get-Date) }
                        )
                    }
                    elseif ($SearchBase -eq "CN=Certification Authorities,CN=Public Key Services,CN=Services,CN=Configuration,DC=domain2,DC=com" -and $Server -eq "domain2") {
                        return @(
                            [PSCustomObject]@{ caCertificate = [System.Text.Encoding]::UTF8.GetBytes("CertificateData3"); CN = "CA3"; ObjectClass = "certificationAuthority"; Created = (Get-Date); Modified = (Get-Date) }
                        )
                    }
                }
        
                Mock New-Object {}
            }
        
            It "Should obtain Root CA Objects for each domain" {
                { Get-ObsAdds300 } | Should -Not -Throw
                Assert-VerifiableMock
            }
        }
    }
} #inModule