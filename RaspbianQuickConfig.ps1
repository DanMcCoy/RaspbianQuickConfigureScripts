Param(
    [string]$ipAddress = $null,
    [string]$login = $null
)

Clear-Host
Write-Output "---Raspbian Quick Config Script---"
Write-Output "----------------------------------"
Write-Output ""




#variables
$thisDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
#$ipAddress = ""
#$login = ""
$password = ""

if ($ipAddress -eq $null -Or $ipAddress -eq ""){
    $ipAddress = Read-Host -Prompt "IP address"
}
if ($login -eq $null -Or $login -eq ""){
    $login = Read-Host -Prompt "Login"
}

$response = Read-host "Password" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

cd "C:\Program Files (x86)\PuTTY"

Write-Output ""

# Change the password
. "$($thisDir)\ChangePassword\ChangePassword.ps1"

Write-Output ""

# Set a static IP
. "$($thisDir)\Network\SetStaticIP.ps1"

Write-Output ""


