#32-bit as x86
#64-bit as x64

$win_bit= (Get-WmiObject Win32_OperatingSystem).OSArchitecture
if ($win_bit -eq "64-bit"){
	Write-Output "64-bit"
}else{
	Write-Output "32-bit"
}
