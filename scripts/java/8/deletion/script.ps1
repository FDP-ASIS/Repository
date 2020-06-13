$Uninstall = {
    function run {
        # JDK version name
        $JDK_FULL_VER = '8u151-b12'

        Write-Output 'Uninstalling...'

        # Folder to uninstall
        $folder_data_name = [Environment]::GetEnvironmentVariable('ProgramFiles') + '\Java\jre ' + $JDK_FULL_VER

        if (Test-Path $folder_data_name) {
            Remove-Item $folder_data_name -Force -Recurse
        }
        else {
            Write-Output 'No jdk directory exists already'
        }

        # Remove Path Environment
        [System.Environment]::SetEnvironmentVariable('JAVA_HOME', $null, 'Machine')
        # Get PATH
        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')

        # Remove unwanted elements
        $path = ($path.Split(';') | Where-Object {
                $_ -ne $folder_data_name + '\bin'
        }) -join ';'
        if (Test-Path $path) {
            [System.Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')
        }
        else {
            Write-Output 'Environment variable already does not exists'
        }

        Write-Output 'Done removing jdk from your computer'
    }
}

try {
    Start-Process powershell -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Uninstall run}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}