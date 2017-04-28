echo off
SETLOCAL ENABLEEXTENSIONS
setlocal enabledelayedexpansion

set COPYRIGHT=Copyright My Organization 2017
set LICENSE=http://creativecommons.org/licenses/by-nd/3.0/
set ATTRIBUTIONURL=http://myOrganization.org
set COLLECTIONURI=http://myOrganization.org/aboutNeatoImages
set COLLECTIONNAME=Neato Images

REM this is optional; you might like to prefix all images wit something indicating the collection it came from. If not, set to ""
set PREFIX=neato_
REM this is optional, if you want to watermark each image. Otherwise, set to ""
set WATERMARK="Neato.CC-BY-SA"

REM For this script to work, the following locations have to be in windows PATH environment variable
REM variable (hopefully the installers will do  that for you?): imagemagick, exiftool, pngout

REM Window batch file information that is key to understanding some of this:
REM 	the loop parameter has to start with a %, so whenever it is referenced, that has to be doubled, so we get %%1
REM 	%~n1 equals the file name of %1 without the file extension
REM		to expand variables, you surround them with %,
REM 		unless they have one of these macros like %~n1,
REM 		or unles they ever change, in which case use !.
REM		This language is GARBAGE, why didn't I just do a bash script?

set source="images"
set dest="output/processed-images"


REM Clear out existing /processed-images
rmdir /S /Q %dest%

REM copy the source images to /processed-images
%SystemRoot%\system32\xcopy.exe %source% %dest% /S /Q /I


REM process each file that looks like an image (skipping jpg, becuase you probably don't want to be converting those to PNG)
REM /R here means "recursive"
FOR /R %dest% %%1 in (*.png, *.tif, *.bmp) DO (
	pushd "%%~dp1"
	 SETLOCAL
	set SRC=%%1
	ECHO processing %%1 which should be same as !SRC!

	REM whatever the filename was, the new file name is that with the prefix (if any) plus the .png extension
	REM set NEWNAME=!%PREFIX%%%~n1.png!


	set NEWNAME=%PREFIX%%%~n1.png
	ECHO NEWNAME is !NEWNAME!
	set RESULT=%%~dp1!NEWNAME!
	ECHO creating !RESULT!

	REM use imagemagick-covert to convert images to png if needed
	call "convert" "!SRC!" !RESULT!

	REM if we've made a copy with a different name, remove the original from /process-images
	IF NOT !SRC!==!RESULT! (
	 ECHO removing !SRC!
		del !SRC!
	)

	REM use imagemagick-convert to add a watermark
	IF "%WATERMARK%" NEQ "" (
		ECHO Watermarking with %WATERMARK%
		call "convert" -pointsize 20 -gravity SouthWest -annotate +10+10 "%WATERMARK%" !RESULT! !RESULT!
	)

	REM /ktEXt,zTXt makes it preserve the metadata, but seems to prevent most of the compression
	REM for some reason without /v, it tells me it's not found
	REM ECHO Compressing %RESULT%
	call "pngout" /y /v /s1 /ktEXt,zTXt !RESULT!

	ECHO Embedding metadata in %RESULT%
	call "exiftool" -E -overwrite_original_in_place -copyright="%COPYRIGHT%" -XMP-cc:License="%LICENSE%" -XMP:Marked="True" -XMP:ReuseAllowed="true" -XMP:AttributionUrl="%ATTRIBUTIONURL%" -XMP:CollectionURI="%COLLECTIONURI%" -XMP:CollectionName="%COLLECTIONNAME%"  !RESULT!
	ENDLOCAL
	popd

)


