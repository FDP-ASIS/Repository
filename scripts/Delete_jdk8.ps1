﻿# JDK version name
$JDK_FULL_VER="8u151-b12"

Write-Output "Removing..."

# Folder to uninstall
$folder_data_name = [Environment]::GetEnvironmentVariable("ProgramFiles")+"\Java\jre "+$JDK_FULL_VER
Remove-Item $folder_data_name -Force -Recurse

# Remove Path Environment
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $null, "Machine")

# Get PATH
$path = [System.Environment]::GetEnvironmentVariable('PATH','Machine')

# Remove unwanted elements
$path = ($path.Split(';') | Where-Object { $_ -ne $folder_data_name+"\bin" }) -join ';'

# Set it
[System.Environment]::SetEnvironmentVariable('PATH',$path,'Machine')

Write-Output "Done removing"