
function YesNoPrompt([string] $questionText, [int] $defaultOption)
{
    [bool]$returnValue = $TRUE
    $YesChoice = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes";
    $NoChoice = new-Object System.Management.Automation.Host.ChoiceDescription "&No","No";
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($YesChoice,$NoChoice);

    $answer = $host.ui.PromptForChoice(
        "",
        $questionText,
        $choices,
        $defaultOption)

    if ($answer -eq 1){
        $returnValue = $FALSE;
    }
    return $returnValue
}