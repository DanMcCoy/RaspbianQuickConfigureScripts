
if ($(YesNoPrompt "Set a static IP address?" 1) -eq $TRUE)
{
    $address = Read-host "Address"
    $gateway = Read-host "Gateway"
    $network = Read-host "Network address ""family"" (e.g. 192.168.1.0)"
    $broadcast = Read-host "Broadcast (e.g. 192.168.1.255)"
    Write-Output ""

    
    if ($(YesNoPrompt "Modify the interfaces file?" 1) -eq $TRUE)
    {
        #make a copy of the file
        Copy-Item "$thisDir\Network\interfaces.txt" "$thisDir\Network\interfaces"

        #set the variables in the processed interfaces file
        (Get-Content "$thisDir\Network\interfaces").replace('address [[address]]', "address $address") | Set-Content "$thisDir\Network\interfaces"
        (Get-Content "$thisDir\Network\interfaces").replace('gateway [[gateway]]', "gateway $gateway") | Set-Content "$thisDir\Network\interfaces"
        (Get-Content "$thisDir\Network\interfaces").replace('network [[network]]', "network $network") | Set-Content "$thisDir\Network\interfaces"
        (Get-Content "$thisDir\Network\interfaces").replace('broadcast [[broadcast]]', "broadcast $broadcast") | Set-Content "$thisDir\Network\interfaces"

        #copy the interfaces file over to the target machine
        Write-Output "Copying new interfaces file to $($ipAddress):/home/$login"
        ./pscp -pw $password $thisDir\Network\interfaces $login@$($ipAddress):/home/pi
        Write-Output ""

        #move it to the correct place
        $moveCmd = "sudo mv -f -v /home/$login/interfaces /etc/network/interfaces"
        ./plink.exe -ssh $ipAddress -l $login -pw $password $moveCmd  > "$thisDir\output.txt"

        Get-Content "$thisDir\output.txt"
        
    }

    Write-Output ""

    if ($(YesNoPrompt "Modify the dhcpcd.conf file?" 1) -eq $TRUE)
    {
        #make a copy of the file
        Copy-Item "$thisDir\Network\dhcpcd.txt" "$thisDir\Network\dhcpcd.conf"

        #set the variables in the processed dhcpcd.conf file
        (Get-Content "$thisDir\Network\dhcpcd.conf").replace('static ip_address=[[address]]/24', "static ip_address=$address/24") | Set-Content "$thisDir\Network\dhcpcd.conf"
        (Get-Content "$thisDir\Network\dhcpcd.conf").replace('static routers=[[gateway]]', "static routers=$gateway") | Set-Content "$thisDir\Network\dhcpcd.conf"
        (Get-Content "$thisDir\Network\dhcpcd.conf").replace('static domain_name_servers=[[gateway]]', "static domain_name_servers=$gateway") | Set-Content "$thisDir\Network\dhcpcd.conf"
        Write-Output ""

        #copy the dhcpcd.conf file over to the target machine
        Write-Output "Copying new dhcpcd.conf file to $($ipAddress):/home/$login"
        ./pscp -pw $password $thisDir\Network\dhcpcd.conf $login@$($ipAddress):/home/pi
        Write-Output ""

        #move it to the correct place
        $moveCmd = "sudo mv -f -v /home/$login/dhcpcd.conf /etc/dhcpcd.conf"
        ./plink.exe -ssh $ipAddress -l $login -pw $password $moveCmd  > "$thisDir\output.txt"
            
        Get-Content "$thisDir\output.txt"
        
    }
    Write-Output ""

    Write-Output "Note: After a network reset/reboot, check the IP address with 'ip addr' and/or 'ifconfig'"
    Write-Output ""

}