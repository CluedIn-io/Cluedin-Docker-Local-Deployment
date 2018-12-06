$scriptsPath = Join-Path -Path $PSScriptRoot -ChildPath .. | Join-Path -ChildPath scripts
. (Join-Path -Path $scriptsPath -ChildPath hosts-helpers.ps1)

Describe "Host-Helpers" {
    Context "Adding hosts" {

        $testPath = "TestDrive:\hosts"
        Set-Content $testPath -value "127.0.0.1 localhost"
		
        It "adds a valid IP" {
            Add-HostFileContent -IPAddress "192.168.0.1" -hostname "foobar" -file $testPath            
            $testPath | Should -FileContentMatch "^\s*192\.168\.0\.1\s+foobar\b"  
        }
        It "does not adds a host more than once" {
            Add-HostFileContent -IPAddress "192.168.0.1" -hostname "localhost" -file $testPath
            $testPath | Should -Not -FileContentMatch "^\s*192\.168\.0\.1\s+localhost\b"  
        }
        @("265.777.7.7","foo","192.168.256.0","192.168.0.") | ForEach-Object {
            It "throws error with invalid IP $_" {
                {Add-HostFileContent -IPAddress $_ -hostname "foobar" -file $testPath} |
                Should  -Throw
            }
        }
    }

    Context "Removing hosts" {

        $testPath = "TestDrive:\hosts"              
		
        It "removes a valid IP" {
            Set-Content $testPath -value "192.168.0.1 foobar" -Encoding ASCII
            Remove-HostFileContent -IPAddress "192.168.0.1" -file $testPath
            gc $testPath | Write-Host            
            $testPath | Should -not -FileContentMatch "^\s*192\.168\.0\.1"  
        }
        
        It "keeps other entries" {
            Set-Content $testPath -value "127.0.0.1 localhost" -Encoding ASCII
            Remove-HostFileContent -IPAddress "192.168.0.1" -file $testPath                        
            $testPath | Should -FileContentMatch "^\s*127\.0\.0\.1\s+localhost\b"  
        }
        
        @("#192.168.0.1 foobar", "   # 192.168.0.1 foobar", "#   192.168.0.1 foobar") | ForEach-Object {
            It "does not remove commented entry '$_'" {
                Set-Content $testPath -value "$_" -Encoding ASCII
                Add-HostFileContent -IPAddress "192.168.0.1" -hostname "localhost" -file $testPath
                $testPath | Should -FileContentMatch "^\s*\#\s*192\.168\.0\.1"  
            }
        }

        It "leaves file untouched if it is locked by another process" {
            # need to use a real file, as the TestPath can't remain locked
            $testPath = [System.IO.Path]::GetTempFileName()            
            Set-Content $testPath -value "192.168.0.1 foobar" -Encoding ASCII                        
            $fileOpenHandle = [io.file]::OpenWrite($testPath)
            {Remove-HostFileContent -IPAddress "192.168.0.1" -file $testPath} |
                 Should -Throw
            $fileOpenHandle.Close();
            $testPath | Should -FileContentMatch "^\s*192\.168\.0\.1"                      
            Remove-Item $testPath -Force
        }

        @("265.777.7.7","foo","192.168.256.0","192.168.0.") | ForEach-Object {
            It "throws error with invalid IP $_" {
                {Remove-HostFileContent -IPAddress $_ -file $testPath} |
                Should  -Throw
            }
        }
    }
}