# Url zip file to download
$url = "http://mirror.dkm.cz/eclipse/technology/epp/downloads/release/2020-03/R/eclipse-java-2020-03-R-win32-x86_64.zip"

Write-Output "Uninstalling..."

# Get the name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder to remove file from the computer
$dest_folder = [Environment]::GetEnvironmentVariable("ProgramFiles")

# New folder name for zip data destination
$folder_data_name = [string]$file_name.TrimEnd(".zip")

# Location shortcut file on desktop
$shortcut_dest_location = "C:\Users\$env:UserName\Desktop\eclipse.lnk"

# Remove shortuct
Remove-Item $shortcut_dest_location

# Uninstall software from the computer
Remove-Item $dest_folder\$folder_data_name -Recurse

Write-Output "Done removing eclipse from your computer"