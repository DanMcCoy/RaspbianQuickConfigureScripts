function PromptForSetStaticIP($userName)
{
    [bool]$returnValue = $TRUE
    $YesChoice = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes";
    $NoChoice = new-Object System.Management.Automation.Host.ChoiceDescription "&No","No";
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($YesChoice,$NoChoice);

    $answer = $host.ui.PromptForChoice(
        "",
        "Set a static IP address?",
        $choices,
        1)

    if ($answer -eq 1){
        $returnValue = $FALSE;
    }
    return $returnValue
}

if ($(PromptForSetStaticIP($login)) -eq $TRUE)
{
    $address = Read-host "Address"
    $gateway = Read-host "Gateway"
    $network = Read-host "Network address ""family"" (e.g. 192.168.1.0)"
    $broadcast = Read-host "Broadcast (e.g. 192.168.1.255)"

    #make a copy of the bash script
    Copy-Item "$thisDir\Network\interfaces.txt" "$thisDir\Network\interfaces"

    #set the variables in the processed interfaces file
    (Get-Content "$thisDir\Network\interfaces").replace('address [[address]]', "address $address") | Set-Content "$thisDir\Network\interfaces"
    (Get-Content "$thisDir\Network\interfaces").replace('gateway [[gateway]]', "gateway $gateway") | Set-Content "$thisDir\Network\interfaces"
    (Get-Content "$thisDir\Network\interfaces").replace('network [[network]]', "network $network") | Set-Content "$thisDir\Network\interfaces"
    (Get-Content "$thisDir\Network\interfaces").replace('broadcast [[broadcast]]', "broadcast $broadcast") | Set-Content "$thisDir\Network\interfaces"
    Write-Output ""

    #copy the file over to the target machine
    Write-Output "Copying new interfaces file to $($ipAddress):/home/$login"
    ./pscp -pw $password $thisDir\Network\interfaces $login@$($ipAddress):/home/pi
    Write-Output ""

    #move it to the correct place
    $moveCmd = "sudo mv -f -v /home/$login/interfaces /etc/network/interfaces"
    ./plink.exe -ssh $ipAddress -l $login -pw $password $moveCmd  > "$thisDir\output.txt"

    
    Get-Content "$thisDir\output.txt"
    Write-Output ""

}