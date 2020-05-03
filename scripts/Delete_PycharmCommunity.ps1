# Url exe file to download
$url = "https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe"

Write-Output "Uninstalling..."

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Create a new folder name for exe data destination
$folder_data_name = [string]$file_name.TrimEnd(".exe")

# Uninstall software
$uninstall_directory="$Env:Programfiles\$folder_data_name\bin\uninstall.exe"
Start-Process -Wait -FilePath $uninstall_directory -Argument "/S" -PassThru

# Remove shortcut from desktop
$shortcut_dest_location = "C:\Users\$env:UserName\Desktop\pycharm-community.lnk"
Remove-Item $shortcut_dest_location

Write-Output "Done removing pycharm from your computer"