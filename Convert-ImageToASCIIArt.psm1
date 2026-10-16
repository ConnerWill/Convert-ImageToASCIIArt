# Determine whether image processing is actually supported on this platform.
# System.Drawing.Common is Windows-only on .NET 6+ (PowerShell 7): the assembly may
# load on Linux/macOS but then throw PlatformNotSupportedException on first real use.
# We probe by creating a tiny Bitmap. If anything fails we silently skip defining the
# function, so importing this module in $PROFILE on Linux does not print any errors.
$script:ImageProcessingSupported = $false
try {
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    $probe = New-Object System.Drawing.Bitmap 1, 1
    $probe.Dispose()
    $script:ImageProcessingSupported = $true
} catch {
    Write-Verbose "Convert-ImageToASCIIArt: System.Drawing is not usable on this platform; function not defined. ($($_.Exception.Message))"
}

if ($script:ImageProcessingSupported) {

function Convert-ImageToASCIIArt {
<#
  .SYNOPSIS
     Function to convert an image to ASCII art

  .DESCRIPTION
     The function Convert-ImageToAsciiArt takes an image file path and converts the image to ASCII art
     The ASCII art is created by replacing each pixel in the image with an ASCII character based on the brightness of the pixel
     The ASCII characters used are specified in the $chars variable, and their brightness is determined by the grayscale value of the original pixel

  .EXAMPLE
    Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg"

    Example of converting image 'C:\path\to\image.jpg' to ASCII art

  .EXAMPLE
    Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg" -MaxWidth 80 -Contrast 75

    Example of converting image 'C:\path\to\image.jpg' to ASCII art,
    specifying the MaxWidth of ASCII art output to 80 instead of default value of your terminal width
    and the Contrast to 75 instead of the default value of 50

  .EXAMPLE
    Convert-ImageToAsciiArt C:\path\to\image.jpg

    Example of converting image 'C:\path\to\image.jpg' to ASCII art without using the 'ImagePath' flag
    This flag is not needed if the image path is specified as the first value when calling the function

  .EXAMPLE
    Convert-ImageToAsciiArt -Path C:\path\to\image.jpg -Width 80 | Out-File -FilePath $PWD\ASCII-art.txt

    Example of converting image 'C:\path\to\image.jpg' to ASCII art with a maximum width of 80
    Then outputting the ASCII art to a text file with Out-File to the current directory
    This example uses parameter aliases 'Path' and 'Width' instead of the full parameters 'ImagePath' and 'MaxWidth'

  .EXAMPLE
    Convert-ImageToAsciiArt -Image C:\path\to\image.jpg -Verbose

    Example of converting image 'C:\path\to\image.jpg' to ASCII art using the Verbose flag
    This will show the verbose output of what is being done
    This example uses parameter aliases 'Image' instead of the full parameter 'ImagePath'

  .EXAMPLE
    Convert-ImageToAsciiArt -ImagePath .\image.png -Chars ' .:-=+*#%@'

    Example of converting image '.\image.png' to ASCII art using a custom character set
    The characters are ordered from lightest (space) to darkest ('@')

  .EXAMPLE
    Convert-ImageToAsciiArt -Path .\image.png -Ramp '@%#*+=-:. '

    Example of converting image '.\image.png' to ASCII art using the 'Ramp' alias of the 'Chars' parameter
    This ramp is reversed (darkest to lightest), producing an inverted/negative-looking image

  .LINK
    https://github.com/ConnerWill/Convert-ImageToASCIIArt

  .NOTES
    Author: Conner.Will
#>
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory=$true,
            Position=0,
            HelpMessage='Enter path to image file'
        )]
        [ValidateScript({
            # Validate the input is an image by attempting to load the file as an image.
            # Resolve the path first so relative paths (e.g. .\image.png) work, since
            # .NET methods do not honor PowerShell's current directory ($PWD).
            Try {
                $resolvedPath = (Resolve-Path -LiteralPath $_ -ErrorAction Stop).ProviderPath
                $bitmap = New-Object System.Drawing.Bitmap($resolvedPath)
                $bitmap.Dispose()
                $true
            } Catch {
                $false
            }
        }, ErrorMessage = "{0} is not an image"
        )]
        [Alias("Path","Image")]
        [string]
        # Specifies the path to the image file to be converted to ASCII art (Supported extensions: .jpg .jpeg .png .bmp .gif)
        $ImagePath,

        [Parameter(
            HelpMessage='Enter maximum width of ASCII art output (Default: 120)'
        )]
        [Alias("Width")]
        [int]
        # Specifies the maximum width for the ASCII art output (Default: terminal width, or 120 if unavailable)
        $MaxWidth = $(if ($Host.UI.RawUI.WindowSize.Width -gt 0) { $Host.UI.RawUI.WindowSize.Width } else { 120 }),

        [Parameter(
            HelpMessage='Enter contrast value [0-100] (Default: 50)'
        )]
        [ValidateRange(0,100)]
        [int]
        # Specifies the contrast value of ASCII art output [0-100] (Default: 50)
        $Contrast = 50,

        [Parameter(
            HelpMessage='Enter the characters to use for the ASCII art, ordered from lightest (space) to darkest'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Characters","Ramp")]
        [char[]]
        # Specifies the characters used to render the ASCII art, ordered from lightest to darkest (Default: ' .,:;ox%#@')
        $Chars = @(' ', '.', ',', ':', ';', 'o', 'x', '%', '#', '@')
    )

    # List of ASCII characters to use for the output (passed via -Chars, lightest to darkest).
    $chars = $Chars

    Write-Verbose -Message "Using image: '${ImagePath}' with a MaxWidth of '${MaxWidth}' and a Contrast value of '${Contrast}'"

    # Resolve the path to an absolute path so relative paths (e.g. .\image.png) work,
    # since .NET methods do not honor PowerShell's current directory ($PWD).
    $ImagePath = (Resolve-Path -LiteralPath $ImagePath).ProviderPath

    $image = $null
    $resizedImage = $null
    Try {
        # Load the image and resize it to a maximum width of $MaxWidth.
        Write-Verbose -Message "Loading image '${ImagePath}' and resizing it to a maximum width of '${MaxWidth}'"
        $image = [System.Drawing.Image]::FromFile($ImagePath)
        $ratio = $MaxWidth / $image.Width
        $newWidth = [int]($image.Width * $ratio)
        # Characters are roughly twice as tall as they are wide, so halve the height
        # to keep the output from looking vertically stretched.
        $newHeight = [int]($image.Height * $ratio * 0.5)
        if ($newHeight -lt 1) { $newHeight = 1 }
        $resizedImage = $image.GetThumbnailImage($newWidth, $newHeight, $null, [System.IntPtr]::Zero)

        # Precompute a contrast factor. Contrast 50 is neutral (factor 1.0); higher values
        # push brightness away from the midpoint (0.5), lower values pull it toward the midpoint.
        $contrastFactor = $Contrast / 50

        # Convert each pixel in the image to an ASCII character based on its (contrast-adjusted) brightness.
        Write-Verbose -Message "Converting each pixel in the image to an ASCII character based on its brightness"
        $maxCharIndex = $chars.Count - 1
        $asciiChars = for ($y = 0; $y -lt $resizedImage.Height; $y++) {
            $line = for ($x = 0; $x -lt $resizedImage.Width; $x++) {
                $pixel = $resizedImage.GetPixel($x, $y)
                $brightness = ([int]$pixel.R * 0.299 + [int]$pixel.G * 0.587 + [int]$pixel.B * 0.114) / 255

                # Apply contrast by stretching brightness around the 0.5 midpoint.
                $brightness = (($brightness - 0.5) * $contrastFactor) + 0.5
                if ($brightness -lt 0) { $brightness = 0 }
                elseif ($brightness -gt 1) { $brightness = 1 }

                $charIndex = [int]($brightness * $maxCharIndex)
                $chars[$charIndex]
            }
            [string]::Join('', $line)
        }

        # Output the ASCII art.
        Write-Verbose -Message "Outputting the ASCII art"
        Write-Output $asciiChars
    }
    Finally {
        # Dispose image objects to release GDI+ handles and the file lock held by FromFile.
        if ($resizedImage) { $resizedImage.Dispose() }
        if ($image) { $image.Dispose() }
    }
}

} # end if ($script:ImageProcessingSupported)

# TODO:
#
