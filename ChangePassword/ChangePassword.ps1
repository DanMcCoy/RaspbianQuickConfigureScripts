function PromptForChangePassword($userName)
{
    
    [bool]$returnValue = $TRUE
    $YesChoice = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes";
    $NoChoice = new-Object System.Management.Automation.Host.ChoiceDescription "&No","No";
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($YesChoice,$NoChoice);

    $answer = $host.ui.PromptForChoice(
        "",
        "Change the password for $($userName)?",
        $choices,
        0)

    if ($answer -eq 1){
        $returnValue = $FALSE;
    }
    return $returnValue
}

if ($(PromptForChangePassword($login)) -eq $TRUE)
{
    $response = Read-host "New password" -AsSecureString
    $NewPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

    $response = Read-host "Confirm new password" -AsSecureString
    $ConfirmedPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($response))

    if ($NewPassword -ne $ConfirmedPassword){
        Write-Output "Passwords do not match!"
        exit
    }
    Write-Output ""

    $changePasswordCommand = """echo -e $($password)\\n$($NewPassword)\\n$($ConfirmedPassword) | passwd"""

    try{        
        ./plink.exe -ssh "192.168.1.10" -l $login -pw $password $changePasswordCommand > "$thisDir\output.txt"
    }
    catch{
        Write-Output "AN EXCEPTION!!"
        Write-Output $_.Exception.Message
    }
    Write-Output ""
    Get-Content "$thisDir\output.txt"
    Write-Output ""
}

