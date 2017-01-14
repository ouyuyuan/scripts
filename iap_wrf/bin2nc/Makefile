
FFLAGS = -O2
NC_CONFIG ?= nc-config
NETCDF_INCDIR ?= $(shell $(NC_CONFIG) --prefix)/include
LIBS := $(shell $(NC_CONFIG) --flibs)

all: compile run

compile:
	ifort $(FFLAGS) -I$(NETCDF_INCDIR) $(LIBS) -o bin2nc bin2nc.f90

run:
	./bin2nc
