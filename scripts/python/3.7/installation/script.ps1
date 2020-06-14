$Install ={
    function run {
        Write-Output 'Installing...'
        # Url zip file to download
        $url = 'https://www.python.org/ftp/python/3.7.7/python-3.7.7-embed-amd64.zip'
        # Destination folder on computer
        $prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles')
        # Get name of the file
        $file_name = [System.IO.Path]::GetFileName($url)
        # Source of zip file location
        $source_zip_location = $prog_files_dest+'\'+$file_name

        # Check if zip file already exists
        if (!(Test-Path $source_zip_location)) {
            # Start downloading
            Import-Module BitsTransfer
            Start-BitsTransfer -Source $url -Destination $prog_files_dest
            # Write output in 2 different lines
            Write-Output 'Finished downloading zip file' 'Now it will extract the zip file'
        }
        else {
            Write-Output 'File already exists on your computer'
        }

        # Create a new folder name for zip data destination
        $folder_name_without_zip = [string]$file_name.TrimEnd('.zip')
        $data_folder= $prog_files_dest+'\'+ $folder_name_without_zip

        # Check if extract data folder already exists
        if (!(Test-Path $data_folder)) {
            # Extract zip archive
            Expand-Archive -LiteralPath $source_zip_location -DestinationPath $data_folder'\'
            Write-Output 'Finished extracting'
        }
        else {
            Write-Output 'Folder python data already exists on your computer'
        }

        if (Test-Path $source_zip_location) {
            # Remove zip file from computer
            Remove-Item $source_zip_location
        }

        Write-Output 'Your folder directory located:'$data_folder

        # Setting path variables on computer
        Write-Output 'Setting up Path variables.'
        [System.Environment]::SetEnvironmentVariable('PATH', $Env:Path + ';' + $data_folder+'\', 'Machine')

        Write-Output 'Done installing python on your computer'
    }
}

try {
    Start-Process powershell -Wait -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Install run}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}