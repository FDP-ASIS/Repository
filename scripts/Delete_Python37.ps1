# Url file to download
$url = "https://www.python.org/ftp/python/3.7.7/python-3.7.7-embed-amd64.zip"

Write-Output "Removing..."

# Get name of the file
$file_name = [System.IO.Path]::GetFileName($url)

# Destination folder on computer
$dest_folder = [Environment]::GetEnvironmentVariable("ProgramFiles")

# Create a new folder name for zip data destination
$folder_data_name = [string]$file_name.TrimEnd(".zip")

# Remove directory
Remove-Item "$dest_folder\$folder_data_name" -Force -Recurse

# Get PATH
$path = [System.Environment]::GetEnvironmentVariable('PATH','Machine')

# Remove unwanted elements
$path = ($path.Split(';') | Where-Object { $_ -ne $dest_folder+"\"+$folder_data_name+"\" }) -join ';'

# Set it
[System.Environment]::SetEnvironmentVariable('PATH',$path,'Machine')

Write-Output "Done removing"