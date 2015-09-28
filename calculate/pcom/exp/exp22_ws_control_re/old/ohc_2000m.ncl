
; Description: ocean heat content
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 08:32:10 BJT
; Last Change: 2014-11-16 09:02:19 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; user input
;==========================================================
indir = "/media/pcom/exp22_ws_control_re/"
yrStrt = 1948
yrLast = 2008
ohc_long_name = "OHC in 0~2000m"
data_desc = "Ocean Heat content in 0-2000m, " + yrStrt + " to year " + yrLast

; create mask: dv
f = addfile("/home/ou/archive/data/pcom/grid_info.nc", "r")
dv = f->dv
idx = f->idx
z = f->z
delete(f)
zc = conform(dv, z, 0)
dv = where(zc.gt.2000, 0, dv)
dv = where(idx.eq.1, dv, 0)

; end of user input
;=========================================================

mb = (yrStrt - 1948)*12 + 1
me = (yrLast - 1948)*12 + 12

nmon = me - mb + 1
time = new(nmon, integer)
time@units = "months since 1947-12-15"
time@long_name = "Time"

ohc = new(nmon, float)
ohc@units = "J"
ohc@long_name = ohc_long_name

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K
do mon = mb, me 
  time(mon-1) = mon
  fname = indir + sprinti( "N%0.8i.nc", mon )
  print("Processing " + fname)
  f = addfile(fname, "r")
  pt = f->pt(0,:,:,:)
  delete(f)
  ohc(mon-1) = rho*cp*sum( pt*dv )
end do

ohc!0 = "time"
ohc&time = time

outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")
f->ohc = ohc
f@data = data_desc
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
