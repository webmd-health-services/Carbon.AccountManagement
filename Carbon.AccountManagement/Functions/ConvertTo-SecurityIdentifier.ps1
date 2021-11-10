
function ConvertTo-SecurityIdentifier
{
    <#
    .SYNOPSIS
    Converts a string or byte array security identifier into a `System.Security.Principal.SecurityIdentifier` object.

    .DESCRIPTION
    `ConvertTo-CSecurityIdentifier` converts a SID in SDDL form (as a string), in binary form (as a byte array) into a
    System.Security.Principal.SecurityIdentifier` object. It also accepts `System.Security.Principal.SecurityIdentifier`
    objects, and returns them back to you.

    If the string or byte array don't represent a SID, an error is written and nothing is returned.

    .LINK
    Resolve-CIdentity

    .LINK
    Resolve-CIdentityName

    .EXAMPLE
    Resolve-CIdentity -SID 'S-1-5-21-2678556459-1010642102-471947008-1017'

    Demonstrates how to convert a a SID in SDDL into a `System.Security.Principal.SecurityIdentifier` object.

    .EXAMPLE
    Resolve-CIdentity -SID (New-Object 'Security.Principal.SecurityIdentifier' 
    'S-1-5-21-2678556459-1010642102-471947008-1017')

    Demonstrates that you can pass a `SecurityIdentifier` object as the value of the SID parameter. The SID you passed
    in will be returned to you unchanged.

    .EXAMPLE
    Resolve-CIdentity -SID $sidBytes

    Demonstrates that you can use a byte array that represents a SID as the value of the `SID` parameter.
    #>
    [CmdletBinding()]
    param(
        # The SID to convert to a `System.Security.Principal.SecurityIdentifier`. Accepts a SID in SDDL form as a
        # `string`, a `System.Security.Principal.SecurityIdentifier` object, or a SID in binary form as an array of
        # bytes.
        [Parameter(Mandatory)]
        [Object] $SID
    )

    Use-CallerPreference -Cmdlet $PSCmdlet -Session $ExecutionContext.SessionState
    
    try
    {
        if( $SID -is [string] )
        {
            return [Security.Principal.SecurityIdentifier]::New($SID)
        }
        elseif( $SID -is [byte[]] )
        {
            return [Security.Principal.SecurityIdentifier]::New($SID, 0)
        }
        elseif( $SID -is [Security.Principal.SecurityIdentifier] )
        {
            return $SID
        }
        else
        {
            $msg = "Invalid SID of type ""[$($SID.GetType().FullName)]"". The ""SID"" parameter must be a " +
                   "[System.Security.Principal.SecurityIdentifier] object, a SID in SDDL form as a string, or " +
                   "a SID in binary form as byte array."
            Write-Error $msg -ErrorAction $ErrorActionPreference
        }
    }
    catch
    {
        $msg = "Exception converting [$($SID.GetType().FullName)] SID parameter to a " +
               "[System.Security.Principal.SecurityIdentifier] object: $($_)"
        Write-Error $msg -ErrorAction $ErrorActionPreference
    }
}
