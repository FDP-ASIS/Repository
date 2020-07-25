$Install ={
    function run {
        param (
            [string] $url,
            [string] $prog_files_dest,
            [string] $source_exe_location,
            [string] $config_file,
            [string] $location_config,
            [string] $dest_directory
        )

        Write-Output 'Installing Pycharm, please wait...'

        if (Test-Path $source_exe_location) {
            Remove-Item $source_exe_location
        }

        if (Test-Path $config_file) {
            Remove-Item $config_file
        }

        # download config file from repository
        $config_url='https://raw.githubusercontent.com/FDP-ASIS/Repository/master/scripts/pycharm/2020.1/installation/silent_pycharm.config'

        # Start downloading
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $config_url -Destination $location_config

        # Start downloading
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $prog_files_dest

        if (Test-Path $dest_directory) {
            Remove-Item $dest_directory -Force -Recurse
        }
    }
}

$Install2 ={
    function run{
        Write-Output 'The installation is on background, please wait a few minutes until you will get a new powershell window and a finish message...'
    }
}

$Shortcut ={
    function run {
        param (
            [string] $source_exe_location,
            [string] $dest_directory,
            [string] $config_file
        )

        Write-Output 'Finished installing'

        # Shortcut icon source and location
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\pycharm-community.lnk'
        if (Test-Path $shortcut_dest_location) {
            Remove-Item $shortcut_dest_location
        }

        $source_icon_location = $dest_directory + '\bin\pycharm64.exe'

        # Create shortcut on desktop
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($shortcut_dest_location)
        $Shortcut.TargetPath = $source_icon_location
        $Shortcut.Save()

        if (Test-Path $source_exe_location) {
            # Remove exe file from computer
            Remove-Item $source_exe_location
            Remove-Item $config_file
        }

        Write-Output 'Your folder directory located:'$dest_directory
        Write-Output 'Done installing pycharm on your computer and create shortcut on desktop'
    }
}

try {
    # Url exe file to download
    $url = 'https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe'

    # Get name of the file
    $file_name = [System.IO.Path]::GetFileName($url)

    # Destination folder on computer
    $prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles');

    # Source of exe file location
    $source_exe_location= $prog_files_dest+ '\' + $file_name

    # Config file for install
    $location_config= [Environment]::GetEnvironmentVariable('ProgramFiles')
    $config_file = $location_config +'\silent_pycharm.config'

    # Create a new folder name for exe data destination
    $folder_data_name = [string]$file_name.TrimEnd('.exe')

    # Installation destination
    $dest_directory = $prog_files_dest+'\'+$folder_data_name

    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Install run '$url' '$prog_files_dest' '$source_exe_location' '$config_file' '$location_config' '$dest_directory'}"
    Start-Process powershell -Verb runAs -PassThru -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Install2 run}"
    Start-Process -Wait -FilePath $source_exe_location -Argument "/S /CONFIG=$config_file /D=$dest_directory" -PassThru
    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass -Command & {$Shortcut run '$source_exe_location' '$dest_directory' '$config_file'}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}