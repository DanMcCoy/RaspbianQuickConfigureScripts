$dbRootPassword = $null
$dbRootPasswordConfirm = $null

if ($(YesNoPrompt "Install MariaDB?" 1) -eq $TRUE)
{
    $response = Read-host "Root user password" -AsSecureString
    $dbRootPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

    $response = Read-host "Confirm root user password" -AsSecureString
    $dbRootPasswordConfirm = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

    if ($dbRootPassword -ne $dbRootPasswordConfirm){
        Write-Output "Passwords do not match!"
        exit
    }

    $installFileName = "InstallMariaDB"

    #make a copy of the file
    Copy-Item "$thisDir\MariaDB\$installFileName.txt" "$thisDir\MariaDB\$installFileName.bash"

    #set the variables in the processed bash script
    (Get-Content "$thisDir\MariaDB\$installFileName.bash").replace('[[root_password]]', "$dbRootPassword") | Set-Content "$thisDir\MariaDB\$installFileName.bash"
    (Get-Content "$thisDir\MariaDB\$installFileName.bash").replace('[[root_password_confirm]]', "$dbRootPasswordConfirm") | Set-Content "$thisDir\MariaDB\$installFileName.bash"

    #Run the bash script on the linux box
    cd "C:\Program Files (x86)\PuTTY"
    ./plink.exe -ssh $ipAddress -l $login -pw $password -m "$thisDir\MariaDB\$installFileName.bash" > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"

    
}
Write-Output ""

if ($(YesNoPrompt "Add a new admin user?" 1) -eq $TRUE)
{
    if ($dbRootPassword -eq $null)
    {
        $response = Read-host "Root user password" -AsSecureString
        $dbRootPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))
    }

    $newUserName = Read-host "New user name"
    $newUserIP = Read-host "New user's IP/hostname"
        
    $response = Read-host "New user password" -AsSecureString
    $newUserPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

    $response = Read-host "Confirm new user password" -AsSecureString
    $newUserPasswordConfirm = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

    if ($newUserPassword -ne $newUserPasswordConfirm){
        Write-Output "Passwords do not match!"
        exit
    }

    $addUserFileName = "AddNewAdminUser"

    #make a copy of the file
    Copy-Item "$thisDir\MariaDB\$addUserFileName.txt" "$thisDir\MariaDB\$addUserFileName.bash"

    #set the variables in the processed bash script
    (Get-Content "$thisDir\MariaDB\$addUserFileName.bash").replace('[[root_password]]', "$dbRootPassword") | Set-Content "$thisDir\MariaDB\$addUserFileName.bash"
    (Get-Content "$thisDir\MariaDB\$addUserFileName.bash").replace('[[root_password_confirm]]', "$dbRootPasswordConfirm") | Set-Content "$thisDir\MariaDB\$addUserFileName.bash"
    (Get-Content "$thisDir\MariaDB\$addUserFileName.bash").replace('[[new_user_name]]', "$newUserName") | Set-Content "$thisDir\MariaDB\$addUserFileName.bash"
    (Get-Content "$thisDir\MariaDB\$addUserFileName.bash").replace('[[new_user_ip]]', "$newUserIP") | Set-Content "$thisDir\MariaDB\$addUserFileName.bash"
    (Get-Content "$thisDir\MariaDB\$addUserFileName.bash").replace('[[new_user_password]]', "$newUserPassword") | Set-Content "$thisDir\MariaDB\$addUserFileName.bash"

    #Run the bash script on the linux box
    cd "C:\Program Files (x86)\PuTTY"
    ./plink.exe -ssh $ipAddress -l $login -pw $password -m "$thisDir\MariaDB\$addUserFileName.bash" > "$thisDir\output.txt"
    Get-Content "$thisDir\output.txt"

    Write-Output ""
}

