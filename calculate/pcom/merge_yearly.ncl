
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-02 19:21:58 BJT
; Last Change: 2014-11-16 10:24:32 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

out_dir = "/media/pcom/exp22_ws_control_re/"
in_dir  = out_dir + "yearly/"

yb = 1
ye = 64

fnames = " "
do yr = yb, ye
 fname = sprinti( "year_%0.4i.nc", yr )
 fnames = fnames + in_dir+fname + " "
 print("Processing " + fname + " ~ ~ ~ ~ ~ ~ ")
 f = addfile( in_dir + fname, "w")
 f->time@units = "years since 0-0-0 00:00:00"
 f->time = (/yr/)
 delete(f)
end do

cmd = "cdo mergetime " + fnames + " "+out_dir+"year_"+yb+"-"+ye+".nc"
print(cmd+"")
system(cmd)
