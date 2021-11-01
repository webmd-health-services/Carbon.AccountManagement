
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

Describe 'ResolveIdentity.when passed a built in identity' {
    It 'should resolve the built in identity' {
        $identity = Resolve-CIdentity -Name 'Administrators'
        $identity.FullName | Should -eq 'BUILTIN\Administrators'
        $identity.Domain | Should -eq 'BUILTIN'
        $identity.Name | Should -eq 'Administrators'
        $identity.Type | Should -eq 'Alias'
        $identity.Sid | Should -Not -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in an authority identity' {
    It 'should resolve the authority identity' {
        $identity = Resolve-CIdentity -Name 'NetworkService'
        $identity.FullName | Should -eq 'NT AUTHORITY\NETWORK SERVICE'
        $identity.Domain | Should -eq 'NT AUTHORITY'
        $identity.Name | Should -eq 'NETWORK SERVICE'
        $identity.Type | Should -eq 'WellKnownGroup'
        $identity.Sid | SHould -Not -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in Everyone.' {
    It 'should resolve everone' {
        $identity = Resolve-CIdentity -Name 'Everyone'
        $identity.FullName | Should -eq 'Everyone'
        $identity.Domain | Should -eq ''
        $identity.Name | Should -eq 'Everyone'
        $identity.Type | SHould -eq 'WellKnownGroup'
        $identity.Sid | Should -Not -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in a made up name' {
    It 'should not resolve the made up name' {
        $Error.Clear()
        $fullname = Resolve-CIdentity -Name 'IDONotExist' -ErrorAction SilentlyContinue
        $Error.Count | Should -gt 0
        $Error[0].Exception.Message -like '*not found*'
        $fullName | Should -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in local system' {
    It 'should resolve the local system' {
        $identity = Resolve-CIdentity -Name 'localsystem'
        $identity.FullName | Should -eq 'NT AUTHORITY\SYSTEM'
        $identity.Domain | Should -eq 'NT AUTHORITY'
        $identity.Name | Should -eq 'SYSTEM'
        $identity.Type | SHould -eq 'WellKnownGroup'
        $identity.Sid | Should -Not -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in dot accounts' {
    It 'should resolve the dot accounts' {
        foreach( $user in (Get-CUser) )
        {
            $Error.Clear()
            $identity = Resolve-CIdentity -Name ('.\{0}' -f $user.SamAccountName)
            $Error.Count | Should -eq 0
            $identity | Should -Not -BeNullOrEmpty
            $identity.Name | Should -eq $user.SamAccountName
            $identity.Domain | Should -eq $user.ConnectedServer
        }
    }
}

Describe 'ResolveIdentity.when passed in identities to resolve Sid of' {
    It 'should resolve each identity Sid.' {
        @( 'NT AUTHORITY\SYSTEM', 'Everyone', 'BUILTIN\Administrators' ) |
        ForEach-Object {
            $identity = Resolve-CIdentity -Name $_
            $identityFromSid = Resolve-CIdentity -Sid $identity.Sid
            $identity | Should -eq $identityFromSid
        }
    }
}

Describe 'ResolveIdentity.when passed in an unknown Sid' {
    It 'should not resolve the unknown identity Sid' {
        $Error.Clear()
        $identity = Resolve-CIdentity -SID 'S-1-5-21-2678556459-1010642102-471947008-1017' -ErrorAction SilentlyContinue
        $Error.Count | Should -gt 0
        $Error[0].Exception.Message -like '*not found*'
        $identity | Should -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in Sid by byte array' {
    It 'should resolve the Sid' {
        $Error.Clear()
        $identity = Resolve-CIdentity -Name 'Administrators'
        $identity | Should -Not -BeNullOrEmpty
        $sidBytes = New-Object 'byte[]' $identity.Sid.BinaryLength
        $identity.Sid.GetBinaryForm( $sidBytes, 0 )

        $identityBySid = Resolve-CIdentity -SID $sidBytes
        $identityBySid | Should -Not -BeNullOrEmpty
        $identityBySid | Should -eq $identity
        $Error.Count | Should -eq 0
    }
}

Describe 'ResolveIdentity.when passed in invalid Sddl' {
    It 'should not resolve the invalid Sddl' {
        $Error.Clear()
        $identity = Resolve-CIdentity -SID 'iamnotasid' -ErrorAction SilentlyContinue
        $Error.Count | Should -eq 2
        $Error[0].Exception.Message -like '*exception converting*'
        $identity | Should -BeNullOrEmpty
    }
}

Describe 'ResolveIdentity.when passed in an invalid binary Sid' {
    It 'should not resolve the invalid binary sid' {
        $Error.Clear()
        $identity = Resolve-CIdentity -SID (New-Object 'byte[]' 28) -ErrorACtion SilentlyContinue
        $Error.Count | Should -eq 2
        $Error[0].Exception.Message -like '*exception converting*'
        $identity | Should -BeNullOrEmpty
    }
}