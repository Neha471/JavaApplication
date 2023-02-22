###########################################################################################################################
# Requirements: 
#  - The 'Blackbaud.Adfs.Client.dll', built for your supported .NET, must be located next to this script and both unblocked.
#  - The 'AWSPowerShell' Module must be installed for legacy environments (Windows, PowerShell <3.0 and .NET Framework <4.7.2),
#    the 'AWSPowerShell.NetCore' Module must be installed for all other environments (Windows/Linux/OSX, PowerShell 3.0+ and
#    .NET Framework 4.7.2+/.NET Core 2.1+).  See AWS documentation for more details:
#    https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up.html
#  - "Dot-Source" load (. .\AdfsClient_Aws.ps1) this script so the AWS session persists outside this script to your shell.
###########################################################################################################################

# Import supporting AWS PowerShell module, with legacy fall-back if needed
$awsCoreModule = Get-Module -Name 'AWSPowerShell.NetCore' -ListAvailable
$awsModule = Get-Module -Name 'AWSPowerShell' -ListAvailable
if($awsCoreModule) {
	Import-Module -Name 'AWSPowerShell.NetCore'
} elseif($awsModule) {
	Import-Module -Name 'AWSPowerShell'
} else {
	Write-Error -Message "Supporting AWS module NOT found. Please run 'Install-Module -Name AWSPowerShell.NetCore', or for legacy 'Install-Module -Name AWSPowerShell'."
}

# Settings
[System.Uri] $AdfsEndpoint = "https://adfs2.blackbaud.me/adfs/ls/idpinitiatedsignon.aspx?logintorp=urn:amazon:webservices"
[String] $AwsRegion = "us-east-1"
$awsAccountDetailHashTable = @{
	"386094957990" = "blackbaud-lnxt-dev";
	"314499813463" = "blackbaud-analytics";
	"917427895354" = "SdoDev";
	"912338845631" = "bb-lonxt-auth";
	"286594936754" = "LcrmProd";
	"698457673795" = "LcrmDev";
	"356762763485" = "blackbaud-billing";
	"539259299037" = "blackbaud-build";
	"489415500963" = "blackbaud-pivotal";
	"554125655091" = "blackbaud-hub";
	"519810912671" = "bb-lonxt-shared";
	"825311438146" = "attentively";
	"155442479946" = "blackbaud-tools";
	"787496137169" = "bb-lonxt-sandbox";
	"380180396507" = "blackbaud-luminate-dev";
	"502262732285" = "blackbaud-lnxt-prod1"
	}

# Prompt for credentials
[PSCredential] $Credential = Get-Credential -Message "Enter your Blackbaud credentials: "
[String] $Username = $Credential.UserName
[SecureString] $Password = $Credential.Password
[String] $MfaToken = Read-Host "Enter your MFA Token (or press enter & respond to mobile notification)"

# Load Blackbaud.Adfs.Client library
[IO.Directory]::SetCurrentDirectory($PSScriptRoot)
Add-Type -Path (Join-Path -Path $PSScriptRoot -ChildPath "Blackbaud.Adfs.Client.dll")
[Blackbaud.Adfs.Client.AdfsClient] $AdfsClient = new-object Blackbaud.Adfs.Client.AdfsClient($AdfsEndpoint, $Username, $Password, $MfaToken)

# Retrieve SAMLAssertion from ADFS
[String] $SamlAssertion = $AdfsClient.GetSamlResponse()

# Prompt for Role
[String] $SamlAssertionXml = [Blackbaud.Adfs.Client.AdfsClient]::ConvertSamlResponseToSamlXml($SamlAssertion)
[String[]] $SamlRoles = [Blackbaud.Adfs.Client.AdfsClient]::ExtractAttributeFromSamlXml($SamlAssertionXml, "https://aws.amazon.com/SAML/Attributes/Role")
Write-Host ""
Write-Host "AWS Roles:"
for([Int] $i = 0; $i -le ($SamlRoles.Length - 1); $i++) {
	[string] $SamlRole = $SamlRoles[$i].Split(",")[1]
	[string] $accountNum = $SamlRole.Substring($SamlRole.IndexOf("::") + 2, 12)
	[string] $roleName = $SamlRole.Substring($SamlRole.IndexOf("role/") + 5);
	if ($awsAccountDetailHashTable.ContainsKey($accountNum)) {
		$j = $i + 1
		Write-Host "[$j] - $($awsAccountDetailHashTable[$accountNum])-$roleName"
		}
		else {
			Write-Host ("   [$j] - $accountNum" + "-" + $roleName)
		}
}
$RoleIndex = (Read-Host "Enter the roles you like to choose (comma ',' separated) ")
$Roles = $RoleIndex.Split(',')
#Display the Roles in the console
Write-Host "Profile name to be used with AWS CLI:" 
foreach ( $role in $Roles)
{
	$rolesInput = [int] ($role.Trim())
	$rolesInput = $rolesInput - 1
	[String] $PrincipalArn = $SamlRoles[$rolesInput].Split(",")[0]
    [String] $RoleArn = $SamlRoles[$rolesInput].Split(",")[1]
    [string] $AccountNumber = $RoleArn.Substring($RoleArn.IndexOf("::") + 2, 12)
	[string] $AccroleName = $RoleArn.Substring($RoleArn.IndexOf("role/") + 5);
	
# Set dummy values on the AWS Defaults. For some reason, the 'Use-STSRoleWithSAML' command will error unless it detects pre-existing credentials.
Initialize-AWSDefaultConfiguration -AccessKey "1234" -SecretKey "1234"

# Establish secure session with AWS
Set-DefaultAWSRegion $AwsRegion
[Amazon.SecurityToken.Model.AssumeRoleWithSAMLResponse] $Response = Use-STSRoleWithSAML -PrincipalArn $PrincipalArn -RoleArn $RoleArn -SAMLAssertion $SamlAssertion

# Store session credentials as 'default' profile for AWS PowerShell (NetSDKCredentialsFile) and AWS CLI (SharedCredentialsFile)
Set-AWSCredentials -AccessKey $Response.Credentials.AccessKeyId -SecretKey $Response.Credentials.SecretAccessKey -SessionToken $Response.Credentials.SessionToken
#Set-AWSCredentials -StoreAs default -AccessKey $Response.Credentials.AccessKeyId -SecretKey $Response.Credentials.SecretAccessKey -SessionToken $Response.Credentials.SessionToken -ProfileLocation "$HOME/.aws/credentials"

# Store session credentials as 'session_profile' for AWS PowerShell (NetSDKCredentialsFile)
#Set-AWSCredentials -StoreAs $AccountNumber-$AccroleName -AccessKey $Response.Credentials.AccessKeyId -SecretKey $Response.Credentials.SecretAccessKey -SessionToken $Response.Credentials.SessionToken -ProfileLocation "$HOME/.aws/credentials"
if ($awsAccountDetailHashTable.ContainsKey($AccountNumber)) {
	$Profile = "$($awsAccountDetailHashTable[$AccountNumber])-$AccroleName"
	Set-AWSCredentials -StoreAs $Profile -AccessKey $Response.Credentials.AccessKeyId -SecretKey $Response.Credentials.SecretAccessKey -SessionToken $Response.Credentials.SessionToken -ProfileLocation "$HOME/.aws/credentials"
	}
	else {
		Set-AWSCredentials -StoreAs $AccountNumber-$AccroleName -AccessKey $Response.Credentials.AccessKeyId -SecretKey $Response.Credentials.SecretAccessKey -SessionToken $Response.Credentials.SessionToken -ProfileLocation "$HOME/.aws/credentials"
	}
	Write-Host $Profile 
	Write-Host "(eg: aws ec2 describe-instances --profile $Profile --region us-east-1 --query 'Reservations[*].Instances[*].[InstanceId]')" -ForegroundColor Red
}

Exit 0