
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'


& (Join-Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

Describe 'ResolveIdentityName.when passed in a built in identity' {
    It 'should resolve the built in identity' {
        $identity = Resolve-IdentityName -Name 'Administrators'
        $identity | Should -eq 'BUILTIN\Administrators'
    }
}

Describe 'ResolveIdentityName.when passed in an NT Authority identity' {
    It 'should resolve the NT Authority identity' {
        $identity = Resolve-IdentityName -Name 'NetworkService'
        $identity | Should -eq 'NT AUTHORITY\NETWORK SERVICE'
    }
}

Describe 'ResolveIdentityName.when passed in everyone' {
    It 'should resolve everyone' {
        $identity  = Resolve-IdentityName -Name 'Everyone'
        $identity | Should -eq 'Everyone'
    }
}

Describe 'ResolveIdentityName.when passed in a made up name' {
    It 'should not resolve the made up name' {
        $fullName = Resolve-IdentityName -Name 'IDONotExist'
        $fullName | Should -BeNullOrEmpty
    }
}

Describe 'ResolveIdentityName.when passed in local system' {
    It 'should resolve the local system' {
        $identity = Resolve-IdentityName -Name 'localsystem'
        $identity | Should -eq 'NT AUTHORITY\SYSTEM'
    }
}

Describe 'ResolveIdentityName.when passed in dot accounts' {
    It 'should resolve the dot accounts' {
        foreach( $user in (Get-CUser) )
        {
            $Error.Clear()
            $identity = Resolve-IdentityName -Name ('.\{0}' -f $user.SamAccountName)
            $Error.Count | Should -eq 0
            $identity | Should -eq ('{0}\{1}' -f $env:COMPUTERNAME, $user.SamAccountName)

        }
    }
}

Describe 'ResolveIdentityName.when passed in Sid' {
    It 'Should resolve the Sid' {
        $identity = Resolve-Identity -Name 'Administrators'
        $identity | Should -Not -BeNullOrEmpty
        $identity = Resolve-IdentityName -Sid $identity.Sid.ToString()
        $identity | Should -eq 'BUILTIN\Administrators'
    }
}

Describe 'ResolveIdentityName.when passed in an unknown Sid' {
    It 'Should resolve the Sid' {
        $sid ='S-1-5-21-2678556459-1010642102-471947008-1017' 
        $identity = Resolve-IdentityName -SID $sid
        $identity | Should -eq $sid
    }
}


