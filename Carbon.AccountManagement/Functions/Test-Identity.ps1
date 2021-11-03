
function Test-Identity
{
    <#
    .SYNOPSIS
    Tests that a name is a valid Windows local or domain user/group.
    
    .DESCRIPTION
    Uses the Windows `LookupAccountName` function to find an identity.  If it can't be found, returns `$false`.  Otherwise, it returns `$true`.
    
    Use the `PassThru` switch to return a `Carbon.Identity` object (instead of `$true` if the identity exists.

    .LINK
    Resolve-CIdentity

    .LINK
    Resolve-CIdentityName

    .EXAMPLE
    Test-CIdentity -Name 'Administrators
    
    Tests that a user or group called `Administrators` exists on the local computer.
    
    .EXAMPLE
    Test-CIdentity -Name 'CARBON\Testers'
    
    Tests that a group called `Testers` exists in the `CARBON` domain.
    
    .EXAMPLE
    Test-CIdentity -Name 'Tester' -PassThru
    
    Tests that a user or group named `Tester` exists and returns a `System.Security.Principal.SecurityIdentifier` object if it does.
    #>
    [CmdletBinding()]
    param(
        # The name of the identity to test.
        [Parameter(Mandatory)]
        [String]$Name,
        
        # Returns a `Carbon.Identity` object if the identity exists.
        [Switch]$PassThru
    )

    Set-StrictMode -Version 'Latest'

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState
    
    $identity = [Carbon.Identity]::FindByName( $Name )
    if( -not $identity )
    {
        return $false
    }

    if( $PassThru )
    {
        return $identity
    }
    return $true
}

