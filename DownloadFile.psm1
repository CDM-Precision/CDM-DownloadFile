<#
.SYNOPSIS
Writes log messages to the host, a file, or both with optional severity levels and source tags.

.DESCRIPTION
The Write-Log function logs messages to either the PowerShell host, a file, or both, depending on the selected output mode.
It allows specifying a severity level and a source to categorize messages.
Each log entry includes a timestamp, source, message content, and severity code.

.PARAMETER Message
The log message to be recorded. This parameter is mandatory.

.PARAMETER Severity
An integer representing the severity level of the message:
1 = Info (Blue)
2 = Warning (Yellow)
3 = Error (Red)
Defaults to 1 (Info) if not specified.

.PARAMETER Source
A string representing the source or component of the message.
If not provided, defaults to "General".

.PARAMETER LogOutput
Determines where the log message is output.
Acceptable values:
- "Host"  : Output only to the PowerShell host.
- "File"  : Output only to the log file.
- "Full"  : Output to both the host and the log file.
Defaults to "Host".

.PARAMETER LogFilePath
Specifies the file path to which log entries will be written when using "File" or "Full" output modes.
Defaults to "$PSScriptRoot\logfile.log".

.EXAMPLE
Write-Log -Message "Script started"

Logs an informational message to the host with default settings.

.EXAMPLE
Write-Log -Message "User not found" -Severity 2 -Source "Authentication" -LogOutput "Full"

Logs a warning message from the "Authentication" source both to the host and to the log file.

.EXAMPLE
Write-Log -Message "Unhandled exception" -Severity 3 -LogOutput "File" -LogFilePath "C:\Logs\app.log"

Logs an error message to the specified log file without writing to the host.

.NOTES
Author: Peter Rinnenbach
Created: 2025-07-22
This function supports structured logging using a custom delimiter (`0) for easier parsing.

#>
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]$Message,

        [Parameter(Mandatory = $false)]
        [Int32]$Severity = 1,

        [Parameter(Mandatory = $false)]
        [String]$Source = "",

        [Parameter(Mandatory = $false)]
        [ValidateSet("Host", "File", "Full")]
        [string]$LogOutput = "Full",

        [Parameter(Mandatory = $false)]
        [string]$LogFilePath = "x:\windows\temp\smstslog\smsts.log"
    )

    
    $timestamp = Get-Date -Format "MM-dd-yyyy HH:mm:ss.fff"
    $component = if ($Source -ne "") { $Source } else { "General" }
    $logLine = "$timestamp`0$component`0$Message`0$Severity"

    switch ($Severity) {
        1 { $color = "Blue" }    # Info
        2 { $color = "Yellow" }  # Warning
        3 { $color = "Red" }     # Error
        default { $color = "White" }
    }

    switch ($Output) {
        "Host" {
            Write-Host -ForegroundColor $color "[$component] $Message"
        }
        "File" {
            Add-Content -Path $LogFilePath -Value $logLine
        }
        "Full" {
            Write-Host -ForegroundColor $color "[$component] $Message"
            Add-Content -Path $LogFilePath -Value $logLine
        }
    }
}



<#
.SYNOPSIS
Logs the start or end of a function execution for better traceability during script execution.

.DESCRIPTION
The Write-FunctionHeaderOrFooter function helps with structured logging by writing standardized "START" and "END" log entries for a given cmdlet or function.
It optionally logs the parameters passed to the function for debugging and auditing purposes.
This is especially useful for tracking the flow of complex scripts or modules.

.PARAMETER CmdletName
The name of the cmdlet or function being logged. This is a required parameter and is used as the source tag in the log entries.

.PARAMETER CmdletBoundParameters
An optional hashtable of the parameters that were passed to the cmdlet or function.
If provided and Header is specified, the parameters and their values will be logged.

.PARAMETER Header
Switch indicating that the function should log the start of execution.
If set, a "START" message is logged, along with any provided parameters.

.PARAMETER Footer
Switch indicating that the function should log the end of execution.
If set, an "END" message is logged.

.EXAMPLE
Write-FunctionHeaderOrFooter -CmdletName "Get-User" -Header -CmdletBoundParameters $PSBoundParameters

Logs a start message for the "Get-User" function, along with its input parameters.

.EXAMPLE
Write-FunctionHeaderOrFooter -CmdletName "Get-User" -Footer

Logs an end message for the "Get-User" function.

.EXAMPLE
Write-FunctionHeaderOrFooter -CmdletName "Install-Software" -Header

Logs a start message for the "Install-Software" function without listing parameters.

.NOTES
Author: Peter Rinnenbach
Created: 2025-07-22  
Intended for use with the Write-Log function for consistent structured logging across scripts.

#>
function Write-FunctionHeaderOrFooter {
    param(
        [Parameter(Mandatory = $true)]
        [String]$CmdletName,
        [Parameter(Mandatory = $false)]
        [hashtable]$CmdletBoundParameters,
        [Parameter(Mandatory = $false)]
        [Switch]$Header,
        [Parameter(Mandatory = $false)]
        [Switch]$Footer
    )
    if ($Header) {
        Write-Log -Message "`n===== START $CmdletName =====" -Source ${CmdletName} -Severity 1
        if ($CmdletBoundParameters) {
            Write-Log -Message "Parameters:" -Source ${CmdletName} -Severity 1
            $CmdletBoundParameters.GetEnumerator() | ForEach-Object {
                Write-Log -Message "  $($_.Key): $($_.Value)" -Source ${CmdletName} -Severity 1
            }
        }
    }
    if ($Footer) {
        Write-Log -Message "===== END $CmdletName =====" -Source ${CmdletName} -Severity 1
    }
}



<#
.SYNOPSIS
    Resolves the final URL after following all HTTP redirects.

.DESCRIPTION
    This function takes a URL and follows any HTTP redirects (301, 302, etc.) to determine the final destination URL.
    It's useful for checking where shortened URLs or redirected links ultimately lead.

.PARAMETER Url
    The initial URL to check for redirects. This can be a standard URL or a shortened URL.

.EXAMPLE
    PS C:\> Get-FinalRedirectUrl -Url "https://bit.ly/example"
    Returns the final destination URL after following all redirects from the bit.ly shortened URL.

.EXAMPLE
    PS C:\> "https://tinyurl.com/sample", "http://goo.gl/example" | Get-FinalRedirectUrl
    Processes multiple URLs from the pipeline and returns their final destination URLs.

.INPUTS
    System.String
    You can pipe string values representing URLs to this function.

.OUTPUTS
    System.String
    Returns the final URL as a string after following all redirects.

.NOTES
    Author: Peter Rinnenbach
    Version: 1.1
    Date: 02/08/2025
    Requirements:
    - Internet access to follow the URLs
    - .NET Framework for WebRequest functionality

.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.net.webrequest
.LINK
    about_Redirection
#>
function Get-FinalRedirectUrl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Url
    )

    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }

    Process {
        try {
            $req = [System.Net.WebRequest]::Create($Url)
            $req.Method = 'GET'
            $req.AllowAutoRedirect = $false
            
            $resp = $req.GetResponse()
            
            if ($resp.ResponseUri.OriginalString -eq $Url) {
                return $Url
            } else {
                Write-Log -Message "Redirected url: $($resp.ResponseUri.OriginalString)" -Severity 1 -Source ${CmdletName}
                return $resp.ResponseUri.OriginalString
            }
        }
        catch {
            Write-Log -Message "Error processing URL '$Url': $_" -Severity 3 -Source ${CmdletName}
            throw $_
        }
        finally {
            if ($resp) {
                $resp.Close()
                $resp.Dispose()
            }
        }
    }
}



<#
.SYNOPSIS
    Retrieves the size of a specified file in bytes.

.DESCRIPTION
    This function checks if a file exists at the given path and returns its size in bytes.
    If the file doesn't exist, it returns 0. The function is useful for file monitoring,
    logging, or conditional operations based on file size.

.PARAMETER FilePath
    The full path to the file whose size you want to check. This can be a relative or absolute path.

.EXAMPLE
    PS C:\> Get-CurrentFileSize -FilePath "C:\Temp\example.txt"
    Returns the size of example.txt in bytes.

.EXAMPLE
    PS C:\> "C:\Temp\file1.txt", "C:\Temp\file2.txt" | Get-CurrentFileSize
    Returns sizes for multiple files piped to the function.

.EXAMPLE
    PS C:\> if ((Get-CurrentFileSize -FilePath "report.pdf") -gt 1MB) { "File is large" }
    Demonstrates using the function in a conditional statement with size comparison.

.INPUTS
    System.String
    You can pipe file path strings to this function.

.OUTPUTS
    System.Int64
    Returns the file size in bytes as a 64-bit integer. Returns 0 if file doesn't exist.

.NOTES
    Author: Peter Rinnenbach
    Version: 1.1
    Date: 02/08/2025
    Requirements:
    - Requires PowerShell 3.0 or later
    - Requires read access to the target file

.LINK
    Get-Item
.LINK
    Test-Path
#>
function Get-CurrentFileSize {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$FilePath
    )
    Begin{
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process{
        if (Test-Path -Path $FilePath) {
        return (Get-Item -Path $FilePath).Length
        } else {
            return 0
        }
    }
    
}



<#
.SYNOPSIS
    Validates the integrity of a downloaded file by checking its size and hash against expected values.

.DESCRIPTION
    This function performs a two-step verification of a downloaded file:
    1. Compares the actual file size against the expected size
    2. If size matches, verifies the file hash against the expected hash
    If either check fails, the downloaded file is automatically removed.

.PARAMETER fileSize
    The expected file size in bytes that the downloaded file should match.

.PARAMETER downloadedFilePath
    The path to the downloaded file that needs verification.
    Can be relative or absolute path.

.EXAMPLE
    PS C:\> Test-FileIntegrity -fileSize 1048576 -downloadedFilePath "C:\Downloads\package.zip"
    Verifies if package.zip is exactly 1MB in size and has the correct hash.

.EXAMPLE
    PS C:\> $expectedSize = 5242880 # 5MB
    PS C:\> $downloadedFile = "C:\Temp\setup.exe"
    PS C:\> Test-FileIntegrity $expectedSize $downloadedFile
    Shows positional parameter usage to verify setup.exe is 5MB with correct hash.

.INPUTS
    System.Int64
    You can pipe the expected file size to the fileSize parameter.

    System.String
    You can pipe the file path to the downloadedFilePath parameter.

.OUTPUTS
    System.Boolean
    Returns $true if both size and hash verification pass, otherwise throws an exception.

.NOTES
    Author: Peter Rinnenbach
    Version: 1.1
    Date: 02/08/2025
    Requirements:
    - Requires Test-FileHashIntegrity function for hash verification
    - Requires Remove-DownloadedFile function for cleanup
    - Requires Write-Log function for logging

.LINK
    Test-FileHashIntegrity
.LINK
    Get-FileHash
.LINK
    about_Hash_Tables
#>
function Test-FileIntegrity {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateScript({$_ -ge 0})]
        [int64]$fileSize,
        
        [Parameter(Mandatory=$true, Position=1, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$downloadedFilePath,
		[Parameter(Mandatory = $false)]
		[string]$ChecksumType,

		[Parameter(Mandatory = $false)]
		[string]$Checksum
    )

    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }

    Process {
        try {
            Write-Log -Message "Starting file integrity check..." -Severity 1 -Source ${CmdletName}
            
            # Convert and validate path
            $cpath = Convert-Path $downloadedFilePath
            if (-not (Test-Path -Path $cpath -PathType Leaf)) {
                throw "File not found: $downloadedFilePath"
            }

            # Check file size
            $actualSize = (Get-Item -Path $cpath).Length
            Write-Log -Message "Expected size: $fileSize bytes, Actual size: $actualSize bytes" -Severity 1 -Source ${CmdletName}
            
            if ($fileSize -ne $actualSize) {
                Remove-DownloadedFile -downloadedFilePath $downloadedFilePath
                throw "File size mismatch. Expected: $fileSize bytes, Actual: $actualSize bytes"
            }

            Write-Log -Message "File size verification passed" -Severity 1 -Source ${CmdletName}

            # Check file hash if size matches
            Write-Log -Message "Starting hash verification..." -Severity 1 -Source ${CmdletName}
            $hashResult = Test-FileHashIntegrity -Checksum $Checksum -ChecksumType $ChecksumType -downloadedFilePath $downloadedFilePath
            
            if (-not $hashResult) {
                Remove-DownloadedFile -downloadedFilePath $downloadedFilePath
                throw "File hash verification failed"
            }

            Write-Log -Message "File integrity check completed successfully" -Severity 1 -Source ${CmdletName}
            return $true
        }
        catch {
            Write-Log -Message "File integrity check failed: $_" -Severity 3 -Source ${CmdletName}
            throw $_
        }
    }
}



<#
.SYNOPSIS
    Verifies the integrity of a file by comparing its cryptographic hash with an expected value.

.DESCRIPTION
    This function calculates the cryptographic hash of a specified file using the specified algorithm
    and compares it with a provided expected hash value. It's commonly used to verify file integrity
    and authenticity after downloads or transfers.

.PARAMETER origHash
    The expected hash value to compare against. This should be provided by a trusted source.

.PARAMETER Type
    The cryptographic hash algorithm to use for verification.
    Supported algorithms: SHA1, SHA256, SHA384, SHA512, MD5

.PARAMETER downloadedFilePath
    The path to the file whose integrity needs to be verified.
    Can be relative or absolute path.

.EXAMPLE
    PS C:\> Test-FileHashIntegrity -origHash "A94A8FE5CC..." -Type SHA256 -downloadedFilePath "C:\Downloads\package.zip"
    Verifies if package.zip has the expected SHA256 hash value.

.EXAMPLE
    PS C:\> $expectedHash = "B94A8FE5CC..."
    PS C:\> $filePath = "setup.exe"
    PS C:\> Test-FileHashIntegrity $expectedHash SHA1 $filePath
    Shows positional parameter usage to verify setup.exe against an expected SHA1 hash.

.EXAMPLE
    PS C:\> Get-ChildItem *.iso | ForEach-Object {
    >>     Test-FileHashIntegrity -origHash $_.Hash -Type SHA512 -downloadedFilePath $_.FullName
    >> }
    Demonstrates verifying multiple files with their stored hash values.

.INPUTS
    System.String
    You can pipe file paths to the downloadedFilePath parameter.

.OUTPUTS
    System.Boolean
    Returns $true if the calculated hash matches the expected hash, $false otherwise.

.NOTES
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

.LINK
    Get-FileHash
.LINK
    about_Hashing
.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-filehash
#>
function Test-FileHashIntegrity {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Checksum,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateSet("SHA1","SHA256", "SHA384", "SHA512", "MD5")]
        [String]$ChecksumType,

        [Parameter(Mandatory=$true, Position=2, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({
            if (-not (Test-Path -Path $_ -PathType Leaf)) {
                throw "File not found: $_"
            }
            $true
        })]
        [Alias("FullName","Path")]
        [String]$downloadedFilePath
    )

    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }

    Process {
        try {
            $cpath = Convert-Path $downloadedFilePath
            Write-Log -Message "Calculating $ChecksumType hash for file: $cpath" -Severity 1 -Source ${CmdletName}
            
            $localFileHash = (Get-FileHash -Algorithm $ChecksumType -Path $cpath -ErrorAction Stop).Hash
            Write-Log -Message "Calculated hash: $localFileHash" -Severity 1 -Source ${CmdletName}
            Write-Log -Message "Expected hash: $Checksum" -Severity 1 -Source ${CmdletName}

            $result = $Checksum.ToUpper() -eq $localFileHash.ToUpper()
            
            if ($result) {
                Write-Log -Message "Hash verification successful" -Severity 1 -Source ${CmdletName}
            } else {
                Write-Log -Message "Hash verification failed" -Severity 3 -Source ${CmdletName}
            }
            
            return $result
        }
        catch {
            Write-Log -Message "Error during hash verification: $_" -Severity 3 -Source ${CmdletName}
            throw $_
        }
    }
}



<#
.SYNOPSIS
    Verifies a file's partial hash against an expected value using a specified algorithm.

.DESCRIPTION
    This function checks whether a file's cryptographic hash matches an expected value.
    It's particularly useful for verifying partial downloads or checking file integrity
    during transfer operations. The function supports multiple hash algorithms.

.PARAMETER FilePath
    The full path to the file to be verified. Can be absolute or relative.

.PARAMETER ExpectedHash
    The expected hash value to compare against. Must be provided in hexadecimal format.

.PARAMETER HashType
    The cryptographic hash algorithm to use for verification.
    Supported algorithms: SHA1, SHA256, SHA384, SHA512, MD5

.EXAMPLE
    PS C:\> Test-PartialFileHash -FilePath "C:\Temp\partial.zip" -ExpectedHash "A94A8FE5CC..." -HashType SHA256
    Verifies if partial.zip matches the expected SHA256 hash.

.EXAMPLE
    PS C:\> $files = Get-ChildItem "C:\Downloads\*.part"
    PS C:\> $files | Test-PartialFileHash -ExpectedHash "B94A8FE5CC..." -HashType SHA1
    Verifies multiple partial download files against an expected SHA1 hash.

.EXAMPLE
    PS C:\> if (Test-PartialFileHash "setup.exe" "C45D..." "MD5") {
    >>     Write-Output "File verification successful"
    >> } else {
    >>     Write-Output "Verification failed"
    >> }
    Demonstrates conditional usage with positional parameters.

.INPUTS
    System.String
    You can pipe file paths to the FilePath parameter.

.OUTPUTS
    System.Boolean
    Returns $true if the hash matches, $false if it doesn't or if the file doesn't exist.

.NOTES
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

.LINK
    Get-FileHash
.LINK
    Test-FileHashIntegrity
.LINK
    about_File_Hashing
#>
function Test-PartialFileHash {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({
            if (-not (Test-Path -Path $_ -PathType Leaf)) {
                throw "File not found: $_"
            }
            $true
        })]
        [Alias("FullName","Path")]
        [String]$FilePath,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidatePattern('^[0-9A-Fa-f]+$')]
        [String]$Checksum,

        [Parameter(Mandatory=$true, Position=2)]
        [ValidateSet("SHA1","SHA256", "SHA384", "SHA512", "MD5")]
        [String]$ChecksumType
    )

    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }

    Process {
        try {
            Write-Log -Message "Starting partial hash verification for: $FilePath" -Severity 1 -Source ${CmdletName}
            
            $computedHash = (Get-FileHash -Algorithm $ChecksumType -Path $FilePath -ErrorAction Stop).Hash
            Write-Log -Message "Computed $ChecksumType hash: $computedHash" -Severity 1 -Source ${CmdletName}
            Write-Log -Message "Expected hash: $Checksum" -Severity 1 -Source ${CmdletName}
	
			$result = $Checksum.ToUpper() -eq $computedHash.ToUpper()
            
            if ($result) {
                Write-Log -Message "Hash verification successful" -Severity 1 -Source ${CmdletName}
            } else {
                Write-Log -Message "Hash verification failed" -Severity 3 -Source ${CmdletName}
                Write-Log -Message "Expected: $Checksum`nActual: $computedHash" -Severity 3 -Source ${CmdletName}
            }
            
            return $result
        }
        catch {
            Write-Log -Message "Error during partial hash verification: $_" -Severity 3 -Source ${CmdletName}
            return $false
        }
    }
}



<#
.SYNOPSIS
    Safely removes downloaded files with logging and error handling.

.DESCRIPTION
    This function provides a secure way to remove downloaded files with comprehensive logging.
    It checks for file existence before attempting deletion and handles various file system objects
    including files, directories, and read-only items.

.PARAMETER downloadedFilePath
    The path to the file or directory to be removed. Can be absolute or relative path.
    Accepts pipeline input and wildcards in paths.

.EXAMPLE
    PS C:\> Remove-DownloadedFile -downloadedFilePath "C:\Downloads\tempfile.zip"
    Removes the specified file and logs the operation.

.EXAMPLE
    PS C:\> Get-ChildItem "C:\Temp\*.tmp" | Remove-DownloadedFile
    Removes all .tmp files in C:\Temp directory through pipeline input.

.EXAMPLE
    PS C:\> Remove-DownloadedFile "C:\PartialDownloads\*" -ErrorAction Continue
    Attempts to remove all files in the PartialDownloads directory, continuing on errors.

.INPUTS
    System.String
    You can pipe file or directory paths to this function.

.OUTPUTS
    None
    This function does not return any output.

.NOTES
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

.LINK
    Remove-Item
.LINK
    Test-Path
.LINK
    about_FileSystem_Provider
#>
function Remove-DownloadedFile {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName","Path")]
        [string]$downloadedFilePath
    )

    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }

    Process {
        try {
            if (Test-Path -Path $downloadedFilePath) {
                Write-Log -Message "Attempting to remove: $downloadedFilePath" -Severity 1 -Source ${CmdletName}
                
                if ($PSCmdlet.ShouldProcess($downloadedFilePath, "Remove file/directory")) {
                    Remove-Item -Path $downloadedFilePath -Force -Recurse -ErrorAction Stop
                    Write-Log -Message "Successfully removed: $downloadedFilePath" -Severity 1 -Source ${CmdletName}
                }
            }
            else {
                Write-Log -Message "Path not found, nothing to remove: $downloadedFilePath" -Severity 2 -Source ${CmdletName}
            }
        }
        catch {
            Write-Log -Message "Failed to remove $downloadedFilePath : $_" -Severity 3 -Source ${CmdletName}
            throw $_
        }
    }
}



<#
.SYNOPSIS
    Downloads a file from a specified URL to a local path with optional validation.

.DESCRIPTION
    The Invoke-FileDownload function downloads a file from a specified URL to a local path. 
    It supports BITS transfer for efficient downloads and includes optional file validation.
    The function can resume partial downloads if the file is valid and provides detailed logging.

.PARAMETER URL
    Specifies the URL of the file to download. This parameter is mandatory.

.PARAMETER OutFile
    Specifies the local path where the downloaded file will be saved. This parameter is mandatory.

.PARAMETER Validate
    When specified, the function will validate the downloaded file's integrity.
    If a partial file exists, it will be validated before resuming the download.

.EXAMPLE
    Invoke-FileDownload -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip"
    
    Downloads file.zip from the specified URL and saves it to C:\Downloads\file.zip.

.EXAMPLE
    Invoke-FileDownload -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip" -Validate
    
    Downloads file.zip with validation enabled. If a partial file exists, it will be validated before resuming.

.INPUTS
    None. You cannot pipe objects to Invoke-FileDownload.

.OUTPUTS
    System.Boolean. Returns $true if the download was successful, $false otherwise.

.NOTES
    Author: Peter Rinnenbach
    Version: 1.1
    Date: 02/08/2025
    Prerequisite : PowerShell 5.1 or later

.LINK
    
#>
function Invoke-FileDownload {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$URL,
        [Parameter(Mandatory = $true)]
        [String]$OutFile,
        [Parameter(Mandatory = $false)]
        [switch]$Validate,
		[Parameter(Mandatory = $false)]
		[string]$ChecksumType,
		[Parameter(Mandatory = $false)]
		[string]$Checksum
    )
    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header

        $isPartialFileValid = $false
        if ($Validate -and (Test-Path -Path $OutFile)) {
            Write-Log -Message "Partially downloaded file found. Verifying hash..." -Severity 1 -Source ${CmdletName}
            $isPartialFileValid = Test-PartialFileHash -FilePath $OutFile -Checksum $Checksum -ChecksumType $ChecksumType
            if ($isPartialFileValid) {
                Write-Log -Message "Partial file is valid. Skipping download..." -Severity 1 -Source ${CmdletName}
                return $true
            } else {
                Write-Log -Message "Partial file is corrupted. Deleting and restarting download..." -Severity 3 -Source ${CmdletName}
                Remove-DownloadedFile -downloadedFilePath $OutFile
            }
        }
    }
    Process {
        if ($isPartialFileValid) {
            return $true
        }

        $start_time = Get-Date
        try {
            If (Get-Command Start-BitsTransfer -ErrorAction SilentlyContinue) {
                try {
                    $link = Get-FinalRedirectUrl $URL
                    if ($PSVersionTable.PSVersion.Major -lt 6) {
						$requestedFile = (Invoke-WebRequest $link -Method Head -UseBasicParsing).Headers
					} else {
						$requestedFile = (Invoke-WebRequest $link -Method Head).Headers
					}
                    #$downloadSize = $requestedFile.'Content-Length'
                    $downloadSize = [Int64]::Parse(($requestedFile.'Content-Length' | Select-Object -First 1))
                    Write-Log -Message "Selected download method: BitsTransfer" -Severity 1 -Source ${CmdletName}
                    Write-Log -Message "Start downloading from $link" -Severity 1 -Source ${CmdletName}
                    Write-Log -Message "File size: $([math]::Round(([Int64]"$downloadSize")/1MB,2))MB" -Severity 1 -Source ${CmdletName}
                    Start-BitsTransfer -Source $link -Destination $OutFile
                } catch {
                    Write-Log -Message "Failed to transfer with BITS. Here is the error message:" -Severity 1 -Source ${CmdletName}
                    Write-Log -Message "$($error[0].exception.message)" -Severity 1 -Source ${CmdletName}
                    throw
                }
            }

            If (Test-Path -Path $OutFile) {
                Write-Log -Message "Time taken: $((Get-Date).Subtract($start_time).Minutes) minute(s) $((Get-Date).Subtract($start_time).Seconds) second(s)" -Severity 1 -Source ${CmdletName}
                Write-Log -Message "Downloaded size: $([math]::Round((Get-ItemProperty -Path $OutFile).Length / 1MB, 2)) MB" -Severity 1 -Source ${CmdletName}
                Write-Log -Message "Downloaded file location: $OutFile" -Severity 1 -Source ${CmdletName}

                if ($Validate) {
                    Write-Log -Message "File integrity check starting" -Severity 1 -Source ${CmdletName}
                    Test-FileIntegrity -fileSize $downloadSize -downloadedFilePath $OutFile -Checksum $Checksum -ChecksumType $Checksumtype | Out-Null
                }
                return $true
            }
        } catch {
            Write-Log -Message "Download failed: $($_.Exception.Message)" -Severity 3 -Source ${CmdletName}
            throw
        }
        return $false
    }
}



<#
.SYNOPSIS
    Downloads a file from a URL with automatic retry logic on failure.

.DESCRIPTION
    The Start-FileDownloadWithRetry function attempts to download a file from a specified URL with multiple retries on failure.
    It wraps the Invoke-FileDownload function and adds retry logic with configurable attempts and delay between retries.
    The function provides detailed logging of each attempt and supports file validation.

.PARAMETER URL
    Specifies the URL of the file to download. This parameter is mandatory.

.PARAMETER OutFile
    Specifies the local path where the downloaded file will be saved. This parameter is mandatory.

.PARAMETER RetryCount
    Specifies the maximum number of download attempts. Default is 3.

.PARAMETER Validate
    When specified, the function will validate the downloaded file's integrity.
    If validation fails, the download will be retried (if attempts remain).

.EXAMPLE
    Start-FileDownloadWithRetry -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip"
    
    Downloads file.zip with default retry settings (3 attempts).

.EXAMPLE
    Start-FileDownloadWithRetry -URL "https://example.com/file.zip" -OutFile "C:\Downloads\file.zip" -RetryCount 5 -Validate
    
    Downloads file.zip with validation enabled and up to 5 retry attempts.

.INPUTS
    None. You cannot pipe objects to Start-FileDownloadWithRetry.

.OUTPUTS
    None. The function doesn't return any output but throws an exception if all attempts fail.

.NOTES
    Author: Peter Rinnenbach
    Version: 1.1
    Date: 02/08/2025
    Prerequisite: PowerShell 5.1 or later
                    Invoke-FileDownload function must be available

.LINK
    about_Invoke-FileDownload
#>
function Start-FileDownloadWithRetry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$URL,
        [Parameter(Mandatory = $true)]
        [String]$OutFile,
        [Parameter(Mandatory = $false)]
        [int]$RetryCount = 3,
        [Parameter(Mandatory = $false)]
        [switch]$Validate,
		[Parameter(Mandatory = $false)]
		[string]$ChecksumType,
		[Parameter(Mandatory = $false)]
		[string]$Checksum
    )
    Begin {
        [String]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
        $attempt = 1
    }
    Process {
        while ($attempt -le $RetryCount) {
            Write-Log -Message "Attempt $attempt of $RetryCount..." -Severity 1 -Source ${CmdletName}
            try {
                $result = Invoke-FileDownload -URL $URL -OutFile $OutFile -Validate:$Validate -ChecksumType $ChecksumType -Checksum $Checksum
                if ($result) {
                    Write-Log -Message "Download verification succeeded on attempt $attempt." -Severity 1 -Source ${CmdletName}
                    return
                }
                throw "Download failed without exception"
            } catch {
                Write-Log -Message "Attempt $attempt failed: $($_.Exception.Message), URL = $URL" -Severity 1 -Source ${CmdletName}
                $attempt++
                if ($attempt -gt $RetryCount) {
                    if (Test-Path -Path $OutFile) {
                        Write-Log -Message "Final attempt failed. Removing downloaded file..." -Severity 1 -Source ${CmdletName}
                        Remove-DownloadedFile -downloadedFilePath $OutFile
                    }
                    throw "Download failed after $RetryCount attempts."
                }
                Write-Log -Message "Retrying in 5 seconds..." -Severity 2 -Source ${CmdletName}
                Start-Sleep -Seconds 5
            }
        }
    }
}