all:
	# nothing to do!

install:
	# Create directories
	install -d $(DESTDIR)/usr/share/ArtOfReading
	# Copy files
	install -m 644 *.txt $(DESTDIR)/usr/share/ArtOfReading
	install -m 644 "ArtOfReadingMultilingualIndex.txt" $(DESTDIR)/usr/share/ArtOfReading
	cp -dr images $(DESTDIR)/usr/share/ArtOfReading
