echo off
SETLOCAL ENABLEEXTENSIONS
setlocal enabledelayedexpansion

REM For this script to work, the following locations have to be in windows PATH environment variable
REM variable (hopefully the installers will do  that for you?): imagemagick, exiftool, pngout

REM ----------- BEGIN LINES THAT YOU NORMALY CUSTOMIZE FOR EACH COLLECTION -------------------------
REM Important! Do not follow the equal sign with a space.
set COPYRIGHT=Copyright My Organization 2017
set LICENSE=http://creativecommons.org/licenses/by-sa/4.0/
set ATTRIBUTIONURL=http://myOrganization.org
set COLLECTIONURI=http://myOrganization.org/aboutShapesImages
set COLLECTIONNAME=Shapes Images
REM this is optional; you might like to prefix all images wit something indicating the collection it came from. If not, set to just PREFIX=
set PREFIX=shape_
REM This is optional, if you want to watermark each image. Otherwise, set to ""
REM Note that the approach used below is pretty ugly, and we don't use it for Art Of Reading.
REM It would not be hard to instead have a the watermark done as a semi-transparent image instead of this black text.
REM But either way, it's going to expand/shrink with the image, so not so practicle.
set WATERMARK="Shapes.CC-BY-SA"
REM ----------- END OF LINES THAT YOU NORMALY CUSTOMIZE FOR EACH COLLECTION -------------------------


REM Window batch file information that is key to understanding some of this:
REM 	the loop parameter has to start with a %, so whenever it is referenced, that has to be doubled, so we get %%1
REM 	%~n1 equals the file name of %1 without the file extension
REM		to use constants surround them with "%",
REM 	to use looped indices with special macros, do like this (this one is for the index "1") %~n1,
REM 	to use local variables that change, surround with "!" (and have "setlocal enabledelayedexpansion" at the start of the bat the file).

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

	REM don't let our variables leak outside of this script (SETLOCAL)
	SETLOCAL
	set SRC="%%1"

	REM whatever the filename was, the new file name is that with the prefix (if any) plus the .png extension
	set NEWNAME=%PREFIX%%%~n1.png
	set RESULT="%%~dp1!NEWNAME!"

	REM use imagemagick-covert to convert images to png if needed
	call "convert" !SRC! !RESULT!

	REM if we've made a copy with a different name, remove the original from /process-images
	IF NOT !SRC!==!RESULT! (
		del !SRC!
	)

	REM use imagemagick-convert to add a watermark
	IF "%WATERMARK%" NEQ "" (
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


