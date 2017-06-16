MKOCTFILE ?= mkoctfile

OBJS = \
  connector.o \
  martinez.o \
  polygon.o \
  utilities.o

all: polybool.oct

%.o: %.cpp
	$(MKOCTFILE) -Wall -c $< -o $@

%.oct: %.cc
	$(MKOCTFILE) -Wall $< -o $@

polybool.oct: $(OBJS) polybool.cc
	$(MKOCTFILE) -Wall $< -o $@

clean:
	-rm -f *.o *.oct PKG_*

.PHONY: all clean
