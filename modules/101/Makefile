NLIB = -L/snfs01/pwj/SOFT.IFC/netcdf-4.1.2/lib -lnetcdf -lnetcdff\
	   -L/snfs01/pwj/SOFT.IFC/hdf5-1.8.8/lib -lhdf5 -lhdf5_hl
ILIB = -I/snfs01/pwj/SOFT.IFC/hdf5-1.8.8/include \
		-I/snfs01/pwj/SOFT.IFC/netcdf-4.1.2/include
FC   =  ifort
# FF   = -O2 -r8 -no-vec
FF   = -O3 -r8

OBJS = math_extend_mod.o types_mod.o netcdf_io_mod.o

.PHONY: all compile clean

.SUFFIXES:

.SUFFIXES: .f90 .o

all: clean compile
	ar r libmylib.a $(OBJS)

compile: $(OBJS)

.f90.o:
	$(FC) $(FF) -c $< $(NLIB) $(ILIB)

clean:
	rm -f *.mod *.o *.out *.a
