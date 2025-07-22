---
external help file: DownloadFile-help.xml
Module Name: DownloadFile
online version: https://learn.microsoft.com/en-us/dotnet/api/system.net.webrequest
schema: 2.0.0
--- 

# Get-FinalRedirectUrl

## SYNOPSIS
Resolves the final URL after following all HTTP redirects.

## SYNTAX

```
Get-FinalRedirectUrl [-Url] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function takes a URL and follows any HTTP redirects (301, 302, etc.) to determine the final destination URL.
It's useful for checking where shortened URLs or redirected links ultimately lead.

## EXAMPLES

### EXAMPLE 1
```
Get-FinalRedirectUrl -Url "https://bit.ly/example"
Returns the final destination URL after following all redirects from the bit.ly shortened URL.
```

### EXAMPLE 2
```
"https://tinyurl.com/sample", "http://goo.gl/example" | Get-FinalRedirectUrl
Processes multiple URLs from the pipeline and returns their final destination URLs.
```

## PARAMETERS

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

### -Url
The initial URL to check for redirects.
This can be a standard URL or a shortened URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### You can pipe string values representing URLs to this function.
## OUTPUTS

### System.String
### Returns the final URL as a string after following all redirects.
## NOTES
Author: Peter Rinnenbach
Version: 1.1
Date: 02/08/2025
Requirements:
- Internet access to follow the URLs
- .NET Framework for WebRequest functionality

## RELATED LINKS

[https://learn.microsoft.com/en-us/dotnet/api/system.net.webrequest](https://learn.microsoft.com/en-us/dotnet/api/system.net.webrequest)

[about_Redirection]()

