$Uninstall = {
    function run {
        Write-Output 'Uninstalling Pycharm, please wait...'
    }
}

$Uninstall2 = {
    function run {
        # Remove shortcut from desktop
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\pycharm-community.lnk'

        if (Test-Path $shortcut_dest_location) {
            Remove-Item $shortcut_dest_location
        }
        else {
            Write-Output 'No shortcut exists already on the dektop'
        }

        Write-Output 'Done removing pycharm from your computer'
    }
}

# Url exe file to download
$url = 'https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe'

Write-Output 'Uninstalling...'

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Create a new folder name for exe data destination
$folder_data_name = [string]$file_name.TrimEnd('.exe')

# Uninstall software
$prog_files_dest= [Environment]::GetEnvironmentVariable('ProgramFiles')
$uninstall_directory = $prog_files_dest+'\'+$folder_data_name+'\bin\uninstall.exe'

try {
    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Uninstall run}"

    if (Test-Path $uninstall_directory) {
        Start-Process -Wait -FilePath $uninstall_directory -Argument "/S" -PassThru
    }
    else {
        Write-Output 'Pycharm directory already does not exists on your computer'
    }

    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass -Command & {$Uninstall2 run}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}