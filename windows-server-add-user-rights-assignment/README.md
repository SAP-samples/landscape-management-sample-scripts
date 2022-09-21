# Add User Rights Assignment with Windows Server

The `Add-UserRightsAssignment` cmdlet assigns a set of rights to one or more users by modifying the User Rights Assignments within the local security policy.
For example, it can be used to automate the assignment of user rights, that are required to run Software Provisioning Manager (SWPM) (see [SAP Note #2515202](https://launchpad.support.sap.com/#/notes/2515202)).

## PARAMETERS
### Username
The name(s) of the user(s) that will be assigned the given user rights (Paramter `SecuritySetting`). If the script fails translating one or more user names into the related SIDs, the script execution is aborted and the local security policy is not modified.

### SecuritySetting
A list of user rights (Se*).
For a list of possible values, see [Local Security Policy - User Rights Assignment](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/user-rights-assignment).

## EXAMPLES
* This example assigns the user right `SeServiceLogonRight` to the domain users `contoso.com\user1` and `contoso.com\user2` and the local user `MyLocalSvcUser`
    ```shell
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\user1", "contoso.com\user2", "MyLocalSvcUser" -SecuritySetting SeServiceLogonRight
    ```
* This example assigns the user rights `SeNetworkLogonRight` and `SeDenyInteractiveLogonRight` to the domain user `contoso.com\user3`
    ```
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\user3" -SecuritySetting SeNetworkLogonRight, SeDenyInteractiveLogonRight
    ```
* This example assigns the user rights `SeAssignPrimaryTokenPrivilege`, `SeIncreaseQuotaPrivilege` and `SeTcbPrivilege`, required to run SWPM, to the domain user `contoso.com\SAPInstallUser`.
    ```
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\SAPInstallUser" -SecuritySetting SeAssignPrimaryTokenPrivilege, SeIncreaseQuotaPrivilege, SeTcbPrivilege
    ```

## LINK
[Local Security Policy - User Rights Assignment](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/user-rights-assignment)
