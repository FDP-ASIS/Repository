# Url file to download
$url = "http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-win32-x86_64.zip"

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder on computer
$dest_folder = [Environment]::GetEnvironmentVariable("ProgramFiles")

# New folder name for zip data destination
$folder_data_name = [string]$file_name.TrimEnd(".zip")

# File on desktop
$shortcut_dest_location = "C:\Users\$env:UserName\Desktop\eclipse.lnk"

Remove-Item $shortcut_dest_location
Remove-Item $dest_folder\$folder_data_name -Recurse

Write-Output "Done removing"