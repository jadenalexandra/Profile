
#PREPPING ENVIRONMENT AND LOGGING INTO OFFICE 365 SERVICES
#FOR WINDOWS 10
#NO MFA
#ALWAYS RUN POWERSHELL AND POWERSHELL ISE AS AN ADMINISTRATOR
#https://docs.microsoft.com/en-us/office365/enterprise/powershell/connect-to-all-office-365-services-in-a-single-windows-powershell-window

<#ADVISORY
- Run Powershell as Administrator
- If Module's act up
     - Uninstall-Module "<Module Name>" -force
     - Get-Module "<Module Name or * for All>" -ListAvailable | Select-Object Name,Version | Sort-Object Version –Descending
     - Uninstall-Module "<Module Name>" -force
#CREATE SECURE LOGIN CREDENTIALS
#Setup-OneTime-PerComputerProfile-CanCreateMoreThanOneSecureLogin
$UserName = "someuser"
$ExposedPassword = "typepassword"
$SecurePassword = "$ExposedPassword" | ConvertTo-SecureString -AsPlainText -Force
$SecureCredentials = New-Object system.management.automation.pscredential -ArgumentList $UserName, $SecurePassword
#From-Then-On-Connect-Like-This
Connect-MsolService -Credential $SecureCredentials
Connect-SPOService -Credential $SecureCredentials -URL "https://theblueottergroup-admin.sharepoint.com"
Connect-PnpOnline "https://theblueottergroup.sharepoint.com/sites/siteone" -Credential $SecureCredentials
Connect-PnpOnline "https://theblueottergroup.sharepoint.com/sites/siteone" –UseWebLogin
#>



#CREATE SECURE CREDENTIONS FOR OTTER
$AdminUPNOtter = "jadenriley@theblueottergroup.com"
$InsecurePasswordOtter = (Read-Host "Password for $AdminUPNOtter")
$SecurePasswordOtter = $InsecurePasswordOtter | ConvertTo-SecureString -AsPlainText -Force
$SecureCredentialsOtter = New-Object system.management.automation.pscredential -ArgumentList $AdminUPNOtter, $SecureCredentialsOtter
#CREATE SECURE CREDENTIONS FOR PCGADMIN
$AdminUPNPCGADM = "jarileyadm@pcg.com"
$InsecurePasswordPCGADM = (Read-Host "Password for $AdminUPNPCGADM")
$SecurePasswordPCGADM = $InsecurePasswordPCGADM | ConvertTo-SecureString -AsPlainText -Force
$SecureCredentialsPCGADM = New-Object system.management.automation.pscredential -ArgumentList $AdminUPNPCGADM, $SecurePasswordPCGADM
#CREATE SECURE CREDENTIONS FOR PCG O365 ADMIN
$AdminUPNPCGO365ADM = "jariley365adm@publicconsultinggroup.onmicrosoft.com"
$InsecurePasswordPCGO365ADM = (Read-Host "Password for $AdminUPNPCGO365ADM")
$SecurePasswordPCGO365ADM = $InsecurePasswordPCGO365ADM | ConvertTo-SecureString -AsPlainText -Force
$SecureCredentialsPCGO365ADM = New-Object system.management.automation.pscredential -ArgumentList $AdminUPNPCGO365ADM, $SecureCredentialsPCGO365ADM

#VARIABLES OTTER
$AdminURLOtter = "https://theblueottergroup-admin.sharepoint.com"
$OneDriveURLOtter = "https://theblueottergroup-my.sharepoint.com/personal/"
#VARIABLES PCG ADM
$TenantPCGADM = "publicconsultinggroup"
$AdminURLPCGADM = "https://publicconsultinggroup-admin.sharepoint.com"
$OneDriveBasePCGADM = "https://publicconsultinggroup-my.sharepoint.com/personal/"
#VARIABLES PCG O365 ADM
$TenantPCGO365ADM = "publicconsultinggroup"
$AdminURLPCGO365ADM = "https://publicconsultinggroup-admin.sharepoint.com"
$OneDrivePCGO365ADM = "https://publicconsultinggroup-my.sharepoint.com/personal/"

#DOWNLOAD AND INSTALL ON PC, ONE-TIME PREP
#SharePoint Online Management Shell
#Skype for Business Online, Windows PowerShell Module
#Microsoft Online Services Sign-In Assistant for IT Professionals RTW, apart of Win10

#SET POWERSHELL TO RUN SCRIPTS #ONE-TIME PREP
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -force
Write-Host "Execution Policy set to Unrestricted"

#SET HOME DIRECTORY
Set-Location c:\github
#Set-Location c:\githubPCG
Write-Host "Home directory set to c:\github"
#Write-Host "Home directory set to c:\githubPCG"

<#
#MODULE INSTALLATION
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
Install-Module SharePointPnPPowerShellOnline -AllowClobber
Install-Module -Name CredentialManager
Install-Module -Name AzureAD
Install-Module -Name OneDrive
Nuget install Microsoft.SharePointOnline.CSOM -OutputDirectory <C:\PathWhereDownloadedNuGet\nuget.exe>\SPO_CSOM
#>


#CONNECT MSOL
Connect-MsolService -Credential $CredentialsOtter
#Connect-MsolService -Credential $CredentialsPCG
#Connect-MsolService -Credential $CredentialsPCGO365ADM
Write-Host "Connected to The Blue Otter Group's Microsoft Online service (MSOL)"
#Write-Host "Connected to PCG Microsoft Online Azure AD (AAD)"

#CONNECT AZURE AD
Connect-AzureAD -Credential $CredentialsOtter #When using the Azure Active Directory PowerShell for Graph
#Connect-AzureAD -Credential $CredentialsPCG #When using the Azure Active Directory PowerShell for Graph
#Connect-AzureAD -Credential $CredentialsPCGO365ADM #when using the Azure Active Directory PowerShell for Graph
Write-Host "Connected to The Blue Otter Group's Microsoft Online service (MSOL) and Azure AD (AAD)"
#Write-Host "Connected to PCG Microsoft Online service (MSOL) and Azure AD (AAD)"

#SHAREPOINT ONLINE
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://theblueottergroup-admin.sharepoint.com #-Credential $CredentialsOtter
#Connect-SPOService -Url https://publicconsultinggroup-admin.sharepoint.com #-Credential $CredentialsPCG
Write-Host "Connected to The Blue Otter Group's SharePoint Online (SPO)"
#Write-Host "Connected to PCG's SharePoint Online (SPO)"


#SKYPE FOR BUSINESSS ONLINE
Import-Module SkypeOnlineConnector -DisableNameChecking
$SkypeSession = New-CsOnlineSession #-Credential $CredentialsOtter
#$SkypeSessionPCG = New-CsOnlineSession #-Credential $CredentialsPCG
Import-PSSession $SkypeSession –AllowClobber
#Import-PSSession $SkypeSessionPCG –AllowClobber
Write-Host "Connected to The Blue Otter Group's (Skype)"
#Write-Host "Connected to PCG's Skype (Skype)"

#EXCHANGE ONLINE
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Authentication Basic -AllowRedirection #-Credential $CredentialsOtter
#$SessionPCG = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Authentication  Basic -AllowRedirection #-Credential $CredentialsPCG
#$SessionPCG-O365ADM = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Authentication  Basic -AllowRedirection #-Credential $CredentialsPCG
Import-PSSession $ExchangeSession –AllowClobber
Write-Host "Connected to The Blue Otter Group's Exchange Online (EXO)"
#Write-Host "Connected to PCG's Exchange Online (EXO)"

#SECURITY & COMPLIANCE CENTER
$SccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication "Basic" -AllowRedirection
#$SccSessionPCG = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Authentication  Basic -AllowRedirection #-Credential $CredentialsPCG
#$SccSessionPCG-O365ADM = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Authentication  Basic -AllowRedirection #-Credential $CredentialsPCG
Import-PSSession $SccSession -Prefix cc –AllowClobber
Write-Host "Connected to The Blue Otter Group's Security & Compliance Center"
#Write-Host "Connected to PCG's Security & Compliance Center"