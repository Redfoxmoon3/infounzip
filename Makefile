all: unzip funzip

CC ?= gcc
LD ?= gcc
CPP ?= "gcc -E"

PREFIX ?=
BINDIR = $(PREFIX)/bin

INSTALL_PROGRAM = cp
INSTALL_D = mkdir -p

CFLAGS ?= -I. -DUNIX -DNO_BZIP2_SUPPORT -DLARGE_FILE_SUPPORT -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUNICODE_SUPPORT -DUTF8_MAYBE_NATIVE -DNO_LCHMOD -DHAVE_DIRENT_H -DHAVE_TERMIOS_H -D_MBCS
LFLAGS1 ?=
LDFLAGS ?=

UNZIP_H = unzip.h unzpriv.h globals.h unix/unxcfg.h

OBJU = unzip.o crc32.o crypt.o envargs.o explode.o extract.o fileio.o globals.o inflate.o list.o match.o process.o \
	ttyio.o unreduce.o unshrink.o zipinfo.o unix.o
OBJF = funzip_.o crc32_.o crypt_.o globals_.o inflate_.o ttyio_.o

.SUFFIXES:
.SUFFIXES: _.o .o .c
.c_.o:
	$(CC) -c $(CFLAGS) -DFUNZIP -o $@ $<

.c.o:
	$(CC) -c $(CFLAGS) $<

unix.o: unix/unix.c
	$(CC) -c $(CFLAGS) unix/unix.c

unix_.o: unix/unix.c
	$(CC) -c $(CFLAGS) -DFUNZIP -o $@ unix/unix.c

$(OBJU): $(UNZIP_H)
$(OBJF): $(UNZIP_H)

unzip: $(OBJU)
	$(CC) -o unzip $(LFLAGS1) $(OBJU) $(LDFLAGS)

funzip: $(OBJF)
	$(CC) -o funzip $(LFLAGS1) $(OBJF) $(LDFLAGS)

UNZIPS = unzip funzip

unzips: $(UNZIPS)

clean:
	rm -f *.o unzip funzip unzipsfx

install: $(UNZIPS)
	$(INSTALL_D) $(DESTDIR)$(PREFIX)$(BINDIR)
	$(INSTALL_PROGRAM) $(UNZIPS) $(DESTDIR)$(PREFIX)$(BINDIR)
	#kinda hacky, but it's fine!~
	$(INSTALL_PROGRAM) unzip $(DESTDIR)$(PREFIX)$(BINDIR)/infozip
	$(INSTALL_PROGRAM) unix/zipgrep $(DESTDIR)$(PREFIX)$(BINDIR)
