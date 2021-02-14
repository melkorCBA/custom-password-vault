param (
        $pwdSearchKey
    )

Clear-Host

#authenticate local user 
$cred = Get-Credential #Read credentials
 $username = $cred.username
 $password = $cred.GetNetworkCredential().password

$computer = $env:COMPUTERNAME

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$obj = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('machine',
$computer)
$isAuthenticated =  $obj.ValidateCredentials($username, $password) 

if($isAuthenticated){
    write-host "Successfully authenticated"

    $documentPath = [Environment]::GetFolderPath("MyDocuments")
    $vault = $documentPath + "\vault\"
    $files = get-childitem $vault |  where { $_.name -match "^pwd[a-zA-Z0-9]*.txt"} |  select -ExpandProperty name


    $regex = '^pwd(' +$pwdSearchKey + ')*.txt'
    ForEach($file in $files){
        if($file -match $regex){
            $pwdFile = $file
        }
        
    }

    
    if(-not ([string]::IsNullOrEmpty($pwdFile))){
        $pwdFilePath = $vault + $pwdFile
        $securestring = convertto-securestring -string (get-content $pwdFilePath)
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securestring)
        $passwsord = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        Clear-Host
        write-host $passwsord 
    }
    else {
        write-host "no such key in the vault" 
    }
}
else{
    write-host "Authentication failed - please verify your username and password."
    exit #terminate the script.
}



