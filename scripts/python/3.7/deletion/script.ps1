$Uninstall = {
    function run {
        Write-Host 'Uninstalling Python, please wait...' -ForegroundColor Green

        # Url zip file to download
        $url = 'https://www.python.org/ftp/python/3.7.7/python-3.7.7-embed-amd64.zip'

        # Get name of the file
        $file_name = [System.IO.Path]::GetFileName($url)

        # Destination folder on computer
        $prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles')

        # Folder to uninstall
        $folder_data_name = [string]$file_name.TrimEnd('.zip')
        $dir_to_remove= $prog_files_dest+'\'+$folder_data_name
        if (Test-Path $dir_to_remove) {
            # Uninstall directory from the computer
            Remove-Item $dir_to_remove -Force -Recurse
        }
        else {
            Write-Output 'No python directory exists already'
        }

        # Remove Path Environment
        # Get PATH
        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
        # Remove unwanted elements
        $path = ($path.Split(';') | Where-Object {
            $_ -ne $prog_files_dest + "\" + $folder_data_name + "\"
        }) -join ';'

        if (Test-Path $path) {
            [System.Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')
        }
        else {
            Write-Output 'Environment variable already does not exists'
        }

        Write-Host 'Done removing python from your computer' -ForegroundColor Green
    }
}

try {
    Start-Process powershell -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Uninstall run}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}