<div align="center">

<!--<img width="720" height="480" src="/assets/demo-screenshot.png">-->

# **Ｃｏｎｖｅｒｔ－ＩｍａｇｅＴｏＡＳＣＩＩＡｒｔ**

> *Convert an image to ASCII art*

[![GitHub last commit][github-last-commit-badge]][github-commits]
[![GitHub issues][github-issues-badge]][github-issues]
[![GitHub repo size][github-repo-size-badge]][github-repo]
[![GitHub top language][github-top-language-badge]][github-repo]
[![GitHub language count][github-language-count-badge]][github-repo]
[![License][license-badge]][license]
[![GitHub repo stars][github-repo-stars-badge]][github-repo]
[![GitLab][gitlab-badge]][gitlab]

</div>

<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Description

PowerShell function to convert an image to ASCII art

<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Usage

Import PowerShell module

```powershell
Import-Module ./Convert-ImageToASCIIArt.ps1
```

Convert an image to ASCII art

```powershell
Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg"
```

View help for the function

```powershell
Get-Help Convert-ImageToASCIIArt -Full
```

<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Examples

Example of converting image `C:\path\to\image.jpg` to ASCII art

```powershell
Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg"
```

<br>

Example of converting image `C:\path\to\image.jpg` to ASCII art
specifying the `MaxWidth` of ASCII art output to 80 instead of default value of your terminal width
and the `Contrast` to 75 instead of the default value of 50

```powershell
Convert-ImageToAsciiArt -ImagePath "C:\path\to\image.jpg" -MaxWidth 80 -Contrast 75
```

<br>

Example of converting image `$HOME\pictures\image.png` to ASCII art without using the `ImagePath` flag

This flag is not needed if the image path is specified as the first value when calling the function

```powershell
Convert-ImageToAsciiArt $HOME\pictures\image.png
```

<br>

Example of converting image `$env:USERPROFILE\pictures\image.png` to ASCII art with a maximum width of 80

Then outputting the ASCII art to a text file with `Out-File` to the current directory

This example uses parameter aliases `Path` and `Width` instead of the full parameters `ImagePath` and `MaxWidth`

```powershell
Convert-ImageToAsciiArt -Path $env:USERPROFILE\pictures\image.png -Width 80 | Out-File -FilePath $PWD\ASCII-art.txt
```

<br>

Example of converting image `C:\path\to\image.jpg` to ASCII art using the `Verbose` flag

This will show the verbose output of what is being done

This example uses parameter aliases `Image` instead of the full parameter `ImagePath`

```powershell
Convert-ImageToAsciiArt -Image C:\path\to\image.jpg -Verbose
```

<br>

> View more examples by running `Get-Help Convert-ImageToASCIIArt -Examples` after importing the module

<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

# Other

<!-- CONTRIBUTING -->
## Contributing

<details>
  <summary>Click to expand contributing section</summary>

<br>

> Any contributions you make are **greatly appreciated**.

> > If you want to contribute, please fork this repo and create a pull request.

1. Fork the Project
2. Create your Feature Branch

```console
git checkout -b AmazingNewFeature
```

3. Commit your Changes

```console
git commit -m 'Description of the amazing feature you added'
```

4. Push to the Branch

```console
git push origin AmazingNewFeature
```

5. Then open a pull request `:)`

> > If you experience any bugs/issues or have and suggestions, you can simply open an issue `:)`

</details>

## Donate

<a href="https://connerwill.com/static/img/xmr-qr-connerwill.com.png"><img src="https://connerwill.com/static/img/xmr.svg" alt="Monero (XMR) icon and wallet QR code" width="2%" height="2%"> XMR</a> :  <code>86tE67soBqFb5fxNGgC4HLdwZXebP42ewfBwfKyMDKvFbgA7T8p4g4T5BBNA9LNbwaVafup973w41PdvCS7bbj6gTNQpCh1</code>

<a href="https://connerwill.com"><img src="https://connerwill.com/static/img/btc.svg" alt="₿" width="2%" height="2%"></a> BTC : <code>bc1qpg5d69n2knsete7vw7f2vqpkg4a0faq9rc6se0</code>

<p align="right">(<a href="#top">back to top</a>)</p>


<img width="100%" src="https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png">

<!-- LINKS -->
[github-repo]: https://github.com/ConnerWill/Convert-ImageToASCIIArt
[github-top-language-badge]: https://img.shields.io/github/languages/top/ConnerWill/Convert-ImageToASCIIArt
[github-language-count-badge]: https://img.shields.io/github/languages/count/ConnerWill/Convert-ImageToASCIIArt
[github-last-commit-badge]: https://img.shields.io/github/last-commit/ConnerWill/Convert-ImageToASCIIArt
[github-commits]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/commits/main
[github-issues-badge]: https://img.shields.io/github/issues-raw/ConnerWill/Convert-ImageToASCIIArt
[github-issues]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/issues
[github-repo-size-badge]: https://img.shields.io/github/repo-size/ConnerWill/Convert-ImageToASCIIArt
[gitlab-badge]: https://img.shields.io/static/v1?label=gitlab&logo=gitlab&color=E24329&message=mirrored
[gitlab]: https://gitlab.com/ConnerWill/Convert-ImageToASCIIArt
[license-badge]: https://img.shields.io/github/license/ConnerWill/Convert-ImageToASCIIArt
[license]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/blob/main/docs/LICENSE
[github-repo-stars-badge]: https://img.shields.io/github/stars/ConnerWill/Convert-ImageToASCIIArt?style=social

[rainbow-line]: https://raw.githubusercontent.com/ConnerWill/Project-Template/main/assets/lines/rainbow.png
[wiki-url]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/wiki
[wiki-customization-url]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/wiki/Customization
[wiki-installation-url]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/wiki/Installation
[wiki-screenshots-url]: https://github.com/ConnerWill/Convert-ImageToASCIIArt/wiki/Screenshots
