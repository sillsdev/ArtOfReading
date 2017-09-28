# ArtOfReading
The Art Of Reading DVD contains TIFs, with no embedded metadata.
Art Of Reading Free (this project) instead contains PNGs in which the license and
copyright are embedded in each image. AOR is currently distributed from http://bloomlibrary.org/artofreading. It can be used with any software that supports SIL's [simple image gallery format](https://github.com/sillsdev/image-collection-starter), including [Bloom](http://bloomlibrary.org) and [WeSay](http://software.sil.org/wesay).

The following instructions are for people working in Windows.

# 1) Set up programs on you machine

## ExifTool

ExifTool is used to embed your intellectual property information into each image. Get it at http://www.sno.phy.queensu.ca/~phil/exiftool/ and install it. Verify that if you open a new CMD window, this command works:

    exiftool -ver

You should see something like

    x:\dev\image-collection-starter>exiftool -ver
    8.68

## ImageMagick

ImageMagick used to convert TIF images to PNG.

Get it at http://www.imagemagick.org/script/download.php. Get the first choice under "Windows Binary Release", and verify that if you open a new CMD window, this command works:

    magick --version

You should see something like

    x:\dev\image-collection-starter>magick --version
    Version: ImageMagick 7.0.7-1 Q16 x64 2017-09-09 http://www.imagemagick.org
    Copyright: Copyright (C) 1999-2015 ImageMagick Studio LLC

## PNGOut.exe

PNGOut.exe is used to compress the daylights out of the png. Get it here: http://advsys.net/ken/utils.htm. Verify that if you open a new CMD window, the following command shows you pngout help:

    pngout

You should see a bunch of documentation.

## InnoSetup

InnoSetup will make your installer. Get the unicode version here: http://www.jrsoftware.org/isdl.php

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Setting up your image files

Copy your images into the /images folder. If your images are in various sub-folders, that's ok.

There is no currently no way here to read the index and embed things like the artist name or index terms into the image.

# 2) Create the modified files

What we want to do: for each image in /images/
	Make a PNG out of it in /output/processed-images, using ImageMagick.
	Compress it really well, using PNGOut.
	Push in metadata, using exiftool.

Run

    process-images.bat

That should creat an /output folder and an /output/processed-images folder.

#3) Create the installer

Now make an an installer. Double click the "installer.iss" file. InnoSetup should run. Click "Build:Compile". That should create "/output/ArtOfReading.exe". Now run that program. When it is done, look in %programdata%\SIL\ImageCollections\. You should see a "Art Of Reading".


---
## Relevant documentation on metadata

http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/XMP.htm

http://www.metadataworkinggroup.org/pdf/mwg_guidance.pdf

The idea is that we need an automated process that will take each image in the images/ directory, get it all ready, and deposit it in the /output/process-images directory. You never commit anything in /output to github; instead the installer maker will gather file from there when it makes the installer. For that we have process-images.bat.
---

## History
AOR started out as a DVD named "International Illustrations: The Art of Reading". It contained over 10k b&w line drawings from SIL entities around the world.

The package came with a permissive license, but it was just in English prose. It came with a commercial catalogue viewer (I think Portfolio from Extensis), so it couldn't be given away (we had to pay for each copy).

In 2011, in consultation with the Global Publishing department of SIL (the copyright holder), Hatton did the following:
There is no currently no way here to read the index and embed things like the artist name or index terms into the image. You may notice that Art Of Reading images do have that, but that was done with some other process. We consider embedding the artist name to be very important and helpful, but that is not yet part of this project.

* added a Creative Commons License, embedded in each image
* embedded the index words into each image
* converted to PNG and compressed
* created a simple Windows installer
* published for free on the bloomlibrary.org site as "the Art of Reading"

In 2014, McConnel make a Linux package for AOR.

In 2015, we used Google Translate API to add Arabic, French, Hindi, Portuguese,  Thai, Swahili, and Chinese index terms.

In October 2016, Arjen Lock and Michael Friedrich submitted Russian index items, and we released that as version 3.2.

In 2017, SIL International released Art Of Reading 3.3 with a change of license from CC-BY-ND to CC-BY-SA. We also started over with the build system by building [image-collection-starter](https://github.com/sillsdev/image-collection-starter) and then forking this repository off of that.