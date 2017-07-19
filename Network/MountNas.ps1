$mntNetworkPath = $null
$mntMountPath = $null
$mntUserName = $null
$mntPassword = $null

Write-Output ""
Write-Output "Mounting a network drive:"
Write-Output "Only run this section once. Running multiple times will continue to append to the fstab file!"


if ($(YesNoPrompt "Mount network drive?" 1) -eq $TRUE)
{
    Write-Output ""
    Write-Output "Please enter the network path e.g. //192.168.0.2/Seagate3TB-A"
    $mntNetworkPath = Read-host "Network path"

    Write-Output ""
    Write-Output "Please enter the mount path e.g. /home/nas"
    $mntMountPath = Read-host "Mount path"

    Write-Output ""
    $mntUserName = Read-host "User name"
    $mntPasswordSecure = Read-host "Password" -AsSecureString
    $mntPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($mntPasswordSecure))

    if ($mntNetworkPath -And $mntMountPath -And $mntUserName -And $mntPassword)
    {

        $mountNasScript = "MountNas"

        #make a copy of the file
        Copy-Item "$thisDir\Network\$mountNasScript.txt" "$thisDir\Network\$mountNasScript.bash"

        #set the variables in the processed bash script
        (Get-Content "$thisDir\Network\$mountNasScript.bash").replace('[[network_path]]', "$mntNetworkPath") | Set-Content "$thisDir\Network\$mountNasScript.bash"
        (Get-Content "$thisDir\Network\$mountNasScript.bash").replace('[[mount_path]]', "$mntMountPath") | Set-Content "$thisDir\Network\$mountNasScript.bash"
        (Get-Content "$thisDir\Network\$mountNasScript.bash").replace('[[user_name]]', "$mntUserName") | Set-Content "$thisDir\Network\$mountNasScript.bash"
        (Get-Content "$thisDir\Network\$mountNasScript.bash").replace('[[password]]', "$mntPassword") | Set-Content "$thisDir\Network\$mountNasScript.bash"

        #Run the bash script on the linux box
        cd "C:\Program Files (x86)\PuTTY"
        ./plink.exe -ssh $ipAddress -l $login -pw $password -m "$thisDir\Network\$mountNasScript.bash" > "$thisDir\output.txt"
        Get-Content "$thisDir\output.txt"

    }
    Else
    {
        Write-Output "Not all variables entered. Skipping this section."    
    }
}