@echo off
setlocal enableextensions enabledelayedexpansion

FOR /F "tokens=1,2,3* delims=:, " %%i in ('echo %time%') do @set Mytime=%%ih%%jm%%ks
set Mytime=%date:~-4,4%-%date:~-7,2%-%date:~-10,2%_%Mytime%
echo %Mytime%
set /a count = 0
copy /y NUL list.txt >NUL

for /f "delims=" %%A in ('dir /b /s /a:-D ..\..\SD_CARD\App\EasyLogoTweak\logos\image1.jpg') do @(

echo "%%A">>list.txt
  set /a count += 1
  

)

echo Number of bootlogo : !count!
set /a Lines = !count! / 6
set /A test = !count! - (!Lines! * 6) 
if !test! GTR 0 set /a Lines = !Lines! + 1
echo Number of lines in the preview : !Lines!
montage.exe -rotate 180 -geometry 386x305+10+10 -background lightgrey -tile 6x!Lines! @- Preview_%Mytime%.webp < list.txt


echo Removing list.txt
del list.txt
Preview_%Mytime%.webp


echo Make it as default ? [Y/N]
choice /c YN
if %errorlevel%==1 goto yes
if %errorlevel%==2 goto no
:yes
del Preview_previous.webp
rename Preview.webp Preview_previous.webp
rename Preview_%Mytime%.webp Preview.webp
goto :EOF
:no
echo no
goto :EOF
pause