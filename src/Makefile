all: clipper.mex

MKOCTFILE ?= mkoctfile

%.mex: %.cpp
	$(MKOCTFILE) -Wall -mex -s clipper.cpp mexclipper.cpp

clean:
	rm -f *.o octave-core core *.oct *.mex *~
