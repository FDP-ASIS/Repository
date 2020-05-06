﻿# Url zip file to download
$url = "http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-win32-x86_64.zip"

Write-Output "Installing..."

# Get the name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder to save file on computer
$dest_folder = [Environment]::GetEnvironmentVariable("ProgramFiles")

# Start downloading
Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $dest_folder

Write-Output "Finished downloading"
Write-Output "Now it will extract the zip file"

# Create a new folder name for zip data destination
$folder_data_name = [string]$file_name.TrimEnd(".zip")

# Source of zip file location
$source_zip_location = "$Env:Programfiles\$file_name"

# Extract zip archive
Expand-Archive -LiteralPath $source_zip_location -DestinationPath "$dest_folder\$folder_data_name"
Write-Output "Finished extracting"

# Shortcut icon source and location
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$shortcut_dest_location = $DesktopPath+"\eclipse.lnk"
$source_icon_location = "$dest_folder\$folder_data_name\eclipse\eclipse.exe"

# Create shortcut on desktop
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($shortcut_dest_location)
$Shortcut.TargetPath = $source_icon_location
$Shortcut.Save()

# Remove zip file from computer
Remove-Item $source_zip_location

Write-Output "Your folder directory located: $dest_folder\$folder_data_name"
Write-Output "Done installing eclipse on your computer and create shortcut on desktop"