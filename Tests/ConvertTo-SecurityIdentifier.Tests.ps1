
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

Describe 'ConvertTo-SecurityIdentifier.when passed in the current user SID as a string.' {
    It 'should convert the current user SID to a SecurityIdentifier object.'{
        $stringSID = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
        $convertSID = ConvertTo-CSecurityIdentifier -SID $stringSID
        $convertSID | Should -Not -BeNullOrEmpty
        $convertSID | Should -eq $stringSID
        $convertSID | Should -BeOfType [System.Security.Principal.SecurityIdentifier]
    } 
}

Describe 'ConvertTo-SecurityIdentifier.when passed in the current user SID as a byte array.' {
    It 'should convert the current user SID to a SecurityIdentifier object.' {
        $SID = ConvertTo-CSecurityIdentifier -SID ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
        $byteSID = New-Object 'byte[]' $SID.BinaryLength
        $SID.GetBinaryForm( $byteSID, 0 )

        $convertSID = ConvertTo-CSecurityIdentifier -SID $SID
        $convertSID | Should -Not -BeNullOrEmpty
        $convertSID | Should -eq $SID
        $convertSID | Should -BeOfType [System.Security.Principal.SecurityIdentifier]
    }
}

Describe 'ConvertTo-SecurityIdentifier.when passed in the current user SID as a Security Identifier object.' {
    It 'should convert the current user SID to a SecurityIdentifier object.' {
        $SISID = ConvertTo-CSecurityIdentifier -SID ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
        $convertSID = ConvertTo-CSecurityIdentifier -SID $SISID
        $convertSID | Should -Not -BeNullOrEmpty
        $convertSID | Should -eq $SISID
        $convertSID | Should -BeOfType [System.Security.Principal.SecurityIdentifier]
    }
}

Describe 'ConvertTo-SecurityIdentifier.when passing in an invalid SID as a string' {
    It 'should not convert the passed in SID. '{
        $thrownError = $false
        $invalidSID = '100000000000'
        { 
            try 
            {
                ConvertTo-CSecurityIdentifier -SID $invalidSID -ErrorAction Stop
            }
            catch
            {
                $thrownError = $true
            }
            $thrownError | Should -Be $true
        }
    }
}

Describe 'ConvertTo-SecurityIdentifier.when passed an invalid data type' {
    It 'should not convert the passed in SID. '{
        $thrownError = $false
        $invalidSID = 1000
        { 
            try 
            {
                ConvertTo-CSecurityIdentifier -SID $invalidSID -ErrorAction Stop
            }
            catch
            {
                $thrownError = $true
            }
            $thrownError | Should -Be $true
        }
    }
}