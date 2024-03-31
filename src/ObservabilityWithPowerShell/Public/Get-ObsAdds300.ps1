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
function Get-ObsAdds300 {
    [CmdletBinding()]
    param (
        [string[]]$Domains = (Get-ADForest).Domains
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $logId = 300
    }
    process {
        try {
            $objs = @()
            foreach($domain in $domains){
                Write-Verbose "$prefixVerbose Obstaining default naming context in $domain"
                $defaultNc = (Get-ADRootDSE -Server $domain).defaultNamingContext
                $certContainer = "CN=Certification Authorities,CN=Public Key Services,CN=Services,CN=Configuration"
                $objSplat = @{
                    SearchBase = "$certContainer,$defaultNc"
                    LDAPFilter = "(objectClass=certificationAuthority)"
                    Properties = "*"
                    Server = $domain
                }
                Write-Verbose "$prefixVerbose Obtaining Root CA Objects in $domain"
                $cas = Get-ADObject @objSplat

                foreach($ca in $cas){
                    Write-Verbose "$prefixVerbose Converting certificate $($ca.CN)"
                    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $ca.caCertificate
                    
                    $obj = [PSCustomObject]@{
                        LogId = $logId
                        Domain = $domain
                        Subject = $cert.Subject
                        Issuer = $cert.Issuer
                        Thumbprint = $cert.Thumbprint
                        NotBefore = $cert.NotBefore
                        NotAfter = $cert.NotAfter
                        cn = $ca.CN
                        ObjectClass = $ca.ObjectClass
                        Created = $ca.Created
                        Modified = $ca.Modified
                    }

                    Write-Verbose "$prefixVerbose Appending object $($obj|ConvertTo-Json -Compress)"
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