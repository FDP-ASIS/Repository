$Install = {
    function run
    {
        Write-Output 'Installing...'
        # Url zip file to download
        $url = 'http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-win32-x86_64.zip'
        # Destination folder to save zip file on computer
        $prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles')
        # Get the name of the file
        $file_name = [System.IO.Path]::GetFileName($url)
        # Source of zip file location
        $source_zip_location = $prog__files_dest+'\'+$file_name

        # Check if zip file already exists
        if (!(Test-Path $source_zip_location))
        {
            # Start downloading
            Import-Module BitsTransfer
            Start-BitsTransfer -Source $url -Destination $prog_files_dest
            # Write output in 2 different lines
            Write-Output 'Finished downloading zip file' 'Now it will extract the zip file'
        }
        else
        {
            Write-Output 'File already exists on your computer'
        }

        # Create a new folder name for zip data destination
        $folder_name_without_zip = [string]$file_name.TrimEnd('.zip')
        $data_folder= $prog_files_dest+'\'+ $folder_name_without_zip

        # Check if extract data folder already exists
        if (!(Test-Path $data_folder))
        {
            # Extract zip archive
            Expand-Archive -LiteralPath $source_zip_location -DestinationPath $data_folder'\'
            Write-Output 'Finished extracting'
        }
        else
        {
            Write-Output 'Folder eclipse data already exists on your computer'
        }

        # Shortcut icon source and location
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\eclipse.lnk'
        $shortcut_source_location = $data_folder+'\eclipse\eclipse.exe'

        # Check if icon shortuct exists on desktop
        if (!(Test-Path $shortcut_dest_location))
        {
            # Create shortcut on desktop
            $WScriptShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WScriptShell.CreateShortcut($shortcut_dest_location)
            $Shortcut.TargetPath = $shortcut_source_location
            $Shortcut.Save()
        }
        else
        {
            Write-Output 'Shortcut icon already exists on desktop'
        }

        if (Test-Path $source_zip_location)
        {
            # Remove zip file from computer
            Remove-Item $source_zip_location
        }

        Write-Output 'Your folder directory located:'$data_folder
        Write-Output 'Done installing eclipse on your computer and create shortcut on desktop'
    }
}

Start-Process powershell -Wait -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Install run}"