---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Test-FileIntegrity

## SYNOPSIS
Validates the integrity of a downloaded file by checking its size and hash against expected values.

## SYNTAX

```
Test-FileIntegrity [-fileSize] <Int64> [-downloadedFilePath] <String> [-ChecksumType <String>]
 [-Checksum <String>] [<CommonParameters>]
```

## DESCRIPTION
This function performs a two-step verification of a downloaded file:
1.
Compares the actual file size against the expected size
2.
If size matches, verifies the file hash against the expected hash
If either check fails, the downloaded file is automatically removed.

## EXAMPLES

### EXAMPLE 1
```
Test-FileIntegrity -fileSize 1048576 -downloadedFilePath "C:\Downloads\package.zip"
```

Verifies if package.zip is exactly 1MB in size and has the correct hash.

### EXAMPLE 2
```
$expectedSize = 5242880 # 5MB
```

PS C:\\\> $downloadedFile = "C:\Temp\setup.exe"
PS C:\\\> Test-FileIntegrity $expectedSize $downloadedFile
Shows positional parameter usage to verify setup.exe is 5MB with correct hash.

## PARAMETERS

### -Checksum
{{ Fill Checksum Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -downloadedFilePath
The path to the downloaded file that needs verification.
Can be relative or absolute path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -fileSize
The expected file size in bytes that the downloaded file should match.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int64
### You can pipe the expected file size to the fileSize parameter.
### System.String
### You can pipe the file path to the downloadedFilePath parameter.
## OUTPUTS

### System.Boolean
### Returns $true if both size and hash verification pass, otherwise throws an exception.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Requirements:
- Requires Test-FileHashIntegrity function for hash verification
- Requires Remove-DownloadedFile function for cleanup
- Requires Write-Log function for logging

## RELATED LINKS

[Test-FileHashIntegrity]()

[Get-FileHash]()

[about_Hash_Tables]()

