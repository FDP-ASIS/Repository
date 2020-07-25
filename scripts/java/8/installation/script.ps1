$Install ={
    function run{
        param (
            [string] $exe_dest,
            [string] $config_file,
            [string] $location_config,
            [string] $folder_data_name
        )

        Write-Output 'Installing JDK, please wait...'

        if (Test-Path $exe_dest) {
            Remove-Item $exe_dest
        }

        if (Test-Path $config_file) {
            Remove-Item $config_file
        }

        # download config file from repository
        $config_url='https://raw.githubusercontent.com/FDP-ASIS/Repository/master/scripts/java/8/installation/silent_jdk.config'

        # Start downloading
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $config_url -Destination $location_config

        # Url exe file to download
        $url = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=230542_2f38c3b165be4555a1fa6e98c45e0808'

        # Download exe file
        $client = new-object System.Net.WebClient
        # Accept oracle cookies
        $cookie = 'oraclelicense=accept-securebackup-cookie'
        $client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
        $client.downloadFile($url, $exe_dest)

        if (Test-Path $folder_data_name) {
            Remove-Item $folder_data_name -Force -Recurse
        }
    }
}

$Path_Var ={
    function run {
        param (
            [string] $exe_dest,
            [string] $folder_data_name,
            [string] $config_file
        )

        if (Test-Path $exe_dest) {
            # Remove exe file
            Remove-Item $exe_dest
            Remove-Item $config_file
        }

        Write-Output 'Your folder directory located:' $folder_data_name

        # Setting path variables on computer
        Write-Output 'Setting up Path variables'
        [System.Environment]::SetEnvironmentVariable('JAVA_HOME', $folder_data_name, 'Machine')
        [System.Environment]::SetEnvironmentVariable('PATH',$Env:Path + ';' +$folder_data_name+'\bin', 'Machine')

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
$location_config= [Environment]::GetEnvironmentVariable('ProgramFiles')
$config_file = $location_config +'\silent_jdk.config'

try {
    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command & {$Install run '$exe_dest' '$config_file' '$location_config' '$folder_data_name'}"
    Start-Process -Wait -FilePath $exe_dest -Argument INSTALLCFG=`"$config_file`" -PassThru
    Start-Process -Wait powershell -Verb runAs -PassThru -ArgumentList "-NoExit -NoProfile -ExecutionPolicy Bypass -Command & {$Path_Var run '$exe_dest' '$folder_data_name' '$config_file'}"
} catch [exception]{
    Write-Output '$_.Exception is' $_.Exception
}