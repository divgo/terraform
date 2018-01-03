# scripts

The Scripts in this folder should go in a Blob Storage Account which you have credentials for. I put them in a Container called scripts. 

These scripts will be downloaded in a CustomScriptExtension task via their URI's and are responsible for performing the actual onboarding to Azure Automation DSC.  
`        "fileUris": [
          "https://[storage_account_name].blob.core.windows.net/scripts/DscMetaConfigs.ps1",
          "https://[storage_account_name].blob.core.windows.net/scripts/Execute_DscScripts.ps1"
        ]
`


# main.tf
Terraform config which;
1. creates a VM in Azure
2. installs the DSCExtension
3. upgrades the VM to WMF 5.1 via the DSCExtension ( "WmfVersion": "latest" )
4. downloads files from the scripts directory in a Storage Account
5. executes the powershell scripts downloaded from the Storage Account

# vars.tf
Terraform Variables file
