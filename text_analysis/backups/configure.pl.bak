#!/usr/bin/perl -w

# Description: Analyse model.config to produce Makefile, scripts, etc
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-01-15 21:32:48 CST
# Last Change: 2013-01-27 16:59:16 CST

use 5.010;
use strict;
use Cwd;
use File::Basename;
use configFunc;

# def vars <<<1

my $case      = &get_setting("case name");
my $np        = &get_setting("processor number");
my $plat      = &get_setting("platform");
my $res       = &get_setting("resolution");

# path <<<2

my $familroot    = cwd;
my $caseroot     = "$familroot/$case";
my $utilsroot    = "$familroot/utils";
my $srcroot      = "$familroot/" . &get_setting("source root");
my $inputroot    = "$familroot/input";

my $prep    = "$caseroot/prep";
my $postp   = "$caseroot/postp";
my $exe     = "$caseroot/exe";
my $work    = "$caseroot/work";
my $casesrc = "$caseroot/src";

my $mkmf      = "$prep/mkmf";
my $mkmf_temp = "$prep/mkmf.template.$plat";

my $ccroot      = &get_setting("C compiler root");
my $cc_inc      = "$ccroot/include/intel64";
my $cc_lib      = "$ccroot/lib/intel64";
my $cc_bin      = "$ccroot/bin/intel64";
my $curl_lib    = &get_setting("curl root") . "/lib";
my $famil_inc   = "$casesrc/atm/shared/include";
my $forroot     = &get_setting("Fortran compiler root");
my $for_inc     = "$forroot/include/intel64";
my $for_lib     = "$forroot/lib/intel64";
my $for_bin     = "$forroot/bin/intel64";
my $gsl_lib     = &get_setting("gsl root") . "/lib";
my $hdf5root    = &get_setting("hdf5 root");
my $hdf5_inc    = "$hdf5root/include";
my $hdf5_lib    = "$hdf5root/lib";
my $ncoroot     = &get_setting("nco root");
my $nco_lib     = "$ncoroot/lib";
my $mpiroot     = &get_setting("mpi root");
my $mpi_bin     = "$mpiroot/bin64";
my $mpi_inc     = "$mpiroot/include64";
my $mpi_lib     = "$mpiroot/lib64";
my $mpp_inc     = "$casesrc/atm/shared/mpp/include";
my $netcdfroot  = &get_setting("netcdf root");
my $netcdf_inc  = "$netcdfroot/include";
my $netcdf_lib  = "$netcdfroot/lib";
my $udunits_lib = &get_setting("udunits root") . "/lib";
my $zlibroot    = &get_setting("zlib root");
my $zlib_inc    = "$zlibroot/include";
my $zlib_lib    = "$zlibroot/lib";

my $ld_library_path = "$hdf5_lib:$netcdf_lib:$nco_lib:$mpi_lib:" . 
                      "$cc_lib:$gsl_lib:$curl_lib:$udunits_lib";

# files <<<2

my $select_hosts = "select_hosts.pl";
my $mpdfile      = "$caseroot/mpd.hosts";
my $mppnccombine = "$prep/mppnccombine.$plat";
my $namelists    = "namelists";
my $makefile     = "Makefile";
my $env          = "env";
my $compile      = "compile";
my $pathnames    = "$prep/path_names";

# create files <<<1

# env <<<2

open OUT, ">$env";
say OUT "# created by: " . basename($0) . "

export CASE=" . &get_setting("case name") . "
export PLAT=" . &get_setting("platform")  . "
export RES=$res
export NP=$np

export FAMILROOT=$familroot
export UTILSROOT=$utilsroot
export SRCROOT=$srcroot
export INPUTROOT=$inputroot

export CASEROOT=$caseroot

export PREP=$prep
export POSTP=$postp

export EXE=$exe
export WORK=$work

export NETCDFROOT=$netcdfroot
export HDF5ROOT=$hdf5root
export ZLIBROOT=$zlibroot
export NCOROOT=$ncoroot
export MPIROOT=$mpiroot
export MPI_INC=$mpi_inc
export MPI_LIB=$mpi_lib
export MPI_BIN=$mpi_bin
export FORROOT=$forroot
export FOR_INC=$for_inc
export FOR_LIB=$for_lib
export FOR_BIN=$for_bin
export CCROOT=$ccroot
export CC_INC=$cc_inc
export CC_LIB=$cc_lib
export CC_BIN=$cc_bin

export LD_LIBRARY_PATH=$ld_library_path
";
close(OUT);

# namelists <<<2

my $res0 = $res;
$res0    =~ s/C//;
my ($dt_atmos, $k_split, $n_split);
given($res) {
    when ('C48')  { ($dt_atmos, $k_split, $n_split) = (1800, 1,  6); }
    when ('C96')  { ($dt_atmos, $k_split, $n_split) = (1200, 1,  8); }
    when ('C192') { ($dt_atmos, $k_split, $n_split) = (900,  2,  9); }
    when ('C384') { ($dt_atmos, $k_split, $n_split) = (600,  2, 11); }
    when ('C768') { ($dt_atmos, $k_split, $n_split) = (300,  2, 10); }
    default { die "Un-handled resolution: $res!" }
}
my $layout = int(sqrt($np/6));

open OUT, ">$namelists";
say OUT "# created by: " . basename($0) . "
 &main_nml
     restart_interval     = 0,1,0,0,0,0
     current_date         = 1,1,1,0,0,0
     calendar             = \"NOLEAP\"
     memuse_interval      = " . 86400/$dt_atmos . "
     months               = 1
     days                 = 0
     hours                = 0
     minutes              = 0
     seconds              = 0
     dt_atmos             = $dt_atmos /

 &fms_io_nml
     threading_write      = \"multi\"
     fileset_write        = \"multi\" /

 &fms_nml
     clock_grain          = \"LOOP\"
     domains_stack_size   = 900000
     print_memory_usage   = .true.  /

 &fv_core_nml
     layout               = $layout,$layout
     npx                  = " . ($res0 + 1) . "
     npy                  = " . ($res0 + 1) . "
     npz                  = 32
     uniform_vert_spacing = .false.
     ntiles               = 6
     do_Held_Suarez       = .false.
     do_full_phys         = .true.
     do_APE               = .false.
     adiabatic            = .false.
     print_freq           = 0
     grid_type            = 0
     io_layout            = 1,1
     k_split              = $k_split
     n_split              = $n_split
     nord                 = 1
     d2_bg                = 0.0
     d4_bg                = 0.16
     nwat                 = 6
     fv_land              = .true.
     mountain             = .true. /

 &fv_grid_nml
     grid_name            = \"Gnomonic\" /

 &test_case_nml
     test_case            = 14 
     alpha                = 0.00 /

 &surf_map_nml
     surf_file            = \"../../../input/atm/topo2min.nc\"
     nlon                 = 10800
     nlat                 = 5400 /

 &amip_interp_nml
     sstdir               = \"../../../input/ocn\"
     data_set             = \"amip2\"
     date_out_of_range    = \"climo\"
     interp_oi_sst        = .false. 
     use_ncep_sst         = .false.
     use_ncep_ice         = .false.
     forecast_mode        = .false. /

 &amip_sst_nml
     use_annual           = .false.
     use_climo            = .true. /

 &clm_veg_soi_nml
     data_file            = \"../../../input/lnd/geo_em.nc\"
     nx                   = 4338
     ny                   = 2169 /

 &swe_soil_in_nml
     data_file            = \"../../../input/lnd/gldas_clm.nc\"
     nx                   = 360
     ny                   = 150
     nz                   = 10 /

 &clm_init_nml
     clmdir               = \"../../../input/lnd\" /

 &clm_input_nml
     data_file            = \"../../../input/lnd/clm4.nc\"
     nx                   = 576
     ny                   = 384
     nz                   = 10
     nt                   = 12
     pft                  = 17
     ef                   = 6 /

 &ozcmip_nml
     oz_dir               = \"../../../input/atm\"
     oz_lib               = \"history\"
     scenario_ozone       = \"FIXED\"
     use_ar5_ozone        = .true.
     rampYear_ozone       = 0 /

 &raduk_nml
     rad_lib              = \"../../../input/atm/rad_lib\"
     rad_interval         = 2 /

 &gw_drag_nml
     gw_drag_file         = \"../../../input/atm/newmfspectra40_dc25.nc\"
     fcrit2               = 1.0 /

 &cldmp_nml
     aerosol_file         = \"../../../input/atm/aerosol.nc\"
     nx                   = 144
     ny                   = 96
     nz                   = 28 /

 &topography_nml
     topog_file           = \"../../../input/atm/navy_topography.data/navy_topography.data.nc\" /

 &cg_drag_nml
     cg_drag_freq         = 1800
     cg_drag_offset       = 0
     Bt_0                 = 0.004
     Bt_aug               = 0.000
     Bt_nh                = 0.001
     Bt_sh                = -0.001
     Bt_eq                = 0.000
     Bt_eq_width          = 4.0
     phi0n                = 30.0
     phi0s                = -30.0
     dphin                = 5.0
     dphis                = -5.0 /

 &damping_driver_nml
     trayfric             = 0.0
     nlev_rayfric         = 1
     do_mg_drag           = .true.
     do_cg_drag           = .true.
     do_topo_drag         = .false.
     do_conserve_energy   = .true. /

 &mg_drag_nml
     gmax                 = 1.0
     acoef                = 1.0
     do_conserve_energy   = .true.
     flux_cut_level       = 30.0E2
     source_of_sgsmtn     = \"input/computed\" /
";
close(OUT);

# compile <<<2

open OUT, ">$compile";
say OUT "#!/bin/bash
# created by: " . basename($0) . "

source $caseroot/$env

gcc -O -o $mppnccombine -I$netcdf_inc -L$netcdf_lib \\
    $postp/mppnccombine.c -L$netcdf_lib -lnetcdf -lnetcdff \\
    -L$hdf5_lib -lhdf5 -lhdf5_hl -L$zlib_lib -lz

cd $exe

$mkmf -p $exe/famil.x -t $mkmf_temp -c \"-Duse_libMPI -Duse_netCDF -DSPMD\" \\
    $pathnames $mpp_inc $famil_inc $netcdf_inc $hdf5_inc $zlib_inc $mpi_inc

make -j 8 -f Makefile 
";
close(OUT);
chmod 0766, $compile;

# Makefile <<<2

open OUT, ">$makefile";
say OUT "# Makefile created by: " . basename($0) . "

.PHONY: prepare compile

prepare:
\tmkdir -p $caseroot $casesrc $prep $postp $exe $work
\tmkdir -p $work/input $work/restart
\tcp -f $utilsroot/bin/mkmf $prep/
\tmv -f $namelists $prep/
\tcp -f $utilsroot/bin/mkmf.template.$plat $prep/
\tcp -f $utilsroot/exp/field_table $prep/
\tcp -f $utilsroot/exp/diag_table $prep/
\tcp -f $utilsroot/postp/*.c $postp/
\tcp -f $utilsroot/postp/*.h $postp/
\tcp -f $utilsroot/postp/Make_fregrid_parallel.$plat $postp/
\tcp -f $utilsroot/mosaic/$res/* $postp/
\tsed -i \"s#undef#$res#g\" $prep/diag_table
\tcp -f $prep/namelists $work/input.nml
\tcp -f $prep/diag_table $work/diag_table
\tcp -f $prep/field_table $work/field_table
\tmv -f $compile $caseroot/
\tfind $casesrc -name \"*.inc\" > $pathnames
\tfind $casesrc -name \"*.[ff]90\" >> $pathnames
\tfind $casesrc -name \"*.[hh]90\" >> $pathnames
\tfind $casesrc -name \"*.[ff]\" >> $pathnames
\tfind $casesrc -name \"*.[cc]\" >> $pathnames
\tfind $casesrc -name \"*.[hh]\" >> $pathnames
\tfind $srcroot -name \"*.inc\" > $pathnames
\tfind $srcroot -name \"*.[ff]90\" >> $pathnames
\tfind $srcroot -name \"*.[hh]90\" >> $pathnames
\tfind $srcroot -name \"*.[ff]\" >> $pathnames
\tfind $srcroot -name \"*.[cc]\" >> $pathnames
\tfind $srcroot -name \"*.[hh]\" >> $pathnames

compile:
\t./$select_hosts " . $np/24 . " $mpdfile
\tcp -f $mpdfile $work/mpd.hosts
\t$caseroot/$compile
";
close(OUT);
