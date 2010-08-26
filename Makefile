##############################################################################
# Simple Makefile the the mad low-level decoder demonstration.
# (c) 2001--2004 Bertrand Petit
#-----------------------------------------------------------------------------
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the author nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##############################################################################
# $Name: v1_1p1 $
# $Date: 2004/02/22 03:31:15 $
# $Revision: 1.10 $
##############################################################################

##############################################################################
# Configuration section
##############################################################################

# Where are located the mad header and library?
MADINCDIR=-I/usr/local/include
MADLIBDIR=-L/usr/local/lib

# Options passed to the C compiler. ------------------------------------------
CFLAGS=$(MADINCDIR) -g
LDFLAGS=$(MADLIBDIR) -g

# These options are used by the author during development. Comment
# them if you're not using gcc.
CFLAGS+=-pedantic -Wall -Wpointer-arith -Wbad-function-cast	\
-Wcast-qual -Wcast-align -Wconversion -Wstrict-prototypes	\
-Wmissing-prototypes -Wmissing-declarations -Wnested-externs

# Uncomment the following assignment if your C preprocessor defines
# one of the 'unix', '__unix__, or '__unix' symbol and the system
# libraries does not provide the getopt() standard function.
#CPPFLAGS+=-DWITHOUT_GETOPT

# Options passed to the linker. ----------------------------------------------
# Note that the math library is only used by the wrapping code (for
# decibel handling), the mad library does not need it.
LOADLIBES=-lm -lmad
LDLIBS=$(LOADLIBES) # for BSD make

# Where all of this should be installed? -------------------------------------
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

# Installation-related definitions -------------------------------------------

# Command used to create a directory hierarchy.
MKDIRHIER=mkdir -p
#MKDIRHIER=mkdirhier

# Command used to install a file.
INSTALL=install -cp

##############################################################################
# Program building
##############################################################################

.PHONY: all
all: mp3tocsv

mp3tocsv: mp3tocsv.o bstdfile.o
	$(CC) $(LDFLAGS) $^ $(LOADLIBES) -o $@

mp3tocsv.o: mp3tocsv.c bstdfile.h
bstdfile.o: bstdfile.c bstdfile.h

##############################################################################
# tests
##############################################################################

# Decode a test stream to a file
test.cdr: mp3tocsv test.mp3 
	./mp3tocsv <test.mp3 >test.cdr

# This may help some peoples.
test.wav: test.cdr
	sox test.cdr test.wav

# This uses the play command from the sox package
.PHONY: play test
play test: test.cdr
	play test.cdr

# Reminder...
test.mp3:
	@echo You should provide your own test stream in the \"test.mp3\" file.
	@exit 1



##############################################################################
# Installation
##############################################################################

.PHONY: install
install: $(BINDIR)/mp3tocsv

# Program
$(BINDIR)/mp3tocsv: mp3tocsv $(BINDIR)
	$(INSTALL) mp3tocsv $(BINDIR)/
$(BINDIR):
	$(MKDIRHIER) $(BINDIR)


##############################################################################
# Cleanup
##############################################################################

.PHONY: clean
clean:
	rm -f *.o *~ mp3tocsv test.cdr

##############################################################################
# End fof file Makefile
##############################################################################