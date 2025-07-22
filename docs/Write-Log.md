---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Write-Log

## SYNOPSIS
Writes log messages to the host, a file, or both with optional severity levels and source tags.

## SYNTAX

```
Write-Log [-Message] <String> [-Severity <Int32>] [-Source <String>] [-LogOutput <String>]
 [-LogFilePath <String>] [<CommonParameters>]
```

## DESCRIPTION
The Write-Log function logs messages to either the PowerShell host, a file, or both, depending on the selected output mode.
It allows specifying a severity level and a source to categorize messages.
Each log entry includes a timestamp, source, message content, and severity code.

## EXAMPLES

### EXAMPLE 1
```
Write-Log -Message "Script started"
```

Logs an informational message to the host with default settings.

### EXAMPLE 2
```
Write-Log -Message "User not found" -Severity 2 -Source "Authentication" -LogOutput "Full"
```

Logs a warning message from the "Authentication" source both to the host and to the log file.

### EXAMPLE 3
```
Write-Log -Message "Unhandled exception" -Severity 3 -LogOutput "File" -LogFilePath "C:\Logs\app.log"
```

Logs an error message to the specified log file without writing to the host.

## PARAMETERS

### -LogFilePath
Specifies the file path to which log entries will be written when using "File" or "Full" output modes.
Defaults to "$PSScriptRoot\logfile.log".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: "$PSScriptRoot\logfile.log"
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogOutput
Determines where the log message is output.
Acceptable values:
- "Host"  : Output only to the PowerShell host.
- "File"  : Output only to the log file.
- "Full"  : Output to both the host and the log file.
Defaults to "Host".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Host
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The log message to be recorded.
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

### -Severity
An integer representing the severity level of the message:
1 = Info (Blue)
2 = Warning (Yellow)
3 = Error (Red)
Defaults to 1 (Info) if not specified.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
A string representing the source or component of the message.
If not provided, defaults to "General".

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Peter Rinnenbach
Created: 2025-07-22
This function supports structured logging using a custom delimiter (\`0) for easier parsing.

## RELATED LINKS
