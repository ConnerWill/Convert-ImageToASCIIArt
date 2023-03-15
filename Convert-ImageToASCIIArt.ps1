function Convert-ImageToASCIIArt {
<#
  .SYNOPSIS
     Function to convert an image to ascii art.

  .DESCRIPTION
     The function Convert-ImageToAsciiArt takes an image file path and converts the image to ASCII art.
     The ASCII art is created by replacing each pixel in the image with an ASCII character based on the brightness of the pixel.
     The ASCII characters used are specified in the $chars variable, and their brightness is determined by the grayscale value of the original pixel.

  .EXAMPLE
      Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg"

  .EXAMPLE
      Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg" -MaxWidth 80 -Contrast 75
#>
    Param (
        [Parameter(
            Mandatory=$true,
            Position=0,
            HelpMessage='Enter path to image'
        )]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string]
        # Specifies the path to the image file to be converted to ASCII art
        $ImagePath,

        [Parameter(
            HelpMessage='Enter maximum width of ASCII art output (Default: 120)'
        )]
        [int]
        # Specifies the maximum width for the ASCII art output
        $MaxWidth = 120,

        [Parameter(
            HelpMessage='Enter contrast value [0-100] (Default: 50)'
        )]
        [ValidateRange(0,100)]
        [int]
        # Specifies the contrast value of ASCII art output
        $Contrast = 50
    )

    # Load the image and resize it to a maximum width of $MaxWidth.
    $image = [System.Drawing.Image]::FromFile($ImagePath)
    $ratio = $MaxWidth / $image.Width
    $newWidth = [int]($image.Width * $ratio)
    $newHeight = [int]($image.Height * $ratio)
    $resizedImage = $image.GetThumbnailImage($newWidth, $newHeight, $null, [System.IntPtr]::Zero)

    # Create a list of ASCII characters to use for the output.
    $chars = @(' ', '.', ',', ':', ';', 'o', 'x', '%', '#', '@')

    # Convert each pixel in the image to an ASCII character based on its brightness.
    $asciiChars = for ($y = 0; $y -lt $resizedImage.Height; $y++) {
        $line = for ($x = 0; $x -lt $resizedImage.Width; $x++) {
            $pixel = $resizedImage.GetPixel($x, $y)
            $brightness = ([int]$pixel.R * 0.299 + [int]$pixel.G * 0.587 + [int]$pixel.B * 0.114) / 255
            $charIndex = [int]($brightness * ($chars.Count - 1))
            $chars[$charIndex]
        }
        [string]::Join('', $line)
    }

    # Apply the contrast parameter by replacing the ASCII characters with different
    # characters based on their brightness.
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
    Write-Output $asciiChars
}
