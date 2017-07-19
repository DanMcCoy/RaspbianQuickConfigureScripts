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

Write-Output ""

# Update and upgrade
if ($(YesNoPrompt "Update package list?" 1) -eq $TRUE)
{
    Write-Output "Updating package list, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo apt-get update"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}

Write-Output ""

if ($(YesNoPrompt "Upgrade installed packages?" 1) -eq $TRUE)
{
    Write output "Upgrading installed packages, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo apt-get dist-upgrade" > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}

Write-Output ""

# Install Screen
if ($(YesNoPrompt "Install Screen?" 1) -eq $TRUE)
{
    Write-Output "Installing Screen, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install screen"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
}

Write-Output ""

# Install Midnight Commander
if ($(YesNoPrompt "Install Midnight Commander?" 1) -eq $TRUE)
{
    Write-Output "Installing Midnight Commander, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mc"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
}

Write-Output ""

# Install ntfs-3g
if ($(YesNoPrompt "Install ntfs-3g?" 1) -eq $TRUE)
{
    Write-Output "Installing ntfs-3g, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install ntfs-3g"  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
}

Write-Output ""

# Mount NAS drive
. "$($thisDir)\Network\MountNas.ps1"

Write-Output ""

# Install MariaDB
. "$($thisDir)\MariaDB\MariaDB.ps1"

Write-Output ""

# Install MySql
. "$($thisDir)\MySql\MySql.ps1"

Write-Output ""

if ($(YesNoPrompt "Upgrade installed packages (again)?" 1) -eq $TRUE)
{
    Write output "Upgrading installed packages, please wait..."
    ./plink.exe -ssh $ipAddress -l $login -pw $password "sudo apt-get dist-upgrade" > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}

Write-Output ""



cd $thisDir

