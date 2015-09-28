
; Description: ocean heat content
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 08:32:10 BJT
; Last Change: 2014-11-16 09:42:03 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; user input
;==========================================================
indir = "/media/pcom/exp22_ws_control_re/"
yrStrt = 1948
yrLast = 2008
ohc_long_name = "OHC in 0~700m"
data_desc = "Ocean Heat content in 0-700m, " + yrStrt + " to year " + yrLast
; create mask: dv
f = addfile("/home/ou/archive/data/pcom/grid_info.nc", "r")
dv = f->dv
idx = f->idx
z = f->z
delete(f)
zc = conform(dv, z, 0)
dv = where(zc.gt.700, 0, dv)
dv = where(idx.eq.1, dv, 0)

nc = addfile("/home/ou/archive/data/pcom/basin/basin.nc","r")
basin = nc->basin
delete(nc)
basinc = conform(dv, basin, (/1,2/))
dv_indian = where( basinc.eq.3, dv, 0 )
dv_pacific = where( basinc.eq.2, dv, 0 )
dv_atlantic = where( basinc.eq.6, dv, 0 )

; end of user input
;=========================================================

mb = (yrStrt - 1948)*12 + 1
me = (yrLast - 1948)*12 + 12

nmon = me - mb + 1
time = new(nmon, integer)
time@units = "months since 1947-12-15"
time@long_name = "Time"

global = new(nmon, float)
global@units = "J"
global@long_name = ohc_long_name

indian = new(nmon, float)
indian@units = "J"
indian@long_name = "Indian basin"

pacific = new(nmon, float)
pacific@units = "J"
pacific@long_name = "Pacific basin"

atlantic = new(nmon, float)
atlantic@units = "J"
atlantic@long_name = "Atlantic basin"

rho = 1029 ; kg/m^3, mean density of seawater
cp = 3901 ; c_p, heat capability, J/kg/K
do mon = mb, me 
  time(mon-1) = mon
  fname = indir + sprinti( "N%0.8i.nc", mon )
  print("Processing " + fname)
  f = addfile(fname, "r")
  pt = f->pt(0,:,:,:)
  delete(f)
  global(mon-1) = rho*cp*sum( pt*dv )
  indian(mon-1) = rho*cp*sum( pt*dv_indian )
  pacific(mon-1) = rho*cp*sum( pt*dv_pacific )
  atlantic(mon-1) = rho*cp*sum( pt*dv_atlantic )
end do

global!0 = "time"
global&time = time
indian!0 = "time"
indian&time = time
pacific!0 = "time"
pacific&time = time
atlantic!0 = "time"
atlantic&time = time

outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")
f->global = global
f->indian = indian
f->pacific = pacific
f->atlantic = atlantic

f@data = data_desc
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
