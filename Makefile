all:
	# nothing to do!

install:
	# Create directories
	install -d $(DESTDIR)/usr/share/SIL/ImageCollections/ArtOfReading
	# Copy files
	install -m 644 *.txt $(DESTDIR)/usr/share/SIL/ImageCollections/ArtOfReading
	cp -dr "ImageCollections/Art Of Reading/images" $(DESTDIR)/usr/share/SIL/ImageCollections/ArtOfReading
