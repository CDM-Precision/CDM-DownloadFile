---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Start-FileDownloadWithRetry

## SYNOPSIS
Downloads a file from a URL with automatic retry logic on failure.

## SYNTAX

```
Start-FileDownloadWithRetry [-URL] <String> [-OutFile] <String> [[-RetryCount] <Int32>] [-Validate]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Start-FileDownloadWithRetry function attempts to download a file from a specified URL with multiple retries on failure.
It wraps the Invoke-FileDownload function and adds retry logic with configurable attempts and delay between retries.
The function provides detailed logging of each attempt and supports file validation.

## EXAMPLES

### EXAMPLE 1
```
Start-FileDownloadWithRetry -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip"
```

Downloads file.zip with default retry settings (3 attempts).

### EXAMPLE 2
```
Start-FileDownloadWithRetry -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip" -RetryCount 5 -Validate
```

Downloads file.zip with validation enabled and up to 5 retry attempts.

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

### -RetryCount
Specifies the maximum number of download attempts.
Default is 3.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 3
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
If validation fails, the download will be retried (if attempts remain).

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

### None. You cannot pipe objects to Start-FileDownloadWithRetry.
## OUTPUTS

### None. The function doesn't return any output but throws an exception if all attempts fail.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Prerequisite: PowerShell 5.1 or later
                Invoke-FileDownload function must be available

## RELATED LINKS

[about_Invoke-FileDownload]()

