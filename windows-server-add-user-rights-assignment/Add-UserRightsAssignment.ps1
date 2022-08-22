<#
.SYNOPSIS
    Assigns a set of rights to one or more users.

.DESCRIPTION
    The `Add-UserRightsAssignment` cmdlet assigns a set of rights to one or more users by modifying the User Rights Assignments within the local security policy.

.PARAMETER Username
    The name(s) of the user(s) that will be assigned the given user rights (Paramter SecuritySetting).
    If the script fails translating one or more user names into the related SIDs, the script execution is aborted and the local security policy is not modified.

.PARAMETER SecuritySetting
    A list of user rights (Se*).

.EXAMPLE
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\user1", "contoso.com\user2", "MyLocalSvcUser" -SecuritySetting SeServiceLogonRight

    This example assings the user right SeServiceLogonRight to the domain users contoso.com\user1 and contoso.com\user2 and the local user MyLocalSvcUser

.EXAMPLE
    .\Add-UserRightsAssignment.ps1 -Username "contoso.com\user3" -SecuritySetting SeNetworkLogonRight, SeDenyInteractiveLogonRight

    This example assings the user rights SeNetworkLogonRight and SeDenyInteractiveLogonRight to the domain user contoso.com\user3
.LINK
    Local Security Policy - User Rights Assignment: https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/user-rights-assignment
#>
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]] $Username,

    [Parameter(Mandatory = $true)]
    [ValidateSet(
        "SeAssignPrimaryTokenPrivilege", "SeAuditPrivilege",
        "SeBackupPrivilege", "SeBatchLogonRight", "SeChangeNotifyPrivilege", "SeCreateGlobalPrivilege", "SeCreatePagefilePrivilege", "SeCreateSymbolicLinkPrivilege",
        "SeDebugPrivilege", "SeDelegateSessionUserImpersonatePrivilege",
        "SeDenyBatchLogonRight", "SeDenyInteractiveLogonRight", "SeDenyNetworkLogonRight", "SeDenyRemoteInteractiveLogonRight", "SeDenyServiceLogonRight",
        "SeImpersonatePrivilege", "SeIncreaseBasePriorityPrivilege", "SeIncreaseQuotaPrivilege", "SeIncreaseWorkingSetPrivilege", "SeInteractiveLogonRight",
        "SeLoadDriverPrivilege", "SeManageVolumePrivilege",
        "SeNetworkLogonRight",
        "SeProfileSingleProcessPrivilege",
        "SeRemoteInteractiveLogonRight", "SeRemoteShutdownPrivilege", "SeRestorePrivilege",
        "SeSecurityPrivilege", "SeServiceLogonRight", "SeShutdownPrivilege", "SeSystemEnvironmentPrivilege", "SeSystemProfilePrivilege", "SeSystemtimePrivilege",
        "SeTakeOwnershipPrivilege", "SeTcbPrivilege", "SeTimeZonePrivilege",
        "SeUndockPrivilege")]
    [string[]] $SecuritySetting
)

## Version: 1.0

#Requires -Version 5.0
#Requires -RunAsAdministrator

#  User for printing a pretty overview table
$Username2SID = @()
[string[]] $SIDs = @()
[string[]] $TranslationFailed = @()

Write-Host
Write-Host ("=" * 80)
Write-Host "= Add-UserRightsAssignment"
Write-Host ("=" * 80)

Write-Host
Write-Host "Translating accounts(s) to SID(s)."
[string] $SIDValue
foreach ($user in $Username) {
    try {
        $account = New-Object System.Security.Principal.NTAccount($user)
        $sid = $account.Translate([System.Security.Principal.SecurityIdentifier])
        $SIDValue = $sid.Value
        if (![string]::IsNullOrWhiteSpace($SIDValue)) {
            $SIDs += $SIDValue
        }
        else {
            $SIDValue = "-"
        }
    }
    catch {
        $SIDValue = "-"
        $TranslationFailed += $user
    }
    finally {
        $Username2SID += New-Object -TypeName PSObject -Property @{
            "Username" = $user;
            "SID"      = $SIDValue;
        }
    }
}

$Username2SID | Sort-Object -Property "Username" | Format-Table -Property "Username", "SID" -AutoSize

if ($TranslationFailed.Count -gt 0) {
    $ErrorMessage = ("Failed to get SIDs for the following accounts:
  - {0}

Script will not modify the local security policy." -f ([string]::Join("`r`n  - ", $TranslationFailed)))

    Write-Error -Message $ErrorMessage
    exit 1
}

[string] $CfgFilePath = [System.IO.Path]::GetTempFileName()
[string] $BackupFilePath = [System.IO.Path]::Combine(
    [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments),
    ("LocalSecuritySettings_Backup_{0}.bak" -f (Get-Date -Format "yyyy-MM-dd"))
)
[string] $SeceditBackupLogFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "scedit_export_backup.log")
[string] $SeceditExportLogFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "scedit_export.log")
[string] $SeceditImportLogFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "scedit_import.log")

Remove-Item -Path $SeceditBackupLogFile -Force -ErrorAction SilentlyContinue
Remove-Item -Path $SeceditExportLogFile -Force -ErrorAction SilentlyContinue
Remove-Item -Path $SeceditImportLogFile -Force -ErrorAction SilentlyContinue

Write-Host
Write-Host "Creating backup of Local Security Settings to file: `r`n    ${BackupFilePath} ... " -NoNewline

# ================================================================================
# !!!!           DO NOT USE THE PARAMETER "/areas USER_RIGHTS" here           !!!!
# !!!!                   This will break the file content!                    !!!!
# ================================================================================
secedit.exe /export /cfg "${BackupFilePath}" /log "${SeceditBackupLogFile}" /quiet
if (Test-Path -Path $BackupFilePath -PathType Leaf) {
    Write-Host "Done." -ForegroundColor Green
}
else {
    Write-Host "FAILED!" -ForegroundColor Red
    exit 1
}

try {

    Write-Host
    Write-Host "Exporting user rights assignment to file: `r`n    ${CfgFilePath} ... " -NoNewline
    secedit.exe /export /cfg $CfgFilePath /log "${SeceditExportLogFile}" /quiet
    if (Test-Path -Path $CfgFilePath -PathType Leaf) {
        Write-Host "Done." -ForegroundColor Green
    }
    else {
        Write-Host "FAILED!" -ForegroundColor Red
        exit 1
    }

    [string[]] $settings = Get-Content -Path $CfgFilePath
    [string[]] $modifiedLines = @()
    [string[]] $addedSIDs = @()
    [bool] $Modified = $false

    Write-Host
    Write-Host "Updating user rights assignments"
    for ($i = 0; $i -lt $settings.Length; $i++) {

        if ($settings[$i].Trim().Length -lt 1) { continue; }

        foreach ($secSettingName in $SecuritySetting) {

            if ($settings[$i] -ilike "${secSettingName}*") {
                $Modified = $false
                $addedSIDs = @()

                Write-Host "  ... Updating " -NoNewline
                Write-Host $secSettingName -ForegroundColor Gray

                foreach ($sid in $SIDs) {
                    if ($settings[$i].IndexOf("*${sid}") -lt 0) {
                        # SID is not part of this string.
                        $settings[$i] += ",*${sid}"
                        $Modified = $true
                        $addedSIDs += $sid
                    }
                }

                if ($Modified) {
                    $modifiedLines += $settings[$i]
                    Write-Host ("      --> Added missing SIDs: {0}" -f [string]::Join(", ", $addedSIDs))
                }
            }
        }
    }

    $settings | Out-File $CfgFilePath

    Write-Host "Please review config file '${CfgFilePath}'."
    Write-Host "Modified lines:"
    $modifiedLines | ForEach-Object { Write-Host " - $_" }
    Read-Host "Press ENTER to update local security settings"

    secedit.exe /configure /db secedit.sdb /areas USER_RIGHTS /cfg $CfgFilePath /log "${SeceditImportLogFile}" /quiet

    Write-Host "secedit.exe finished with exit code ${LASTEXITCODE}"
}
catch {
    Write-Host "
--------------------------------------------------------------------------------
-                                    ERROR                                     -
--------------------------------------------------------------------------------

Failed to update user rights assignments: $_

Please review the log files:
  - Backup creation: ${SeceditBackupLogFile}
  - Data export: ${SeceditExportLogFile}
  - Data import: ${SeceditImportLogFile}

--------------------------------------------------------------------------------
"
}
finally {
    if (Test-Path -Path $CfgFilePath -PathType Leaf) {
        Write-Debug "Removing file '$CfgFilePath'."
        Remove-Item -Path $CfgFilePath -Force -ErrorAction Continue
    }
}
