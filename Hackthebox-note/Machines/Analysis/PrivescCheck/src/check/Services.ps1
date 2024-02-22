function Invoke-InstalledServicesCheck {
    <#
    .SYNOPSIS
    Enumerates non-default services

    Author: @itm4n
    License: BSD 3-Clause

    .DESCRIPTION
    It uses the custom "Get-ServiceList" function to get a filtered list of services that are configured on the local machine. Then it returns each result in a custom PS object, indicating the name, display name, binary path, user and start mode of the service.

    .EXAMPLE
    PS C:\> Invoke-InstalledServicesCheck | ft

    Name    DisplayName  ImagePath                                           User        StartMode
    ----    -----------  ---------                                           ----        ---------
    VMTools VMware Tools "C:\Program Files\VMware\VMware Tools\vmtoolsd.exe" LocalSystem Automatic
    #>

    [CmdletBinding()] Param()

    Get-ServiceList -FilterLevel 3 | Select-Object -Property Name,DisplayName,ImagePath,User,StartMode
}

function Invoke-ServicesPermissionsRegistryCheck {
    <#
    .SYNOPSIS
    Checks the permissions of the service settings in the registry

    Author: @itm4n
    License: BSD 3-Clause

    .DESCRIPTION
    The configuration of the services is maintained in the registry. Being able to modify these registry keys means being able to change the settings of a service. In addition, a complete machine reboot isn't necessary for these settings to be taken into account. Only the affected service needs to be restarted.

    .EXAMPLE
    PS C:\> Invoke-ServicesPermissionsRegistryCheck

    Name              : DVWS
    ImagePath         : C:\DVWS\Vuln Service\service.exe
    User              : NT AUTHORITY\LocalService
    ModifiablePath    : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DVWS
    IdentityReference : NT AUTHORITY\Authenticated Users
    Permissions       : {ReadControl, ReadData/ListDirectory, AppendData/AddSubdirectory, WriteData/AddFile...}
    Status            : Stopped
    UserCanStart      : True
    UserCanStop       : True
    #>

    [CmdletBinding()] Param(
        [UInt32] $BaseSeverity
    )

    # Get all services except the ones with an empty ImagePath or Drivers
    $AllServices = Get-ServiceList -FilterLevel 2
    Write-Verbose "Enumerating $($AllServices.Count) services..."

    $ArrayOfResults = @()

    foreach ($Service in $AllServices) {

        Get-ModifiableRegistryPath -Path "$($Service.RegistryPath)" | Where-Object { $_ -and (-not [String]::IsNullOrEmpty($_.ModifiablePath)) } | Foreach-Object {

            $Status = "Unknown"
            $UserCanStart = $false
            $UserCanStop = $false

            $ServiceObject = Get-Service -Name $Service.Name -ErrorAction SilentlyContinue
            if ($ServiceObject) {
                $Status = $ServiceObject | Select-Object -ExpandProperty "Status"
                $ServiceCanStart = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Start'
                if ($ServiceCanStart) { $UserCanStart = $true } else { $UserCanStart = $false }
                $ServiceCanStop = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Stop'
                if ($ServiceCanStop) { $UserCanStop = $true } else { $UserCanStop = $false }
            }

            $VulnerableService = New-Object -TypeName PSObject
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "Name" -Value $Service.Name
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "ImagePath" -Value $Service.ImagePath
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "User" -Value $Service.User
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "ModifiablePath" -Value $Service.RegistryPath
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "IdentityReference" -Value $_.IdentityReference
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "Permissions" -Value ($_.Permissions -join ", ")
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "Status" -Value $Status
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "UserCanStart" -Value $UserCanStart
            $VulnerableService | Add-Member -MemberType "NoteProperty" -Name "UserCanStop" -Value $UserCanStop
            $ArrayOfResults += $VulnerableService
        }
    }

    $Result = New-Object -TypeName PSObject
    $Result | Add-Member -MemberType "NoteProperty" -Name "Result" -Value $ArrayOfResults
    $Result | Add-Member -MemberType "NoteProperty" -Name "Severity" -Value $(if ($ArrayOfResults) { $BaseSeverity } else { $SeverityLevelEnum::None })
    $Result
}

function Invoke-ServicesUnquotedPathCheck {
    <#
    .SYNOPSIS
    Enumerates all the services with an unquoted path. For each one of them, enumerates paths that the current user can modify. Based on the original "Get-ServiceUnquoted" function from PowerUp.

    Author: @itm4n
    License: BSD 3-Clause

    .DESCRIPTION
    In my version of this function, I tried to eliminate as much false positives as possible. PowerUp tends to report "C:\" as exploitable whenever a program located in "C:\Program Files" is identified. The problem is that we cannot write "C:\program.exe" so the service wouldn't be exploitable. We can only create folders in "C:\" by default.

    .PARAMETER Info
    Use this option to return all services with an unquoted path containing spaces without checking if they are vulnerable.

    .EXAMPLE
    PS C:\> Invoke-ServicesUnquotedPathCheck

    Name              : VulnService
    ImagePath         : C:\APPS\My App\service.exe
    User              : LocalSystem
    ModifiablePath    : C:\APPS
    IdentityReference : NT AUTHORITY\Authenticated Users
    Permissions       : {Delete, WriteAttributes, Synchronize, ReadControl...}
    Status            : Unknown
    UserCanStart      : False
    UserCanStop       : False
    #>

    [CmdletBinding()] Param(
        [switch] $Info = $false,
        [UInt32] $BaseSeverity
    )

    begin {
        # Get all services which have a non-empty ImagePath (exclude drivers as well)
        $Services = Get-ServiceList -FilterLevel 2
        $ArrayOfResults = @()
        $FsRedirectionValue = Disable-Wow64FileSystemRedirection
    }

    process {
        Write-Verbose "Enumerating $($Services.Count) services..."
        foreach ($Service in $Services) {

            $ImagePath = $Service.ImagePath.trim()
    
            if ($Info) {
    
                if (-not ([String]::IsNullOrEmpty($(Get-UnquotedPath -Path $ImagePath -Spaces)))) {
                    $Service | Select-Object Name,DisplayName,User,ImagePath,StartMode
                }
    
                # If Info, return the result without checking if the path is vulnerable
                continue
            }
    
            Get-ExploitableUnquotedPath -Path $ImagePath | ForEach-Object {
    
                $Status = "Unknown"
                $UserCanStart = $false
                $UserCanStop = $false
    
                $ServiceObject = Get-Service -Name $Service.Name -ErrorAction SilentlyContinue
                if ($ServiceObject) {
                    $Status = $ServiceObject | Select-Object -ExpandProperty "Status"
                    $ServiceCanStart = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Start'
                    if ($ServiceCanStart) { $UserCanStart = $true } else { $UserCanStart = $false }
                    $ServiceCanStop = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Stop'
                    if ($ServiceCanStop) { $UserCanStop = $true } else { $UserCanStop = $false }
                }
    
                $Result = New-Object -TypeName PSObject
                $Result | Add-Member -MemberType "NoteProperty" -Name "Name" -Value $Service.Name
                $Result | Add-Member -MemberType "NoteProperty" -Name "ImagePath" -Value $Service.ImagePath
                $Result | Add-Member -MemberType "NoteProperty" -Name "User" -Value $Service.User
                $Result | Add-Member -MemberType "NoteProperty" -Name "ModifiablePath" -Value $_.ModifiablePath
                $Result | Add-Member -MemberType "NoteProperty" -Name "IdentityReference" -Value $_.IdentityReference
                $Result | Add-Member -MemberType "NoteProperty" -Name "Permissions" -Value ($_.Permissions -join ", ")
                $Result | Add-Member -MemberType "NoteProperty" -Name "Status" -Value $Status
                $Result | Add-Member -MemberType "NoteProperty" -Name "UserCanStart" -Value $UserCanStart
                $Result | Add-Member -MemberType "NoteProperty" -Name "UserCanStop" -Value $UserCanStop
                $ArrayOfResults += $Result
            }
        }
    
        if (-not $Info) {
            $Result = New-Object -TypeName PSObject
            $Result | Add-Member -MemberType "NoteProperty" -Name "Result" -Value $ArrayOfResults
            $Result | Add-Member -MemberType "NoteProperty" -Name "Severity" -Value $(if ($ArrayOfResults) { $BaseSeverity } else { $SeverityLevelEnum::None })
            $Result
        }
    }

    end {
        Restore-Wow64FileSystemRedirection -OldValue $FsRedirectionValue
    }
}

function Invoke-ServicesImagePermissionsCheck {
    <#
    .SYNOPSIS
    Enumerates all the services that have a modifiable binary (or argument)

    Author: @itm4n
    License: BSD 3-Clause

    .DESCRIPTION
    FIrst, it enumerates the services thanks to the custom "Get-ServiceList" function. For each result, it checks the permissions of the ImagePath setting thanks to the "Get-ModifiablePath" function. Each result is returned in a custom PS object.

    .EXAMPLE
    PS C:\> Invoke-ServicesImagePermissionsCheck

    Name              : VulneService
    ImagePath         : C:\APPS\service.exe
    User              : LocalSystem
    ModifiablePath    : C:\APPS\service.exe
    IdentityReference : NT AUTHORITY\Authenticated Users
    Permissions       : {Delete, WriteAttributes, Synchronize, ReadControl...}
    Status            : Unknown
    UserCanStart      : False
    UserCanStop       : False
    #>

    [CmdletBinding()] Param(
        [UInt32] $BaseSeverity
    )

    begin {
        $Services = Get-ServiceList -FilterLevel 2
        $ArrayOfResults = @()
        $FsRedirectionValue = Disable-Wow64FileSystemRedirection
    }

    process {
        Write-Verbose "Enumerating $($Services.Count) services..."
        foreach ($Service in $Services) {

            $Service.ImagePath | Get-ModifiablePath | Where-Object { $_ -and (-not [String]::IsNullOrEmpty($_.ModifiablePath)) } | Foreach-Object {
    
                $Status = "Unknown"
                $UserCanStart = $false
                $UserCanStop = $false
                $ServiceObject = Get-Service -Name $Service.Name -ErrorAction SilentlyContinue
                if ($ServiceObject) {
                    $Status = $ServiceObject | Select-Object -ExpandProperty "Status"
                    $ServiceCanStart = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Start'
                    if ($ServiceCanStart) { $UserCanStart = $true } else { $UserCanStart = $false }
                    $ServiceCanStop = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Stop'
                    if ($ServiceCanStop) { $UserCanStop = $true } else { $UserCanStop = $false }
                }
    
                $Result = New-Object -TypeName PSObject
                $Result | Add-Member -MemberType "NoteProperty" -Name "Name" -Value $Service.Name
                $Result | Add-Member -MemberType "NoteProperty" -Name "ImagePath" -Value $Service.ImagePath
                $Result | Add-Member -MemberType "NoteProperty" -Name "User" -Value $Service.User
                $Result | Add-Member -MemberType "NoteProperty" -Name "ModifiablePath" -Value $_.ModifiablePath
                $Result | Add-Member -MemberType "NoteProperty" -Name "IdentityReference" -Value $_.IdentityReference
                $Result | Add-Member -MemberType "NoteProperty" -Name "Permissions" -Value ($_.Permissions -join ", ")
                $Result | Add-Member -MemberType "NoteProperty" -Name "Status" -Value $Status
                $Result | Add-Member -MemberType "NoteProperty" -Name "UserCanStart" -Value $UserCanStart
                $Result | Add-Member -MemberType "NoteProperty" -Name "UserCanStop" -Value $UserCanStop
                $ArrayOfResults += $Result
            }
        }
    
        $Result = New-Object -TypeName PSObject
        $Result | Add-Member -MemberType "NoteProperty" -Name "Result" -Value $ArrayOfResults
        $Result | Add-Member -MemberType "NoteProperty" -Name "Severity" -Value $(if ($ArrayOfResults) { $BaseSeverity } else { $SeverityLevelEnum::None })
        $Result
    }

    end {
        Restore-Wow64FileSystemRedirection -OldValue $FsRedirectionValue
    }
}

function Invoke-ServicesPermissionsCheck {
    <#
    .SYNOPSIS
    Enumerates the services the current can modify through the service manager. In addition, it shows whether the service can be started/restarted.

    Author: @itm4n
    License: BSD 3-Clause

    .DESCRIPTION
    This is based on the original "Get-ModifiableService" from PowerUp.

    .EXAMPLE
    PS C:\> Invoke-ServicesPermissionsCheck

    Name           : DVWS
    ImagePath      : C:\DVWS\Vuln Service\service.exe
    User           : LocalSystem
    Status         : Stopped
    UserCanStart   : True
    UserCanStop    : True

    .LINK
    https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1
    #>

    [CmdletBinding()] Param(
        [UInt32] $BaseSeverity
    )

    # Get-ServiceList returns a list of custom Service objects. The properties of a custom Service
    # object are: Name, DisplayName, User, ImagePath, StartMode, Type, RegsitryKey, RegistryPath.
    # We also apply the FilterLevel 1 to filter out services which have an empty ImagePath
    $Services = Get-ServiceList -FilterLevel 1
    Write-Verbose "Enumerating $($Services.Count) services..."

    $ArrayOfResults = @()

    # For each custom Service object in the list
    foreach ($Service in $Services) {

        # Get a 'real' Service object and the associated DACL, based on its name
        $TargetService = Test-ServiceDaclPermission -Name $Service.Name -PermissionSet 'ChangeConfig'

        if ($TargetService) {

            $Status = "Unknown"
            $UserCanStart = $false
            $UserCanStop = $false

            $ServiceObject = Get-Service -Name $Service.Name -ErrorAction SilentlyContinue
            if ($ServiceObject) {
                $Status = $ServiceObject | Select-Object -ExpandProperty "Status"
                $ServiceCanStart = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Start'
                if ($ServiceCanStart) { $UserCanStart = $true } else { $UserCanStart = $false }
                $ServiceCanStop = Test-ServiceDaclPermission -Name $Service.Name -Permissions 'Stop'
                if ($ServiceCanStop) { $UserCanStop = $true } else { $UserCanStop = $false }
            }

            $Result = New-Object -TypeName PSObject
            $Result | Add-Member -MemberType "NoteProperty" -Name "Name" -Value $Service.Name
            $Result | Add-Member -MemberType "NoteProperty" -Name "ImagePath" -Value $Service.ImagePath
            $Result | Add-Member -MemberType "NoteProperty" -Name "User" -Value $Service.User
            $Result | Add-Member -MemberType "NoteProperty" -Name "AccessRights" -Value $TargetService.AccessRights
            $Result | Add-Member -MemberType "NoteProperty" -Name "IdentityReference" -Value $TargetService.IdentityReference
            $Result | Add-Member -MemberType "NoteProperty" -Name "Status" -Value $Status
            $Result | Add-Member -MemberType "NoteProperty" -Name "UserCanStart" -Value $UserCanStart
            $Result | Add-Member -MemberType "NoteProperty" -Name "UserCanStop" -Value $UserCanStop
            $ArrayOfResults += $Result
        }
    }

    $Result = New-Object -TypeName PSObject
    $Result | Add-Member -MemberType "NoteProperty" -Name "Result" -Value $ArrayOfResults
    $Result | Add-Member -MemberType "NoteProperty" -Name "Severity" -Value $(if ($ArrayOfResults) { $BaseSeverity } else { $SeverityLevelEnum::None })
    $Result
}

function Invoke-SCMPermissionsCheck {
    <#
    .SYNOPSIS
    Checks whether the permissions of the SCM allows the current user to perform privileged actions.

    .DESCRIPTION
    The SCM (Service Control Manager) has its own DACL, which is defined by the system. Though, it is possible to apply a custom one using the built-in "sc.exe" command line tool and a modified SDDL string for example. However, such manipulation is dangerous and is prone to errors. Therefore, the objective of this function is to check whether the current user as any modification rights on the SCM itself.

    .EXAMPLE
    PS C:\> Invoke-SCMPermissionsCheck

    AceType      : AccessAllowed
    AccessRights : AllAccess
    IdentitySid  : S-1-5-32-545
    IdentityName : BUILTIN\Users
    #>

    [CmdletBinding()] Param(
        [UInt32] $BaseSeverity
    )

    $UserIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $CurrentUserSids = $UserIdentity.Groups | Select-Object -ExpandProperty Value
    $CurrentUserSids += $UserIdentity.User.Value
    $ArrayOfResults = @()

    Get-ServiceControlManagerDacl | Where-Object { $($_ | Select-Object -ExpandProperty "AceType") -match "AccessAllowed" } | ForEach-Object {

        $CurrentAce = $_

        $Permissions = [Enum]::GetValues($ServiceControlManagerAccessRightsEnum) | Where-Object {
            ($CurrentAce.AccessMask -band ($ServiceControlManagerAccessRightsEnum::$_)) -eq ($ServiceControlManagerAccessRightsEnum::$_)
        }

        $PermissionReference = @(
            $ServiceControlManagerAccessRightsEnum::CreateService,
            $ServiceControlManagerAccessRightsEnum::ModifyBootConfig,
            $ServiceControlManagerAccessRightsEnum::AllAccess,
            $ServiceControlManagerAccessRightsEnum::GenericWrite
        )

        if (Compare-Object -ReferenceObject $Permissions -DifferenceObject $PermissionReference -IncludeEqual -ExcludeDifferent) {

            $IdentityReference = $($CurrentAce | Select-Object -ExpandProperty "SecurityIdentifier").ToString()

            if ($CurrentUserSids -contains $IdentityReference) {

                $Result = New-Object -TypeName PSObject
                $Result | Add-Member -MemberType "NoteProperty" -Name "AceType" -Value $($CurrentAce | Select-Object -ExpandProperty "AceType")
                $Result | Add-Member -MemberType "NoteProperty" -Name "AccessRights" -Value $($CurrentAce | Select-Object -ExpandProperty "AccessRights")
                $Result | Add-Member -MemberType "NoteProperty" -Name "IdentitySid" -Value $IdentityReference
                $Result | Add-Member -MemberType "NoteProperty" -Name "IdentityName" -Value $(Convert-SidToName -Sid $IdentityReference)
                $ArrayOfResults += $Result
            }
        }
    }

    $Result = New-Object -TypeName PSObject
    $Result | Add-Member -MemberType "NoteProperty" -Name "Result" -Value $ArrayOfResults
    $Result | Add-Member -MemberType "NoteProperty" -Name "Severity" -Value $(if ($ArrayOfResults) { $BaseSeverity } else { $SeverityLevelEnum::None })
    $Result
}

function Invoke-ThirdPartyDriversCheck {
    <#
    .SYNOPSIS
    Lists non-Microsoft drivers.

    Author: @itm4n
    License: BSD 3-Clause
    
    .DESCRIPTION
    For each service registered as a driver, the properties of the driver file are queried. If the file does not originate from Microsoft, the service object is reported. In addition, the file's metadata is appended to the object.
    
    .EXAMPLE
    PS C:\> Invoke-ThirdPartyDriversCheck
    
    Name        : 3ware
    ImagePath   : System32\drivers\3ware.sys
    StartMode   : Boot
    Type        : KernelDriver
    Status      : Stopped
    ProductName : LSI 3ware RAID Controller
    Company     : LSI
    Description : LSI 3ware SCSI Storport Driver
    Version     : 5.01.00.051
    Copyright   : Copyright (c) 2011 LSI

    Name        : ADP80XX
    ImagePath   : System32\drivers\ADP80XX.SYS
    StartMode   : Boot
    Type        : KernelDriver
    Status      : Stopped
    ProductName : PMC-Sierra HBA Controller
    Company     : PMC-Sierra
    Description : PMC-Sierra Storport  Driver For SPC8x6G SAS/SATA controller
    Version     : 1.3.0.10769 (NT.150223-1854)
    Copyright   : Copyright (C) PMC-Sierra 2001-2014

    [...]
    #>

    [CmdletBinding()] Param()

    begin {
        $FsRedirectionValue = Disable-Wow64FileSystemRedirection
    }

    process {
        Get-DriverList | ForEach-Object {

            $ImageFile = Get-Item -Path $_.ImagePathResolved -ErrorAction SilentlyContinue
    
            if ($null -ne $ImageFile) {
    
                if (-not (Test-IsMicrosoftFile -File $ImageFile)) {
    
                    $ServiceObject = Get-Service -Name $_.Name -ErrorAction SilentlyContinue
                    if ($null -eq $ServiceObject) { Write-Warning "Failed to query service $($_.Name)"; continue }
            
                    $VersionInfo = $ImageFile | Select-Object -ExpandProperty VersionInfo
    
                    $Result = $_ | Select-Object Name,ImagePath,StartMode,Type
                    $Result | Add-Member -MemberType "NoteProperty" -Name "Status" -Value $(if ($ServiceObject) { $ServiceObject.Status} else { "Unknown" })
                    $Result | Add-Member -MemberType "NoteProperty" -Name "ProductName" -Value $(if ($VersionInfo.ProductName) { $VersionInfo.ProductName.trim() } else { "Unknown" })
                    $Result | Add-Member -MemberType "NoteProperty" -Name "Company" -Value $(if ($VersionInfo.CompanyName) { $VersionInfo.CompanyName.trim() } else { "Unknown" })
                    $Result | Add-Member -MemberType "NoteProperty" -Name "Description" -Value $(if ($VersionInfo.FileDescription) { $VersionInfo.FileDescription.trim() } else { "Unknown" })
                    $Result | Add-Member -MemberType "NoteProperty" -Name "Version" -Value $(if ($VersionInfo.FileVersion) { $VersionInfo.FileVersion.trim() } else { "Unknown" })
                    $Result | Add-Member -MemberType "NoteProperty" -Name "Copyright" -Value $(if ($VersionInfo.LegalCopyright) { $VersionInfo.LegalCopyright.trim() } else { "Unknown" })
                    $Result
                }
            }
            else {
                Write-Warning "Failed to open file: $($_.ImagePathResolved)"
            }
        }
    }

    end {
        Restore-Wow64FileSystemRedirection -OldValue $FsRedirectionValue
    }
}

function Invoke-VulnerableDriverCheck {
    <#
    .SYNOPSIS
    Find vulnerable drivers.

    Author: @itm4n
    License: BSD 3-Clause
    
    .DESCRIPTION
    This check relies on the list of known vulnerable drivers provided by loldrivers.io to find vulnerable drivers installed on the host. For each installed driver, it computes its hash and chech whether it is in the list of vulnerable drivers.
    
    .EXAMPLE
    PS C:\> Invoke-VulnerableDriverCheck

    Name        : RTCore64
    DisplayName : Micro-Star MSI Afterburner
    ImagePath   : \SystemRoot\System32\drivers\RTCore64.sys
    StartMode   : Automatic
    Type        : KernelDriver
    Status      : Running
    Hash        : 01aa278b07b58dc46c84bd0b1b5c8e9ee4e62ea0bf7a695862444af32e87f1fd
    Url         : https://www.loldrivers.io/drivers/e32bc3da-4db1-4858-a62c-6fbe4db6afbd
    
    .NOTES
    When building the scripting, the driver list is downloaded from loldrivers.io, filtered, and exported again as a CSV file embedded in the script as a global variable.
    #>#

    [CmdletBinding()] Param(
        [UInt32] $BaseSeverity
    )

    $ArrayOfResults = @()

    Get-DriverList | Find-VulnerableDriver | ForEach-Object {

        $ServiceObject = Get-Service -Name $_.Name -ErrorAction SilentlyContinue
        if ($null -eq $ServiceObject) { Write-Warning "Failed to query service $($_.Name)" }

        $ServiceObjectResult = $_ | Select-Object Name,DisplayName,ImagePath,StartMode,Type
        $ServiceObjectResult | Add-Member -MemberType "NoteProperty" -Name "Status" -Value $(if ($ServiceObject) { $ServiceObject.Status} else { "Unknown" })
        $ServiceObjectResult | Add-Member -MemberType "NoteProperty" -Name "Hash" -Value $_.FileHash
        $ServiceObjectResult | Add-Member -MemberType "NoteProperty" -Name "Url" -Value $_.Url
        $ArrayOfResults += $ServiceObjectResult
    }

    $Result = New-Object -TypeName PSObject
    $Result | Add-Member -MemberType "NoteProperty" -Name "Result" -Value $ArrayOfResults
    $Result | Add-Member -MemberType "NoteProperty" -Name "Severity" -Value $(if ($ArrayOfResults) { $BaseSeverity } else { $SeverityLevelEnum::None })
    $Result
}