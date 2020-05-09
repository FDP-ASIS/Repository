$Uninstall = {
    function run
    {
        Write-Output 'Uninstalling...'
    }
}

$Uninstall2 = {
    function run
    {
        # Remove shortcut from desktop
        $DesktopPath = [Environment]::GetFolderPath('Desktop')
        $shortcut_dest_location = $DesktopPath + '\pycharm-community.lnk'
        Remove-Item $shortcut_dest_location
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
$dir_program= [Environment]::GetEnvironmentVariable('ProgramFiles')
$uninstall_directory = $dir_program+'\'+$folder_data_name+'\bin\uninstall.exe'

$startProc = Start-Process powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Uninstall run}"
$startProc.WaitForExit()

Start-Process -Wait -FilePath $uninstall_directory -Argument "/S" -PassThru

Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -NoExit -ExecutionPolicy Bypass -Command & {$Uninstall2 run}"