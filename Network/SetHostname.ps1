
if ($(YesNoPrompt "Set the host name?" 1) -eq $TRUE)
{
    $hostname = Read-host "Hostname"
    Write-Output ""

    #make copies of the files
    Copy-Item "$thisDir\Network\hosts.txt" "$thisDir\Network\hosts"
    Copy-Item "$thisDir\Network\hostname.txt" "$thisDir\Network\hostname"

    #set the variables in the processed hosts file
    (Get-Content "$thisDir\Network\hosts").replace('127.0.1.1	[[hostname]]', "127.0.1.1	$hostname") | Set-Content "$thisDir\Network\hosts"

    #set the variables in the processed hostname file
    (Get-Content "$thisDir\Network\hostname").replace('[[hostname]]', "$hostname") | Set-Content "$thisDir\Network\hostname"

    #copy the files over to the target machine
    Write-Output "Copying new hosts file to $($ipAddress):/home/$login"
    ./pscp -pw $password $thisDir\Network\hosts $login@$($ipAddress):/home/pi
    Write-Output ""

    Write-Output "Copying new hostname file to $($ipAddress):/home/$login"
    ./pscp -pw $password $thisDir\Network\hostname $login@$($ipAddress):/home/pi
    Write-Output ""


    #move them to the correct places
    $moveCmd = "sudo mv -f -v /home/$login/hosts /etc/hosts"
    ./plink.exe -ssh $ipAddress -l $login -pw $password $moveCmd  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""

    $moveCmd = "sudo mv -f -v /home/$login/hostname /etc/hostname"
    ./plink.exe -ssh $ipAddress -l $login -pw $password $moveCmd  > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"
    Write-Output ""

}