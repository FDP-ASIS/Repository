$Install ={
    function run {
        param (
            [string] $url,
            [string] $prog_files_dest,
            [string] $source_exe_location
        )

        Write-Output 'Installing...'

        if (!(Test-Path $source_exe_location)) {
            # Start downloading
            Import-Module BitsTransfer
            Start-BitsTransfer -Source $url -Destination $prog_files_dest
        }
        else
        {
            Write-Output 'Pycharm exe file already exists on your computer'
        }
    }
}

$Shortcut ={
    function run {
        param (
            [string] $source_exe_location,
            [string] $dest_directory
        )

        Write-Output 'Finished installing'

        # Shortcut icon source and location
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\pycharm-community.lnk'
        $source_icon_location = $dest_directory + '\bin\pycharm64.exe'

        if (!(Test-Path $shortcut_dest_location)) {
            # Create shortcut on desktop
            $WScriptShell = New-Object -ComObject WScript.Shell
            $Shortcut = $WScriptShell.CreateShortcut($shortcut_dest_location)
            $Shortcut.TargetPath = $source_icon_location
            $Shortcut.Save()
        }
        else {
            Write-Output 'Shortcut icon already exists on desktop'
        }

        if (Test-Path $source_exe_location) {
            # Remove exe file from computer
            Remove-Item $source_exe_location
        }

        Write-Output 'Your folder directory located:'$dest_directory
        Write-Output 'Done installing pycharm on your computer and create shortcut on desktop'
    }
}

# Url exe file to download
$url = 'https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe'

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder on computer
$prog_files_dest = [Environment]::GetEnvironmentVariable('ProgramFiles');

# Source of exe file location
$source_exe_location= $prog_files_dest+ '\' + $file_name

# Create a new folder name for exe data destination
$folder_data_name = [string]$file_name.TrimEnd('.exe')

# Installation destination
$dest_directory = $prog_files_dest+'\'+$folder_data_name

# Config file for install
$location_config= $PSScriptRoot
$config_file = $location_config +'\silent_pycharm.config'

try {
    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Install run '$url' '$prog_files_dest' '$source_exe_location'}"

    if (!(Test-Path $dest_directory)) {
        Start-Process -Wait -FilePath $source_exe_location -Argument "/S /CONFIG=$config_file /D=$dest_directory" -PassThru
    }
    else {
        Write-Output 'Pycharm directory already exists on your computer'
    }

    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass -Command & {$Shortcut run '$source_exe_location' '$dest_directory'}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}