# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs
{
    param
    (
        [Parameter(Mandatory=$True)]
        [String]$RegistrationUrl,

        [Parameter(Mandatory=$True)]
        [String]$RegistrationKey,

        [String[]]$ComputerName = "localhost",
        [Int]$RefreshFrequencyMins = 30,
        [Int]$ConfigurationModeFrequencyMins = 15,
        [String]$ConfigurationMode = "ApplyAndMonitor",
        [String]$NodeConfigurationName,
        [Boolean]$RebootNodeIfNeeded= $False,
        [String]$ActionAfterReboot = "ContinueConfiguration",
        [Boolean]$AllowModuleOverwrite = $False,
        [Boolean]$ReportOnly
    )

    if(!$NodeConfigurationName -or $NodeConfigurationName -eq "")
    {
        $ConfigurationNames = $null
    }
    else
    {
        $ConfigurationNames = @($NodeConfigurationName)
    }

    if($ReportOnly)
    {
    $RefreshMode = "PUSH"
    }
    else
    {
    $RefreshMode = "PULL"
    }

    Node $ComputerName
    {

        Settings
        {
            RefreshFrequencyMins = $RefreshFrequencyMins
            RefreshMode = $RefreshMode
            ConfigurationMode = $ConfigurationMode
            AllowModuleOverwrite = $AllowModuleOverwrite
            RebootNodeIfNeeded = $RebootNodeIfNeeded
            ActionAfterReboot = $ActionAfterReboot
            ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
        }

        if(!$ReportOnly)
        {
        ConfigurationRepositoryWeb AzureAutomationDSC
            {
                ServerUrl = $RegistrationUrl
                RegistrationKey = $RegistrationKey
                ConfigurationNames = $ConfigurationNames
            }

            ResourceRepositoryWeb AzureAutomationDSC
            {
            ServerUrl = $RegistrationUrl
            RegistrationKey = $RegistrationKey
            }
        }

        ReportServerWeb AzureAutomationDSC
        {
            ServerUrl = $RegistrationUrl
            RegistrationKey = $RegistrationKey
        }
    }
}

# Create the metaconfigurations
# TODO: edit the below as needed for your use case
$Params = @{
    RegistrationUrl = $args[1] # 'https://eus2-agentservice-prod-1.azure-automation.net/accounts/b6be6e16-9d09-40ed-bba0-9c4d97485c7f';
    RegistrationKey = $args[0] # 'qKtl/Na0f0Q8BehWl7cv63Ev1uec1e5nWxxaz/6fIZizKWeDXDLMuTnCr2VnjJJXd3AiM/6ByiGPSkFa1/yEXw==';
    NodeConfigurationName = $args[2];
}
# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params