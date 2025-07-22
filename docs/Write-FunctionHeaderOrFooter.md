---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version:
schema: 2.0.0
---

# Write-FunctionHeaderOrFooter

## SYNOPSIS
Logs the start or end of a function execution for better traceability during script execution.

## SYNTAX

```
Write-FunctionHeaderOrFooter [-CmdletName] <String> [[-CmdletBoundParameters] <Hashtable>] [-Header] [-Footer]
 [<CommonParameters>]
```

## DESCRIPTION
The Write-FunctionHeaderOrFooter function helps with structured logging by writing standardized "START" and "END" log entries for a given cmdlet or function.
It optionally logs the parameters passed to the function for debugging and auditing purposes.
This is especially useful for tracking the flow of complex scripts or modules.

## EXAMPLES

### EXAMPLE 1
```
Write-FunctionHeaderOrFooter -CmdletName "Get-User" -Header -CmdletBoundParameters $PSBoundParameters
```

Logs a start message for the "Get-User" function, along with its input parameters.

### EXAMPLE 2
```
Write-FunctionHeaderOrFooter -CmdletName "Get-User" -Footer
```

Logs an end message for the "Get-User" function.

### EXAMPLE 3
```
Write-FunctionHeaderOrFooter -CmdletName "Install-Software" -Header
```

Logs a start message for the "Install-Software" function without listing parameters.

## PARAMETERS

### -CmdletBoundParameters
An optional hashtable of the parameters that were passed to the cmdlet or function.
If provided and Header is specified, the parameters and their values will be logged.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CmdletName
The name of the cmdlet or function being logged.
This is a required parameter and is used as the source tag in the log entries.

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

### -Footer
Switch indicating that the function should log the end of execution.
If set, an "END" message is logged.

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

### -Header
Switch indicating that the function should log the start of execution.
If set, a "START" message is logged, along with any provided parameters.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Peter Rinnenbach
Created: 2025-07-22  
Intended for use with the Write-Log function for consistent structured logging across scripts.

## RELATED LINKS
