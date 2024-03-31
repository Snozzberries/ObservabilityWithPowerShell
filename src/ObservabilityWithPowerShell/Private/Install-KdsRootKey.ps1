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
function Install-KdsRootKey {
    [CmdletBinding()]
    param (
    )
    begin {
        $prefixVerbose = "[Verbose][$($MyInvocation.MyCommand.Name)]"
        $prefixInfo = "[Info][$($MyInvocation.MyCommand.Name)]"
    }
    process {
        try {
            #Make sure AD WS is enabled and 9389 is allowed
            Write-Verbose "$prefixVerbose Requesting all KDS Root Keys"
            $keys = Get-KdsRootKey
            $validKey = $false
            foreach($key in $keys){
                $format = $key.IsFormatValid
                $valid = (Get-Date) -gt $key.EffectiveTime
                $test = (Test-KdsRootKey $key.KeyId)

                if(-not $format){
                    Write-Verbose "$prefixVerbose KDS Root Key is malformed $($key.KeyId)"
                }
                if(-not $valid){
                    Write-Verbose "$prefixVerbose KDS Root Key is not yet effective $($key.KeyId)"
                }
                if(-not $test){
                    Write-Verbose "$prefixVerbose KDS Root Key failed test $($key.KeyId)"
                }
                if($format -and $valid -and $test){
                    $validKey = $true
                    Write-Info "$prefixInfo KDS Root Key appears functional $($key.KeyId)"
                }
            }
            if(-not $validKey){
                Write-Info "$prefixInfo No valid KDS Root Key found, adding"
                Add-KdsRootKey -EffectiveImmediately
            }
        }
        catch {
            throw $_
        }
    }
}