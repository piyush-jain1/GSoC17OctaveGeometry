MKOCTFILE ?= mkoctfile

OBJS = \
  connector.o \
  martinez.o \
  polygon.o \
  utilities.o

all: polybool.oct

%.o: %.cpp
	$(MKOCTFILE) -c $< -o $@

%.oct: %.cc
	$(MKOCTFILE) $< -o $@

polybool.oct: $(OBJS) polybool.cc
	$(MKOCTFILE) $(OBJS) polybool.cc -o $@

clean:
	-rm -f *.o *.oct PKG_*

.PHONY: all clean
