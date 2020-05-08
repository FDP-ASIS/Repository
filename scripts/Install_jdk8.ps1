$Install ={
    function run
    {
        param ($exe_dest)
        Write-Output 'Installing...'

        # Url exe file to download
        $url = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=230542_2f38c3b165be4555a1fa6e98c45e0808'

        # Download exe file
        $client = new-object System.Net.WebClient
        # Accept oracle cookies
        $cookie = 'oraclelicense=accept-securebackup-cookie'
        $client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
        $client.downloadFile($url, $exe_dest)
    }
}

$Install2 ={
    function run
    {
        param ($folder_data_name)

        # JDK version name
        $JDK_FULL_VER = '8u151-b12'

        # Download exe file
        $exe_dest = [Environment]::GetEnvironmentVariable('ProgramFiles') + '\'+$JDK_FULL_VER+'-x64.exe'

        # Remove exe file
        Remove-Item $exe_dest

        Write-Output 'Your folder directory located:' $folder_data_name

        # Setting path variables on computer
        Write-Output 'Setting up Path variables'
        [System.Environment]::SetEnvironmentVariable('JAVA_HOME', '$folder_data_name', 'Machine')
        [System.Environment]::SetEnvironmentVariable('PATH',$Env:Path + ';' +'$folder_data_name'+'\bin', 'Machine')

        Write-Output 'Done installing jdk on your computer'
    }
}

# JDK version name
$JDK_FULL_VER = '8u151-b12'

# Download exe file
$exe_dest = [Environment]::GetEnvironmentVariable('ProgramFiles') + '\'+$JDK_FULL_VER+'-x64.exe'

# Create a new folder name for exe data destination
$folder_data_name = [Environment]::GetEnvironmentVariable('ProgramFiles') + '\Java\jre ' + $JDK_FULL_VER

# Config file for install
$location_config= $PSScriptRoot
$config_file = $location_config + '\silent_jdk.config'


$startProc = Start-Process powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Install run('$exe_dest')}"
$startProc.WaitForExit()
Start-Process -Wait -FilePath $exe_dest -Argument INSTALLCFG=$config_file -PassThru
$startProc3=Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Install2 run('$folder_data_name')}"
$startProc3.WaitForExit()