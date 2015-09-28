.. Descritipn: These codes are aimed for modifying restart files of 
               NEMO output for switching bwteen different CPU numbers.
       Author: Ou Niansen <ouyuyuan@lasg.iap.ac.cn>
         Date: 2015-03


 Programs
==========

check_dims.f90
--------------

Purpose: 

Check dimensions of restart files, 
see whether all of them have the same dimensions.

Usage:

#. Modify parameters in `check_dims.f90` if needed
#. Modify `EXE` in `makefile`
#. `make`

 Domain decomposition
======================

See NEMO_book_v3.4 P.145 section 8.3
