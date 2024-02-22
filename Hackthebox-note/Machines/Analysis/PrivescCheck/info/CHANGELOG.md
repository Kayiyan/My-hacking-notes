# Changelog

## 2023-12-25

### Added

- Check for cached MSI files that run potentially unsafe Custom Actions.

## 2023-12-19

### Added

- Check for AppLocker rules that can be exploited to execute arbitrary code.

### Fixed

- Removed code analyzer decorators because they are not compatible with PSv2.

## 2023-12-07

### Changed

- Complete refactor of the Credential Guard check to remove the dependency on the Get-ComputerInfo cmdlet, which is only available in PS > v5.1. Instead, the WMI database is directly queried, in addition to the registry settings.
- Added decorators to suppress warnings on unused variables that define Windows structures.

## 2023-12-06

### Fixed

- The Point and Print check now also reports the "InForest" setting, that can be used as an alternative to "ServerList".
- Another attempt at figuring out the vulnerable (Package) Point and Print configurations...

### Changed

- Improved readability of application permissions check by expanding the array of file system rights.

## 2023-12-05

### Fixed

- In the HTML report, all cells containing raw output results are now scrollable.
- Fixed result discrepancies caused by NTFS filesystem redirection when running from a 32-bit PowerShell.

## 2023-12-03

### Added

- Check for SCCM Network Access Account credentials.

### Changed

- Updated build script to create a copy of 'PrivescCheck.ps1' at the root of the project.

## 2023-11-22

### Fixed

- Restored PSv2 compatibility regarding severity level enumeration.

## 2023-09-03

### Changed

- Improved result header.
- Improved BIOS mode + Secure Boot check.
- The modifiable application check now displays a warning when a system folder is detected, rather than searching it recursively.

## 2023-08-20

### Changed

- All the check descriptions were update to follow a more generic phrasing.
- Updated the style of the ASCII and HTML reports.

## 2023-08-19

### Changed

- The BitLocker check now returns something only if the configuration is vulnerable.
- Move AD domain helpers to the global Helper file.
- The LAPS check now returns something only if the configuration is vulnerable.
- The UAC check now returns something only if the configuration is vulnerable.
- Results are now sorted by severity in the short report.
- The Credential Guard check now returns something only if the configuration is vulnerable.
- The AlwaysInstallElevated check was refactored.
- The Point and Print config check was refactored.
- The WLAN profile check was refactored.
- The Airstrike attack check was refactored.
- The Driver Co-installer check now returns something only if the configuration is vulnerable.
- The LSA protection check now returns something only if the configuration is vulnerable.
- The BIOS mode check now returns something only if the configuration is vulnerable.
- The user privilege check now returns only exploitable privileges.

### Removed

- The "compliance" aspect was completely removed.

## 2023-08-14

### Changed

- Reworked the script output using unicode characters.
- Replaced the categories with main techniques from the Mitre Att&ck framework.

### Removed

- Removed the check "types" ("info"/"vuln") as this information was redundant with the severity. 

## 2023-08-13

### Fixed

- Fixed a false negative that caused Credential Guard to be reported as not being running. This could occur when Windows enabled it by default because the machine meets all the hardware and software requirements.

## 2023-07-22

### Changed

- Only one hash type is stored for each driver in the LOL drivers database to reduce the size of the final script.

### Fixed

- Fixed an latent issue that could cause module names to overlap in the final script.

## 2023-07-18

### Fixed

- Fixed a regression causing false negatives in `Invoke-ServicesUnquotedPathCheck` (see issue #48).

## 2023-07-10

### Added

- Add a check for vulnerable drivers based on the list provided by loldrivers.io.

### Changed

- Restructure the source code.
- Improved enumeration of leaked handles for better compatibility with PSv2.
- Check random module names with a regex to ensure they contain only a-z letters.

## 2023-07-02

### Changed

- The "build" script now generates random variable names for the modules. To do so, it downloads the word list from the "PyFuscation" project. If it cannot download the list, it falls back to using the filename instead.

## 2023-07-01

### Changed

- The "PrintNightmare" check was fully renamed as "Point and Print configuration", which is more accurate. The code was also completely refactored. The tests that are implemented for the different variants of the exploit should also be more reliable.

## 2023-06-28

### Fixed

- Two of the registry keys in the Point & Print configuration check were incorrect.

## 2023-06-18

### Added

- Updated the BitLocker check to report the startup authentication mode (TPM only, TPM+PIN, etc.).
- A helper function was added to extract the BitLocker status and configuration.

## 2023-05-23

### Added

- The DLL "SprintCSP.dll" was added to the list of phantom DLLs that can be hijacked (service "StorSvc").
- For each phantom DLL, a link to the (original?) source describing its discovery and exploitation is now provided.

### Changed

- A check's compliance result is no longer a Boolean. It is now represented as a String ("True", "False", "N/A").
- In HTML reports, the "Compliance" result is handled similarly to "Severity" levels, using a label.

## 2023-02-18

### Added

- Services > Invoke-ThirdPartyDriversCheck, for enumerating third-party drivers.

## 2023-02-18

### Changed

- Modified the Process access rights enumeration to bypass Cortex AMSI detection (AMSI rule flagging the string "CreateThread" as malicious).
- Changed the configuration of the Vault "cred" and "list" checks to enable them only in "Extended" mode to bypass Cortex behavioral detection.
- Updated the help text of the main Invoke-PrivescCheck cmdlet as suggested in PR #45.

### Fixed

- The WinLogon credential check now ensures that the password values are not empty.

## 2023-01-29

### Fixed

- The info check now shows the correct product name when running on Windows 11.

## 2022-11-07

### Fixed

- Getting the name of a process (based on its PID) could fail when enumerating network endpoints. These errors are now silently ignored.

## 2022-11-06

### Added

- Misc > Invoke-ExploitableLeakedHandlesCheck

### Changed

- Added a cache for user group SIDs and deny SIDs. Deny SIDs in particular caused a significant overhead in Get-ModifiablePath. The performance gain is substantial.
- The dates in the hotfix list are now displayed in ISO format to avoid confusion.

### Fixed

- Get-HotFixList missed some update packages because the regular expression used to browse the registry was incorrect.

## 2022-10-30

### Changed

- The builder now removes all the comments, thus lowering the chance of detection by AMSI.

## 2022-10-02

### Fixed

- Incorrect handling of deny-only groups in file ACL checks.
- Issue with Metasploit caused by the presence of a null byte in the output.

## 2022-08-14

### Changed

- Second try to supporting deny-only SIDs when checking DACLs (Get-AclModificationRights).

## 2022-08-07

### Changed

- DACL checking is now done in a dedicated cmdlet (Get-AclModificationRights) which can currently handle objects of types "File", "Directory" and "Registry Key".
- The Get-ModifiablePath and Get-ModifiableRegistryPath cmdlets now use the generic Get-AclModificationRights cmdlet.
- Deny ACEs are now taken into account when checking DACLs.

## 2022-06-08

### Added

- The value of the 'DisableWindowsUpdateAccess' setting is now reported in the WSUS check.

### Fixed

- System PATH parsing improved to ensure we do not check empty paths

## 2022-04-07

### Added

- Explicit output types where possible

### Changed

- Rewrite the Builder and the Loader
- Rename "Write-PrivescCheckAsciiReport" to "Show-PrivescCheckAsciiReport"

### Removed

- Trailing spaces in the entire code (code cleanup)
- Empty catch blocks

## 2022-03-13

### Added

- Network > Get-WlanProfileList, a helper function that retrieves the list of saved Wi-Fi profiles through the Windows API
- Network > Convert-WlanXmlProfile, a helper function that converts a WLAN XML profile to a custom PS object
- Network > Invoke-AirstrikeAttackCheck, check whether a workstation would be vulnerable to the Airstrike attack

### Changed

- Network > Invoke-WlanProfilesCheck, this check now detects potential issues in 802.1x Wi-Fi profiles

## 2022-03-10

### Fixed

- A typo in the Print Nightmare check following the previous code refactoring

## 2022-03-08

### Changed

- Refactored and improved Config > Invoke-PrintNightmareCheck
- Refactored registry key checks

## 2022-02-18

### Added

- Misc > Invoke-UserSessionListCheck

## 2022-02-13

### Added

- Config > Invoke-HardenedUNCPathCheck (@mr_mitm, @itm4n)

## 2022-01-13

### Added

- Misc > Invoke-DefenderExclusionsCheck

## 2021-09-13

### Added

- Config > Invoke-DriverCoInstallersCheck (@SAERXCIT)

## 2021-08-17

### Added

- Creds > Invoke-SensitiveHiveShadowCopyCheck (@SAERXCIT)

## 2021-07-23

### Added

- Config > Invoke-PrintNightmareCheck

## 2021-07-09

### Added

- XML output report format

## 2021-06-20

### Added

- Misc > Invoke-NamedPipePermissionsCheck (experimental)

## 2021-06-18

### Added

- Network > Invoke-NetworkAdaptersCheck

## 2021-06-16

### Added

- Invoke-UserCheck now retrieves more information about the current Token

## 2021-06-13

### Added

- User > Invoke-UserRestrictedSidsCheck in case of WRITE RESTRICTED Tokens

### Changed

- Group enumeration is now generic
- All privileges are now listed and the check is now considered "INFO"

## 2021-06-01

### Changed

- Group enumeration is now done using the Windows API

## 2021-05-28

### Added

- A "Build" tool to slightly obfuscate the script

### Changed

- Complete code refactor
- PrivescCheck no longer relies on compiled C# code (back to original PowerUp method)
- Code is now structured and split in "category" files
- LSA Protection and Credential Guard are now separate checks

### Fixed

- Fixed minor bugs

## 2021-04-06

### Added

- Services > Invoke-SCMPermissionsCheck

## 2020-10-29

### Added

- Scheduled Tasks > Invoke-ScheduledTasksUnquotedPathCheck

### Changed

- Refactored the report generation feature
- Refactored scheduled tasks check

## 2020-10-28

### Added

- A 'RunIfAdmin' mode. Some checks are now run even if the script is executed as an administrator.
- A severity level for each check

## 2020-10-27

### Added

- Config > Invoke-SccmCacheFolderVulnCheck

## 2020-10-07

### Added

- Additional custom checks can now be added as plugins
- A "silent" mode (only the final vulnerability report is displayed)
- Config > Invoke-SccmCacheFolderCheck
- Some report generation functions (HTML, CSV)

## 2020-10-06

### Added

- Apps > Invoke-ApplicationsOnStartupVulnCheck

## 2020-10-04

### Added

- Credentials > PowerShell History

## 2020-09-13

### Added

- basic vulnerability report

## 2020-09-04

### Added

- Misc > Invoke-EndpointProtectionCheck

## 2020-07-22

### Added

- Fixed a false positive: 'C:' resolves to the current directory
- Fixed a false positive: scheduled tasks running as the current user
- Hardening > Invoke-BitlockerCheck

## 2020-07-17

### Added

- Refactored Main function

## 2020-07-16

### Added

- Helper > Convert-SidToName
- Misc > Invoke-HotfixCheck
- Applications > Invoke-ProgramDataCheck

## 2020-04-09

### Added

- DLL Hijacking > Invoke-HijackableDllsCheck
- Applications > Invoke-ScheduledTasksCheck

## 2020-04-08

### Added

- Misc > Invoke-UsersHomeFolderCheck
- Programs > Invoke-ApplicationsOnStartupCheck
- Registry > Invoke-WsusConfigCheck
- User > Invoke-UserEnvCheck
- Updated Credentials > Invoke-CredentialFilesCheck

## 2020-03-21

### Added

- Handled exception in "Network > Invoke-WlanProfilesCheck" when dealing with servers

## 2020-03-12

### Added

- Network > Invoke-WlanProfilesCheck

## 2020-02-14

### Added

- Credentials > Invoke-VaultListCheck

### Changed

- Renamed Credentials > Invoke-CredentialManagerCheck -> Invoke-VaultCredCheck

## 2020-02-09

### Added

- Credentials > Invoke-GPPPasswordCheck

## 2020-01-30

### Added

- Credentials > Invoke-CredentialManagerCheck

## 2020-01-29

### Added

- Fixed bug Helper > Get-ModifiablePath (error handling in Split-Path)

## 2020-01-20

### Added

- Fixed bug User > Invoke-UserGroupsCheck (don't translate SIDs like "S-1-5.*")

## 2020-01-17

### Added

- Helper > Get-UEFIStatus
- Helper > Get-SecureBootStatus
- Helper > Get-CredentialGuardStatus
- Helper > Get-LsaRunAsPPLStatus
- Registry > Invoke-LsaProtectionsCheck
- Helper > Get-UnattendSensitiveData
- Credentials > Invoke-UnattendFilesCheck

### Changed

- Merged Sensitive Files with Credentials

## 2020-01-16

### Added

- Moved "Invoke-PrivescCheck.ps1" from "Pentest-Tools" to a dedicated repo.
- User > Invoke-UserCheck
- User > Invoke-UserGroupsCheck
- User > Invoke-UserPrivilegesCheck
- Services > Invoke-InstalledServicesCheck
- Services > Invoke-ServicesPermissionsCheck
- Services > Invoke-ServicesPermissionsRegistryCheck
- Services > Invoke-ServicesImagePermissionsCheck
- Services > Invoke-ServicesUnquotedPathCheck
- Dll Hijacking > Invoke-DllHijackingCheck
- Sensitive Files > Invoke-SamBackupFilesCheck
- Programs > Invoke-InstalledProgramsCheck
- Programs > Invoke-ModifiableProgramsCheck
- Programs > Invoke-RunningProcessCheck
- Credentials > Invoke-WinlogonCheck
- Credentials > Invoke-CredentialFilesCheck
- Registry > Invoke-UacCheck
- Registry > Invoke-LapsCheck
- Registry > Invoke-PowershellTranscriptionCheck
- Registry > Invoke-RegistryAlwaysInstallElevatedCheck
- Network > Invoke-TcpEndpointsCheck
- Network > Invoke-UdpEndpointsCheck
- Misc > Invoke-WindowsUpdateCheck
- Misc > Invoke-SystemInfoCheck
- Misc > Invoke-LocalAdminGroupCheck
- Misc > Invoke-MachineRoleCheck
- Misc > Invoke-SystemStartupHistoryCheck
- Misc > Invoke-SystemStartupCheck
- Misc > Invoke-SystemDrivesCheck