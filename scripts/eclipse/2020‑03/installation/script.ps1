$Install = {
    function run {
        param (
            [string] $url,
            [string] $prog_files_dest,
            [string] $source_zip_location,
            [string] $data_folder,
            [string] $shortcut_dest_location
        )

        Write-Output 'Installing Eclipse, please wait...'

        # Start downloading
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $prog_files_dest
        # Write output in 2 different lines
        Write-Output 'Finished downloading zip file' 'Now it will extract the zip file'

        # Extract zip archive
        Expand-Archive -LiteralPath $source_zip_location -DestinationPath $data_folder'\'
        Write-Output 'Finished extracting'

        $shortcut_source_location = $data_folder+'\eclipse\eclipse.exe'

        # Create shortcut on desktop
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($shortcut_dest_location)
        $Shortcut.TargetPath = $shortcut_source_location
        $Shortcut.Save()

        if (Test-Path $source_zip_location) {
            # Remove zip file from computer
            Remove-Item $source_zip_location
        }

        Write-Output 'Your folder directory located:'$data_folder
        Write-Output 'Done installing eclipse on your computer and create shortcut on desktop'
    }
}

try {
    # Url zip file to download
    $url = 'http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-win32-x86_64.zip'
    # Destination folder to save zip file on computer
    $prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles')
    # Get the name of the file
    $file_name = [System.IO.Path]::GetFileName($url)
    # Source of zip file location
    $source_zip_location = $prog_files_dest+'\'+$file_name

    # Check if zip file already exists
    if (Test-Path $source_zip_location) {
        Remove-Item $source_zip_location
    }

    # Create a new folder name for zip data destination
    $folder_name_without_zip = [string]$file_name.TrimEnd('.zip')
    $data_folder= $prog_files_dest+'\'+ $folder_name_without_zip

    if (Test-Path $data_folder) {
        Remove-Item $data_folder -Force -Recurse
    }

    # Shortcut icon source and location
    $DesktopPath = [Environment]::GetFolderPath('Desktop')
    $shortcut_dest_location = $DesktopPath + '\eclipse.lnk'

    if (Test-Path $shortcut_dest_location) {
        Remove-Item $shortcut_dest_location
    }

    Start-Process powershell -Wait -Verb runAs -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Install run '$url' '$prog_files_dest' '$source_zip_location' '$data_folder' '$shortcut_dest_location'}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}