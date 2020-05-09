$Uninstall = {
    function run
    {
        # Url zip file to download
        $url = 'https://www.python.org/ftp/python/3.7.7/python-3.7.7-embed-amd64.zip'

        Write-Output 'Uninstalling...'

        # Get name of the file
        $file_name = [System.IO.Path]::GetFileName($url)

        # Destination folder on computer
        $dest_folder = [Environment]::GetEnvironmentVariable('ProgramFiles')

        # Folder to uninstall
        $folder_data_name = [string]$file_name.TrimEnd('.zip')
        Remove-Item $dest_folder'\'$folder_data_name -Force -Recurse

        # Remove Path Environment
        # Get PATH
        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')

        # Remove unwanted elements
        $path = ($path.Split(';') | Where-Object {
            $_ -ne $dest_folder + "\" + $folder_data_name + "\"
        }) -join ';'
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')

        Write-Output 'Done removing python from your computer'
    }
}

Start-Process powershell -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Uninstall run}"