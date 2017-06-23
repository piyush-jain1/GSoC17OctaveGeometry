MKOCTFILE ?= mkoctfile

OBJS = \
  connector.o \
  martinez.o \
  polygon.o \
  utilities.o

all: polybool_martinez.oct

%.o: %.cpp
	$(MKOCTFILE) -c $< -o $@

%.oct: %.cc
	$(MKOCTFILE) $< -o $@

polybool_martinez.oct: $(OBJS) polybool_martinez.cc
	$(MKOCTFILE) $(OBJS) polybool_martinez.cc -o $@

clean:
	-rm -f *.o *.oct PKG_*

.PHONY: all clean
