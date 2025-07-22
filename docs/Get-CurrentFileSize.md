---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Get-CurrentFileSize

## SYNOPSIS
Retrieves the size of a specified file in bytes.

## SYNTAX

```
Get-CurrentFileSize [-FilePath] <String> [<CommonParameters>]
```

## DESCRIPTION
This function checks if a file exists at the given path and returns its size in bytes.
If the file doesn't exist, it returns 0.
The function is useful for file monitoring,
logging, or conditional operations based on file size.

## EXAMPLES

### EXAMPLE 1
```
Get-CurrentFileSize -FilePath "C:\Temp\example.txt"
```

Returns the size of example.txt in bytes.

### EXAMPLE 2
```
"C:\Temp\file1.txt", "C:\Temp\file2.txt" | Get-CurrentFileSize
```

Returns sizes for multiple files piped to the function.

### EXAMPLE 3
```
if ((Get-CurrentFileSize -FilePath "report.pdf") -gt 1MB) { "File is large" }
```

Demonstrates using the function in a conditional statement with size comparison.

## PARAMETERS

### -FilePath
The full path to the file whose size you want to check.
This can be a relative or absolute path.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### You can pipe file path strings to this function.
## OUTPUTS

### System.Int64
### Returns the file size in bytes as a 64-bit integer. Returns 0 if file doesn't exist.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Requirements:
- Requires PowerShell 3.0 or later
- Requires read access to the target file

## RELATED LINKS

[Get-Item]()

[Test-Path]()

