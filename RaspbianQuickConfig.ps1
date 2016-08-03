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
$password = ""

. "$($thisDir)\CommonFunctions.ps1"


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

# Set the hostname
. "$($thisDir)\Network\SetHostname.ps1"

Write-Output ""

# Set timezone to London
if ($(YesNoPrompt "Set time zone to London?" 1) -eq $TRUE)
{
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo cp /usr/share/zoneinfo/Europe/London /etc/localtime --verbose"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}


# Update and upgrade
if ($(YesNoPrompt "Update package list?" 1) -eq $TRUE)
{
    Write output "Updating package list, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo apt-get update"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}

Write-Output ""

if ($(YesNoPrompt "Upgrade installed packages?" 1) -eq $TRUE)
{
    Write output "Upgrading installed packages, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo apt-get dist-upgrade"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}

Write-Output ""


