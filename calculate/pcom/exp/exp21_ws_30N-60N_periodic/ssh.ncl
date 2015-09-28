
; Description: extract ssh from yearly files
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-24 19:43:19 BJT
; Last Change: 2014-12-01 07:50:41 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

datDir = getenv("NCL_ARG_1")

yb = 1
ye = 120
ny = ye-yb+1

time = new(ny, integer)
time@units = "years since 0500-01-01"
time@long_name = "time"

do yr = yb, ye
  ifname = datDir+"../yearly/"+sprinti( "year_%0.4i.nc", yr )
  nc = addfile(ifname, "r")
  ssh0 = nc->ssh(0,:,:)
  delete(nc)
  time(yr-yb) = yr

  if (yr .eq. yb) then
    dims = dimsizes(ssh0)
    nlat = dims(0)
    nlon = dims(1)
    ssh = new((/ny, nlat, nlon/), float)
    copy_VarAtts(ssh0, ssh)
    ssh!1 = "lat"
    ssh!2 = "lon"
    ssh&lat = ssh0&lat
    ssh&lon = ssh0&lon
  end if
  ssh(yr-yb,:,:) = ssh0
end do

ssh!0 = "time"
ssh&time = time

outfile = datDir+getenv("NCL_ARG_0_base")+".nc"
system("rm -f " + outfile)
f = addfile(outfile, "c")
filedimdef(f, "time", -1, True)
f->ssh = ssh
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
