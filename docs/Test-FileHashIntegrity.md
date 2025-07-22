---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Test-FileHashIntegrity

## SYNOPSIS
Verifies the integrity of a file by comparing its cryptographic hash with an expected value.

## SYNTAX

```
Test-FileHashIntegrity [-Checksum] <String> [-ChecksumType] <String> [-downloadedFilePath] <String>
 [<CommonParameters>]
```

## DESCRIPTION
This function calculates the cryptographic hash of a specified file using the specified algorithm
and compares it with a provided expected hash value.
It's commonly used to verify file integrity
and authenticity after downloads or transfers.

## EXAMPLES

### EXAMPLE 1
```
Test-FileHashIntegrity -origHash "A94A8FE5CC..." -Type SHA256 -downloadedFilePath "C:\Downloads\package.zip"
```

Verifies if package.zip has the expected SHA256 hash value.

### EXAMPLE 2
```
$expectedHash = "B94A8FE5CC..."
```

PS C:\\\> $filePath = "setup.exe"
PS C:\\\> Test-FileHashIntegrity $expectedHash SHA1 $filePath
Shows positional parameter usage to verify setup.exe against an expected SHA1 hash.

### EXAMPLE 3
```
Get-ChildItem *.iso | ForEach-Object {
```

\>\>     Test-FileHashIntegrity -origHash $_.Hash -Type SHA512 -downloadedFilePath $_.FullName
\>\> }
Demonstrates verifying multiple files with their stored hash values.

## PARAMETERS

### -Checksum
{{ Fill Checksum Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChecksumType
{{ Fill ChecksumType Description }}

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

### -downloadedFilePath
The path to the file whose integrity needs to be verified.
Can be relative or absolute path.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName, Path

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### You can pipe file paths to the downloadedFilePath parameter.
## OUTPUTS

### System.Boolean
### Returns $true if the calculated hash matches the expected hash, $false otherwise.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Requirements:
- PowerShell 4.0 or later (for Get-FileHash cmdlet)
- Read access to the target file

Security Considerations:
- MD5 and SHA1 are considered weak and should be avoided when possible
- Always obtain hash values from trusted sources
- Prefer SHA256 or stronger algorithms for security-sensitive applications

## RELATED LINKS

[Get-FileHash]()

[about_Hashing]()

[https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash)

