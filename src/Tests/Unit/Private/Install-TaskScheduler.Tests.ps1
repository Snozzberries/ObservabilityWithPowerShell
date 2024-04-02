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
    Describe 'Install-TaskScheduler Private Function Tests' -Tag Unit {
        <#Context "When installing a new Task Scheduler folder" {
            AfterAll {
                #Remove-EventLog $logName
                $f=$taskScheduler.GetFolder("\$folderName")
                $f.DeleteFolder($null,$null)
            }

            It "Should create a new folder if it does not exist" {
                $folderName = "TestFolder"

                { Install-TaskScheduler -FolderName $folderName } | Should -Throw -ExceptionType ([FileNotFoundException])

                $taskScheduler = New-Object -ComObject Schedule.Service
                $taskScheduler.Connect()

                $folder = $taskScheduler.GetFolder("\$folderName")
                $folder.Name | Should -Be $folderName
            }

            It "Should not throw an error if the folder already exists" {
                $folderName = "TestFolder"

                { Install-TaskScheduler -FolderName $folderName } | Should -Not -Throw
            }
        }

        Context "When encountering errors" {
            It "Should throw an error if there is an unexpected issue connecting to Task Scheduler" {
                Mock New-Object { throw "Error connecting to Task Scheduler" }

                { Install-TaskScheduler -FolderName "TestFolder" } | Should -Throw "Error connecting to Task Scheduler"
            }

            It "Should throw an error if the folder creation fails" {
                $folderName = "TestFolder"

                Mock Schedule.Service {
                    $mockObject = @{
                        Connect = { }
                        GetFolder = { throw [System.IO.FileNotFoundException] }
                        CreateFolder = { throw "Error creating folder" }
                    }
                    $mockObject.PSObject.PSTypeNames.Insert(0, 'Schedule.Service')
                    $mockObject
                }

                { Install-TaskScheduler -FolderName $folderName } | Should -Throw "Error creating folder"
            }
        }#>
    } #describe_Install-TaskScheduler
} #inModule