$Uninstall = {
    function run
    {
        # Url zip file to download
        $url = 'http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-win32-x86_64.zip'

        Write-Output 'Uninstalling...'

        # Get the name of the file
        $file_name = [System.IO.Path]::GetFileName($url)

        # Destination folder to remove file from the computer
        $prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles')

        # New folder name for zip data destination
        $folder_data_name = [string]$file_name.TrimEnd('.zip')

        # Location shortcut file on desktop
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\eclipse.lnk'

        if (Test-Path $shortcut_dest_location)
        {
            # Remove shortuct
            Remove-Item $shortcut_dest_location
        }
        else
        {
            Write-Output 'No shortcut exists already on the dektop'
        }

        $dir_to_remove= $prog_files_dest+'\'+$folder_data_name
        if (Test-Path $dir_to_remove)
        {
            # Uninstall software from the computer
            Remove-Item  -Recurse
        }
        else
        {
            Write-Output 'No eclipse directory exists already'
        }

        Write-Output 'Done removing eclipse from your computer'
    }
}

Start-Process powershell -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Uninstall run}"