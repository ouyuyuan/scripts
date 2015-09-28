NLIB = -L/snfs01/pwj/SOFT.IFC/netcdf-4.1.2/lib -lnetcdf -lnetcdff\
	   -L/snfs01/pwj/SOFT.IFC/hdf5-1.8.8/lib -lhdf5 -lhdf5_hl \
		-L/snfs01/ou/coded/fortran/modules -lmylib
ILIB = -I/snfs01/pwj/SOFT.IFC/hdf5-1.8.8/include \
		-I/snfs01/pwj/SOFT.IFC/netcdf-4.1.2/include \
		-I/snfs01/ou/coded/fortran/modules

FC   =  ifort
# FF   = -O2 -r8 -no-vec -fpe0 -traceback
# FF   = -O2 -r8 -no-vec
 FF   = -O3 -r8
# FF   = -O2 -r8 -no-vec
# FF   = -O2 -no-vec

EXE  = main
OBJS = basic_mod.o io_mod.o integrate_mod.o main.o

.PHONY: all compile run clean

# need this 'empty' line to avoid some problem when 'make'
.SUFFIXES:

.SUFFIXES: .f90 .o

all: clean compile run

compile: $(OBJS)
	$(FC) $(FF) $(OBJS) -o $(EXE) $(NLIB) $(ILIB)

.f90.o:
	$(FC) $(FF) -c $< $(NLIB) $(ILIB)

run:
	./$(EXE)

clean:
	rm -f *.mod *.o *.out $(EXE)
