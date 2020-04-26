# JDK version name
$JDK_FULL_VER="8u151-b12"

Write-Output "Installing..."

# Url file to download
$url = "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=230542_2f38c3b165be4555a1fa6e98c45e0808"

$exe_dest = [Environment]::GetEnvironmentVariable("ProgramFiles")+"\$JDK_FULL_VER-x64.exe"
$client = new-object System.Net.WebClient
$cookie = "oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
$client.downloadFile($url, $exe_dest)

# Create a new folder name for exe data destination
$folder_data_name = [Environment]::GetEnvironmentVariable("ProgramFiles")+"\Java\jre "+$JDK_FULL_VER
$config_file= $PSScriptRoot+"silent_jdk.config"

# Install the programm
Start-Process -Wait -FilePath $exe_dest -Argument INSTALLCFG=$config_file -PassThru

# Remove exe file
Remove-Item $exe_dest

Write-Output "Your folder directory located: $folder_data_name"

Write-Output 'Setting up Path variables.'
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $folder_data_name, "Machine")
[System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";"+$folder_data_name+"\bin", "Machine")
Write-Output "Done"