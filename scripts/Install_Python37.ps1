# Url file to download
$url = "https://www.python.org/ftp/python/3.7.7/python-3.7.7-embed-amd64.zip"

Write-Output "Installing..."

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder on computer
$dest_folder = [Environment]::GetEnvironmentVariable("ProgramFiles")

# Get cuurent time and date
$start_time = Get-Date

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
Expand-Archive -LiteralPath $source_zip_location -DestinationPath "$dest_folder\$folder_data_name\"
Write-Output "Finished extracting"

# Remove zip file
Remove-Item $source_zip_location

Write-Output "Your folder directory located: $dest_folder\$folder_data_name"

Write-Output 'Setting up Path variables.'
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";"+"$dest_folder\$folder_data_name\", "Machine")
Write-Output "Done"