Clear-Host
Write-Output "---Raspbian Quick Config Script---"
Write-Output "----------------------------------"
Write-Output ""

#variables
$thisDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ipAddress = ""
$login = ""
$password = ""

$ipAddress = Read-Host -Prompt "IP address"
$Login = Read-Host -Prompt "Login"

$response = Read-host "Password" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

# Change the password
. "$($thisDir)\ChangePassword\ChangePassword.ps1"


