all: clipper.mex polybool_mrf.oct

MKOCTFILE ?= mkoctfile

OBJS = \
  connector.o \
  martinez.o \
  polygon.o \
  utilities.o

%.mex: %.cpp
	$(MKOCTFILE) -Wall -mex -s clipper.cpp mexclipper.cpp

%.o: %.cpp
	$(MKOCTFILE) -c $< -o $@

%.oct: %.cc
	$(MKOCTFILE) $< -o $@

polybool_mrf.oct: $(OBJS) polybool_mrf.cc
	$(MKOCTFILE) $(OBJS) polybool_mrf.cc -o $@

clean:
	rm -f *.o *.oct PKG_* *.o octave-core core *.oct *.mex *~

.PHONY: all clean