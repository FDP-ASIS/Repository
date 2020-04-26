# Url file to download
$url = "https://download-cf.jetbrains.com/python/pycharm-community-2020.1.exe"

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Create a new folder name for exe data destination
$folder_data_name = [string]$file_name.TrimEnd(".exe")

# Uninstall destination
$uninstall_directory="$Env:Programfiles\$folder_data_name\bin\uninstall.exe"
Write-Output $uninstall_directory

Start-Process -Wait -FilePath $uninstall_directory -Argument "/S" -PassThru

# File on desktop
$shortcut_dest_location = "C:\Users\$env:UserName\Desktop\pycharm-community.lnk"

Remove-Item $shortcut_dest_location

Write-Output "Done removing"