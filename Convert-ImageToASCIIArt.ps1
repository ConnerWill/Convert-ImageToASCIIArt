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
    specifying the MaxWidth of ASCII art output to 80 instead of default value of 120
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

  .LINK
    https://github.com/ConnerWill/Convert-ImageToASCIIArt
#>
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory=$true,
            Position=0,
            HelpMessage='Enter path to image file'
        )]
        [ValidateScript({
            $file = $_
            Try {
                $image = New-Object System.Drawing.Bitmap($file)
                Remove-Variable -Name image, file -ErrorAction SilentlyContinue
                $true
            } Catch {
                $false
            }
        },
        ErrorMessage = "{0} is not an image"
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
        # Specifies the maximum width for the ASCII art output (Default: 120)
        $MaxWidth = 120,

        [Parameter(
            HelpMessage='Enter contrast value [0-100] (Default: 50)'
        )]
        [ValidateRange(0,100)]
        [int]
        # Specifies the contrast value of ASCII art output [0-100] (Default: 50)
        $Contrast = 50
    )

    # List of ASCII characters to use for the output.
    $chars = @(' ', '.', ',', ':', ';', 'o', 'x', '%', '#', '@')

    Write-Verbose -Message "Using image: '$ImagePath' with a MaxWidth of '$MaxWidth' and a Contrast value of '$Contrast'"

    # Load the image and resize it to a maximum width of $MaxWidth.
    Write-Verbose -Message "Loading image '$ImagePath' and resizing it to a maximum width of '$MaxWidth'"
    $image = [System.Drawing.Image]::FromFile($ImagePath)
    $ratio = $MaxWidth / $image.Width
    $newWidth = [int]($image.Width * $ratio)
    $newHeight = [int]($image.Height * $ratio)
    $resizedImage = $image.GetThumbnailImage($newWidth, $newHeight, $null, [System.IntPtr]::Zero)

    # Convert each pixel in the image to an ASCII character based on its brightness.
    Write-Verbose -Message "Converting each pixel in the image to an ASCII character based on its brightness"
    $asciiChars = for ($y = 0; $y -lt $resizedImage.Height; $y++) {
        $line = for ($x = 0; $x -lt $resizedImage.Width; $x++) {
            $pixel = $resizedImage.GetPixel($x, $y)
            $brightness = ([int]$pixel.R * 0.299 + [int]$pixel.G * 0.587 + [int]$pixel.B * 0.114) / 255
            $charIndex = [int]($brightness * ($chars.Count - 1))
            $chars[$charIndex]
        }
        [string]::Join('', $line)
    }

    # Apply the contrast parameter by replacing the ASCII characters with different characters based on their brightness.
    Write-Verbose -Message "Applying the contrast parameter by replacing the ASCII characters with different characters based on their brightness"
    $minCharIndex = 0
    $maxCharIndex = $chars.Count - 1
    $midCharIndex = [int](($minCharIndex + $maxCharIndex) / 2)
    $contrastChars = for ($i = 0; $i -lt $chars.Count; $i++) {
        $brightness = $i / ($chars.Count - 1)
        if ($brightness -lt $Contrast / 200) {
            $minCharIndex
        }
        elseif ($brightness -gt ($Contrast + 100) / 200) {
            $maxCharIndex
        }
        else {
            $midCharIndex
        }
    }
    $asciiChars = $asciiChars -replace "[{0}-{1}]" -f $minCharIndex, $maxCharIndex, $contrastChars

    # Output the ASCII art.
    Write-Verbose -Message "Outputting the ASCII art"
    Write-Output $asciiChars
}

# TODO:
#
