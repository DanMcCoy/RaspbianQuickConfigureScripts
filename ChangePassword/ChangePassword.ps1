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
    Write-Output "Ok, changing...."
}

