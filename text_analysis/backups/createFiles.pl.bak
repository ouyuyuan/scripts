#!/usr/bin/perl -w

# Description: create namelists from model config. file 
#
#       Usage: 
#
#      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
#     Created: 2013-01-26 20:04:00 CST
# Last Change: 2013-01-27 14:06:02 CST

use 5.010;
use strict;
use Cwd;
use File::Basename;
use configFunc;

# def vars <<<1

my $namelists = "namelists";
my $env       = "env";
my $res       = &get_setting("resolution");
my $np        = &get_setting("processor number");

# namelists <<<1

my $layout = int(sqrt($np/6));

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

open OUT, ">$namelists";
say OUT "
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

# env <<<1

open OUT, ">$env";
say OUT "
setenv CASE " . &get_setting("case name") . "
setenv PLAT " . &get_setting("platform")  . "
setenv RES $res
setenv NP $np

setenv FAMILROOT       unset
setenv UTILSROOT       unset
setenv SRCROOT         unset
setenv INPUTROOT       unset

setenv CASEROOT        unset
setenv RUNROOT         unset

setenv PREP            unset
setenv POSTP           unset

setenv EXE1DIR         unset
setenv EXE2DIR         unset
setenv WORKDIR         unset
setenv DATADIR         unset
setenv DIAGDIR         unset

setenv NETCDFPATH      unset
setenv HDF5PATH        unset
setenv ZLIBPATH        unset
setenv NCOPATH         unset
setenv MPIPATH         unset
setenv MPI_INCLUDE     unset
setenv MPI_LIB         unset
setenv MPI_BIN         unset
setenv FORPATH         unset
setenv FOR_INCLUDE     unset
setenv FOR_LIB         unset
setenv FOR_BIN         unset
setenv CCPATH          unset
setenv CC_INCLUDE      unset
setenv CC_LIB          unset
setenv CC_BIN          unset

setenv LD_LIBRARY_PATH unset
