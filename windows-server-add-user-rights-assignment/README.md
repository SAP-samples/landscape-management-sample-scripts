# Add User Rights Assignment with Windows Server
## SYNOPSIS
Assigns a set of rights to one or more users.

## DESCRIPTION

The `Add-UserRightsAssignment` cmdlet assigns a set of rights to one or more users by modifying the User Rights Assignments within the local security policy.

## PARAMETERS
### Username
The name(s) of the user(s) that will be assigned the given user rights (Paramter SecuritySetting). If the script fails translating one or more user names into the related SIDs, the script execution is aborted and the local security policy is not modified.

### SecuritySetting
A list of user rights (Se*).

## EXAMPLES
* This example assings the user right SeServiceLogonRight to the domain users contoso.com\user1 and contoso.com\user2 and the local user MyLocalSvcUser
    ```shell
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\user1", "contoso.com\user2", "MyLocalSvcUser" -SecuritySetting SeServiceLogonRight
    ``` 
* This example assings the user rights SeNetworkLogonRight and SeDenyInteractiveLogonRight to the domain user contoso.com\user3
    ```
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\user3" -SecuritySetting SeNetworkLogonRight, SeDenyInteractiveLogonRight
    ``` 

## LINK
[Local Security Policy - User Rights Assignment](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/user-rights-assignment)
