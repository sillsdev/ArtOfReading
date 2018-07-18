# ArtOfReading
The Art Of Reading DVD contains TIFs, with no embedded metadata.
Art Of Reading Free (this project) instead contains PNGs in which the license and
copyright are embedded in each image. AOR is currently distributed from http://bloomlibrary.org/artofreading. It can be used with any software that supports SIL's [simple image gallery format](https://github.com/sillsdev/image-collection-starter), including [Bloom](http://bloomlibrary.org) and [WeSay](http://software.sil.org/wesay).

The following instructions are for people working in Windows.

# 1) Clone this repository into your own github account.

(Click the green 'clone' button)

# 2) Set up programs on you machine

The following instructions are for people working in Windows, but could be readily adapted for Linux.

If you don't know about setting the PATH variable, this process is probably going to be more technical than you are used to. The first 3 programs below will each need to have an entry in your Windows PATH variable, and you're going to have to add it. There are various tutorials. Here's a good Google query to use: https://www.google.com/search?q=set+windows+path+variable+-java&oq=set+windows+path+variable+-java. Note that if you have a CMD window open, it won't "see" changes you've made to the PATH variable. You need to close the CMD window and re-open.

Add this folder (where this readme and process-images.bat are) to your PATH (this will help in finding pngout).

## ExifTool

ExifTool is used to embed your intellectual property information into each image. Get it at http://www.sno.phy.queensu.ca/~phil/exiftool/ and install it. In April 2018, it does not have an actual installer, so here are some steps:
1. Get the "windows executable", unzip it into this folder, alongside the file named 'process-images.bat'.
2. Rename it from "exiftool(-k).exe" to just "exiftool.exe".

Verify that if you open a new CMD window and cd to this folder, this command works:

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

PNGOut.exe is used to compress the daylights out of the png. Get it here: http://advsys.net/ken/utils.htm. Like exiftool, it lacks an installer. So put the file named pngout.exe in this folder, alongside the file named 'process-images.bat'. Type following command in a CMD window while cd'd into this folder:

    pngout

You should see a bunch of documentation on how to use pngout, which you can ignore.

## InnoSetup

InnoSetup will make your installer. Get the unicode version here: http://www.jrsoftware.org/isdl.php

# Setting up your image files

Get the Art Of Reading TIFF Images from the DVD or art-of-reading-tiffs.tar (in 2017, this is in Bloom Team Google Drive). Place them in the /images folder, so that you have repository-root/images/Brazil, etc. (Hint: start with a small subset of images, verify the results, then go back and do the whole thing.)

There is currently no way here to read the index and embed things like the artist name or index terms into the image. See "Embedded authors & keywords" below for the current state of these things.

# 2) Create the modified files

What we want to do: for each image in /images/
	Make a PNG out of it in /output/processed-images, using ImageMagick.
	Compress it really well, using PNGOut.
	Push in metadata, using exiftool.

Run

    process-images.bat

That should create an /output folder and an /output/processed-images folder.

#3) Create the installer

Now make an an installer. Double click the "installer.iss" file. InnoSetup should run. Click "Build:Compile". That should create "/output/ArtOfReading.exe". Now run that program. When it is done, look in %programdata%\SIL\ImageCollections\. You should see a "Art Of Reading".

#4) Sign the installer

Windows will make it scary for anyone to use the installer until it is signed by someone (e.g. SIL Intl).

---
## Relevant documentation on metadata

http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/XMP.htm

http://www.metadataworkinggroup.org/pdf/mwg_guidance.pdf

The idea is that we need an automated process that will take each image in the images/ directory, get it all ready, and deposit it in the /output/process-images directory. You never commit anything in /output to github; instead the installer maker will gather file from there when it makes the installer. For that we have process-images.bat.
---
## Embedded authors & keywords

The original collection of TIFF images (from the DVD) has a minority of images that had the English index items and (more importantly) the illustrator. For example,

```
$ exiftool Philippines/ELK-219.tif
<snip>
Creator                         : Dan Elkins
Subject                         : hone, mengasah, pole, tiang
Keywords                        : hone, mengasah, pole, tiang
```
Notice that these were done with both English and Indonesian keywords. The keywords are not really helpful at this point, as they are replaced by the index. But having the Creator embedded is terrific; it means that once we add the copyright and license, this image is self-contained in terms of giving proper attribution.

But again, this is just a minority of the images. A quick look suggests there might be more artists in our index than are already embedded in our source TIFF files. The upstream project, image-collection-starter, has a TODO to push artist credits from the index into images. If/when that lands in this fork, it would be good to have some kind of sanity check to make sure that reading authors from our index increases the number of images with author info embedded, and doesn't decrease it.

---
## History
AOR started out as a DVD named "International Illustrations: The Art of Reading". It contained over 10k b&w line drawings from SIL entities around the world.

The package came with a permissive license, but it was just in English prose. It came with a commercial catalogue viewer (I think Portfolio from Extensis), so it couldn't be given away (we had to pay for each copy).

In 2011, in consultation with the Global Publishing department of SIL (the copyright holder), Hatton did the following:

* added a Creative Commons License, embedded in each image
* embedded the index words into each image
* converted to PNG and compressed
* created a simple Windows installer
* published for free on the bloomlibrary.org site as "the Art of Reading"

In 2014, McConnel make a Linux package for AOR.

In 2015, we used Google Translate API to add Arabic, French, Hindi, Portuguese,  Thai, Swahili, and Chinese index terms.

In October 2016, Arjen Lock and Michael Friedrich submitted Russian index items, and we released that as version 3.2.

In 2017, SIL International released Art Of Reading 3.3 with a change of license from CC-BY-ND to CC-BY-SA. We also started over with the build system by building [image-collection-starter](https://github.com/sillsdev/image-collection-starter) and then forking this repository off of that.
