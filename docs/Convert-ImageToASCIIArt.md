# SYNOPSIS

Function to convert an image to ASCII art


# DESCRIPTION

The function Convert-ImageToAsciiArt takes an image file path and converts the image to ASCII art

The ASCII art is created by replacing each pixel in the image with an ASCII character based on the brightness of the pixel

The ASCII characters used are specified in the $chars variable, and their brightness is determined by the grayscale value of the original pixel


# EXAMPLES

## EXAMPLE 1

```powershell
Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.png"
```

Example of converting image `C:\path\to\image.png` to ASCII art


## EXAMPLE 2

```powershell
Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg" -MaxWidth 80 -Contrast 75
```

Example of converting image `C:\path\to\image.jpg` to ASCII art,
specifying the `MaxWidth` of ASCII art output to 80 instead of default value of your terminal width
and the `Contrast` to 75 instead of the default value of 50


## EXAMPLE 3

```powershell
Convert-ImageToAsciiArt C:\path\to\image.jpg
```

Example of converting image `C:\path\to\image.jpg` to ASCII art without using the `ImagePath` flag

This flag is not needed if the image path is specified as the first value when calling the function


## EXAMPLE 4

```powershell
Convert-ImageToAsciiArt -Path C:\path\to\image.jpg -Width 80 | Out-File -FilePath $PWD\ASCII-art.txt
```

Example of converting image `C:\path\to\image.jpg` to ASCII art with a maximum width of 80

Then outputting the ASCII art to a text file with `Out-File` to the current directory

This example uses parameter aliases `Path` and `Width` instead of the full parameters `ImagePath` and `MaxWidth`


## EXAMPLE 5

```powershell
Convert-ImageToAsciiArt -Image C:\path\to\image.jpg -Verbose
```

Example of converting image `C:\path\to\image.jpg` to ASCII art using the `-Verbose` flag

This will show the verbose output of what is being done

This example uses parameter aliases `Image` instead of the full parameter `ImagePath`


# LINK

[https://github.com/ConnerWill/Convert-ImageToASCIIArt](https://github.com/ConnerWill/Convert-ImageToASCIIArt)


# NOTES

Author
: Conner.Will
