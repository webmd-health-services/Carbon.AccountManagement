# Overview

The "Carbon.AccountManagement" module contains functions for managing and resolving user and group accounts.

# System Requirements

* Windows PowerShell 5.1 and .NET 4.6.1+
* PowerShell Core 6+

# Installing

To install globally:

```powershell
Install-Module -Name 'Carbon.AccountManagement'
Import-Module -Name 'Carbon.AccountManagement'
```

To install privately:

```powershell
Save-Module -Name 'Carbon.AccountManagement' -Path '.'
Import-Module -Name '.\Carbon.AccountManagement'
```

# Commands

* `Resolve-Identity`: Determines the full, NT identity name for a user or group.
* `Resolve-IdentityName`: Resolves a user/group name into its full, canonical name, used by the operating system.
* `ConvertTo-SecurityIdentifier`: Converts a string or byte array security identifier into a 
System.Security.Principal.SecurityIdentifier Object.
* `Test-Identity`: Tests that a name is valid Windows local or domain user/group.