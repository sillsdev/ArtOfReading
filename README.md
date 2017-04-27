This repository is a starting point for making your own image collections that work with SIL software (e.g. Bloom & WeSay). The following instructions are for  people working in Windows.

# Setting up programs on you machine

## ExifTool

ExifTool is used to embed your intellectual property information into each image. Get it at http://www.sno.phy.queensu.ca/~phil/exiftool/ and install it. Verify that if you open a new CMD window, this command works:

    exiftool -ver

## ImageMagick

ImageMagick can be used to convert you images to PNG. If your collection contains jpgeg photographs or very complicated color drawings that include shading and such, then this is not what you want. Please contact us.

Get it at http://www.imagemagick.org/script/convert.php. Use the installer version, and verify that if you open a new CMD window, this command works:

    convert --version

## PNGOut.exe

PNGOut.exe is used to compress the daylights out of the png. Get it here: http://advsys.net/ken/utils.htm

## InnoSetup

InnoSetup will make your installer. Get it here: http://www.jrsoftware.org/isdl.php

# Setting up your image files

todo

# Setting up your index

todo

# Processing your images

The idea is that you want an automated process that will take each image in the images/ directory, get it all ready, and deposit it in the /output/process-images directory. You never commit anything in /output to github; instead the installer maker will gather file from there when it makes the installer.

What the process-images.bat batch file does:

For each image in /images/
	Make a PNG out of it in /output/processed-images, using ImageMagick.
	Compress it really well, using PNGOut.
	Push in metadata, using exiftool.

# Make the installer

todo

-------------------------------------
Warnings
-------------------------------------
This is fine, it's what this program always says:
	"convert: Unknown field with tag 37724 (0x935c) encountered. `TIFFReadDirectory' @ warning/...."

-------------------------------------
Relevant documentation on metadata
-------------------------------------


http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/XMP.htm

http://www.metadataworkinggroup.org/pdf/mwg_guidance.pdf