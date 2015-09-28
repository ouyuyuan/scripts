
datDir    = getenv("NCL_ARG_1")
img       = getenv("NCL_ARG_2")
refDir    = "/home/ou/archive/data/pcom/exp_spinup/post/"

ncWs  = "calc_004_merge_ws_anom.nc"

ncVol = "calc_17_cn_lat_time_dv.nc"
ncOhc = "calc_001e_cn_depth_time_ohc.nc"

ncSsh = "calc_004b_merge_ssh.nc"
ncDtc = "calc_006b_dtc.nc"

ncBsf = "calc_006c_bsf.nc"
ncMoc = "calc_10b_moc_years.nc"

anTitle  = "C(~F8~j~F21~) at Eq.(1)"
volTitle = "water volume"
ohcTitle = "OHC"
sshTitle = "EOF, SSH"
dtcTitle = "EOF, DTC"
bsfTitle = "EOF, BSF"
mocTitle = "EOF, MOC"
