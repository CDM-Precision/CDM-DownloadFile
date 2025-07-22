---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Invoke-FileDownload

## SYNOPSIS
Downloads a file from a specified URL to a local path with optional validation.

## SYNTAX

```
Invoke-FileDownload [-URL] <String> [-OutFile] <String> [-Validate] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Invoke-FileDownload function downloads a file from a specified URL to a local path. 
It supports BITS transfer for efficient downloads and includes optional file validation.
The function can resume partial downloads if the file is valid and provides detailed logging.

## EXAMPLES

### EXAMPLE 1
```
Invoke-FileDownload -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip"
```

Downloads file.zip from the specified URL and saves it to C:\Downloads\file.zip.

### EXAMPLE 2
```
Invoke-FileDownload -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip" -Validate
```

Downloads file.zip with validation enabled.
If a partial file exists, it will be validated before resuming.

## PARAMETERS

### -OutFile
Specifies the local path where the downloaded file will be saved.
This parameter is mandatory.

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

### -URL
Specifies the URL of the file to download.
This parameter is mandatory.

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

### -Validate
When specified, the function will validate the downloaded file's integrity.
If a partial file exists, it will be validated before resuming the download.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Invoke-FileDownload.
## OUTPUTS

### System.Boolean. Returns $true if the download was successful, $false otherwise.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Prerequisite : PowerShell 5.1 or later

## RELATED LINKS
