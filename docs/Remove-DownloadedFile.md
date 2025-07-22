---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Remove-DownloadedFile

## SYNOPSIS
Safely removes downloaded files with logging and error handling.

## SYNTAX

```
Remove-DownloadedFile [-downloadedFilePath] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function provides a secure way to remove downloaded files with comprehensive logging.
It checks for file existence before attempting deletion and handles various file system objects
including files, directories, and read-only items.

## EXAMPLES

### EXAMPLE 1
```
Remove-DownloadedFile -downloadedFilePath "C:\Downloads\tempfile.zip"
```

Removes the specified file and logs the operation.

### EXAMPLE 2
```
Get-ChildItem "C:\Temp\*.tmp" | Remove-DownloadedFile
```

Removes all .tmp files in C:\Temp directory through pipeline input.

### EXAMPLE 3
```
Remove-DownloadedFile "C:\PartialDownloads\*" -ErrorAction Continue
```

Attempts to remove all files in the PartialDownloads directory, continuing on errors.

## PARAMETERS

### -downloadedFilePath
The path to the file or directory to be removed.
Can be absolute or relative path.
Accepts pipeline input and wildcards in paths.

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

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### You can pipe file or directory paths to this function.
## OUTPUTS

### None
### This function does not return any output.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Requirements:
- PowerShell 3.0 or later
- Write access to the target file/directory

Security Considerations:
- Uses -Force to remove read-only and hidden items
- Uses -Recurse to remove directories and their contents
- Consider implementing a recycle bin option for critical files

## RELATED LINKS

[Remove-Item]()

[Test-Path]()

[about_FileSystem_Provider]()

