---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
--- 

# Test-PartialFileHash

## SYNOPSIS
Verifies a file's partial hash against an expected value using a specified algorithm.

## SYNTAX

```
Test-PartialFileHash [-FilePath] <String> [-ExpectedHash] <String> [-HashType] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function checks whether a file's cryptographic hash matches an expected value.
It's particularly useful for verifying partial downloads or checking file integrity
during transfer operations.
The function supports multiple hash algorithms.

## EXAMPLES

### EXAMPLE 1
```
Test-PartialFileHash -FilePath "C:\Temp\partial.zip" -ExpectedHash "A94A8FE5CC..." -HashType SHA256
Verifies if partial.zip matches the expected SHA256 hash.
```

### EXAMPLE 2
```
$files = Get-ChildItem "C:\Downloads\*.part"
PS C:\> $files | Test-PartialFileHash -ExpectedHash "B94A8FE5CC..." -HashType SHA1
Verifies multiple partial download files against an expected SHA1 hash.
```

### EXAMPLE 3
```
if (Test-PartialFileHash "setup.exe" "C45D..." "MD5") {
>>     Write-Output "File verification successful"
>> } else {
>>     Write-Output "Verification failed"
>> }
Demonstrates conditional usage with positional parameters.
```

## PARAMETERS

### -ExpectedHash
The expected hash value to compare against.
Must be provided in hexadecimal format.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
The full path to the file to be verified.
Can be absolute or relative.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName, Path

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -HashType
The cryptographic hash algorithm to use for verification.
Supported algorithms: SHA1, SHA256, SHA384, SHA512, MD5

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{Fill ProgressAction Description}}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### You can pipe file paths to the FilePath parameter.
## OUTPUTS

### System.Boolean
### Returns $true if the hash matches, $false if it doesn't or if the file doesn't exist.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Requirements:
- PowerShell 4.0 or later (for Get-FileHash cmdlet)
- Read access to the target file

Security Considerations:
- Case-insensitive comparison is used for hash values
- MD5 and SHA1 are cryptographically weak - prefer SHA256 or stronger
- Always obtain expected hashes from trusted sources

## RELATED LINKS

[Get-FileHash]()

[Test-FileHashIntegrity]()

[about_File_Hashing]()

