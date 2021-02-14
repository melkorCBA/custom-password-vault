param (
        $storeKey
    )

$documentPath = [Environment]::GetFolderPath("MyDocuments")
$vault = $documentPath + "\vault\"
$fliePath = $vault + "pwd" + $storeKey + ".txt"
$pass = Read-Host 'password?' -AsSecureString

$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

# Create vault if does not exist
if (!([System.IO.Directory]::Exists($vault))){
[system.io.directory]::CreateDirectory($vault)
}

    
# Create file if does not exist
if (!(Test-Path $fliePath)){
    New-Item -path $fliePath
}

convertto-securestring -string $password -asplaintext -force | convertfrom-securestring | out-file $fliePath