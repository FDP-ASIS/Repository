$Install ={
    function run
    {
        param ($dest_folder_exe)

        # Url exe file to download
        $url = 'https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe'

        Write-Output 'Installing...'

        # Start downloading
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $url -Destination $dest_folder_exe
    }
}

$Install2 ={
    function run
    {
        param ($dest_directory)

        Write-Output 'Finished installing'

        # Shortcut icon source and location
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\pycharm-community.lnk'
        $source_icon_location = $dest_directory + '\bin\pycharm64.exe'

        # Create shortcut on desktop
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($shortcut_dest_location)
        $Shortcut.TargetPath = $source_icon_location
        $Shortcut.Save()

        # Url exe file to download
        $url = 'https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe'

        # Get name of the file
        $file_name = [System.IO.Path]::GetFileName($url)

        # Source of exe file location
        $source_exe_location= $Env:Programfiles + '\' + $file_name

        # Remove exe file from computer
        Remove-Item $source_exe_location

        Write-Output 'Your folder directory located:'$dest_directory
        Write-Output 'Done installing pycharm on your computer and create shortcut on desktop'
    }
}

# Url exe file to download
$url = 'https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe'

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder on computer
$dest_folder_exe = [Environment]::GetEnvironmentVariable('ProgramFiles');

# Source of exe file location
$source_exe_location= $Env:Programfiles + '\' + $file_name

# Create a new folder name for exe data destination
$folder_data_name = [string]$file_name.TrimEnd('.exe')

# Installation destination
$dest_directory = $Env:Programfiles+'\'+$folder_data_name

# Config file for install
$location_config= $PSScriptRoot
$config_file = $location_config +'\silent_pycharm.config'

$startProc = Start-Process powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Install run('$dest_folder_exe')}"
$startProc.WaitForExit()
Start-Process -Wait -FilePath $source_exe_location -Argument "/S /CONFIG=$config_file /D=$dest_directory"
$startProc3=Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass -Command & {$Install2 run('$dest_directory')}"
$startProc3.WaitForExit()