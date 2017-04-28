This repository is a starting point for making your own image collections that work with SIL software (e.g. Bloom & WeSay). It includes:

* a sample collection with a multilingual index
* a windows batch file that
    * converts all images to highly compressed png's
    * embeds intellectual property information in each image
    * optionally watermarks each image
    * optionally adds a prefix to each image file
* an installer setup


The following instructions are for people working in Windows, but could be readily adapted for Linux.

# 1) Clone this repository into your own github account.

(Click the grean 'clone' button)

# 2) Set up programs on you machine

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

# 2) See if you can create the Sample Collection

Before customizing anything, test out your setup by creating the sample collection that comes with this project. Open a command prompt window, cd to the project folder, and run

    process-images.bat

That should creat an /output folder and an /output/processed-images folder, with two png image files.

Now make an an installer. Double click the "installer.iss" file. InnoSetup should run. Click "Build:Compile". That should create "/output/Shapes Collection 1.0.exe". Now run that program. When it is done, look in %programdata%\SIL\ImageCollections\. You should see a "Shapes".

# Setting up your image files

Copy your images into the /images folder. If your images are in various sub-folders, that's ok.

# Setting up your index

The index is a tab-delimited, unicode (utf-8) text file. The first row is heading and iso-639 language codes:

filename(tab)subfolder(tab)artist(tab)country(tab)en(tab)fr(tab)es

Those first four columns must be named *exactly* as shown.

Following that header row, your index needs a row for each image in the collection. Within a column of index terms for a language, terms are separated by commas.
For examlpe, this row is for a file named "B-NA-2". It could end in ".tif", ".png", whatever, the index doesn't care. It is in a subfolder named "Brazil".

B-NA-2(tab)Brazil(tab)Romero Britto(tab)Brazil(tab)bird,bird of prey,hawk,flying(tab)птица,хищная птица(tab)burung,burung pemangsa

# Processing your images

The idea is that you want an automated process that will take each image in the images/ directory, get it all ready, and deposit it in the /output/process-images directory. You never commit anything in /output to github; instead the installer maker will gather file from there when it makes the installer.

What the process-images.bat batch file does:

For each image in /images/
	Make a PNG out of it in /output/processed-images, using ImageMagick.
	Compress it really well, using PNGOut.
	Push in metadata, using exiftool.

There is no currently no way here to read the index and embed things like the artist name or index terms into the image.

# Make the installer

Double click on the "installer.iss" file. Innosetup should open.

Replace the values of the sample collection with your own values.

Click "Build:Compile". That should create "/output/Shapes Collection 1.0.exe".

Now run that program. When it is done, look in %programdata%\SIL\ImageCollections\. You should see your collection. Finally, run an SIL program that allows inserting images from a gallery (e.g. Bloom 4.0 or greater), and search for one of your images.

---
## Relevant documentation on metadata

http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/XMP.htm

http://www.metadataworkinggroup.org/pdf/mwg_guidance.pdf