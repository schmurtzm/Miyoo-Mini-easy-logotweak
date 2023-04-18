rem extract bootScreen.png from each theme of the Onion Theme repository and create the image files required by Easy LogoTweak.
rem https://github.com/OnionUI/Themes/


for /d %%f in (Themes-main\themes\*) do (
    if exist "%%f\skin\extra\bootScreen.png" (
        set "foldername=%%~nf"
        mkdir "Logos\%%~nf"
		rem max size 110KB, rotation , 24 bit color depth, brightness at 65%
        magick.exe "%%f\skin\extra\bootScreen.png" -define jpeg:extent=110kb -rotate 180 -depth 24 -type truecolor -modulate 65 "Logos\%%~nf\image1.jpg"
    )
)