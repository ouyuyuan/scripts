
; Description: create cycling mn_re boundary condition
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-31 20:28:00 BJT
; Last Change: 2014-12-21 10:33:45 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function cycle_bcf(var)
local dims, nt, nlat, nlon, ny
begin
  dims = dimsizes(var)
  nt = dims(0)
  nlat = dims(1)
  nlon = dims(2)
  ny = nt/12

  do month = 1, 12
    i = month-1
    month_avg = dim_avg_n(var(i::12,:,:), 0)
    var(i::12,:,:) = conform_dims( (/ny,nlat,nlon/), month_avg, (/1,2/) )
  end do
  return var
end

begin
  orifile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re.nc"
  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle.nc"

  f = addfile( orifile, "r" )
  bcu = f->bcu
  bcv = f->bcv
  bct = f->bct
  bcs = f->bcs
  bcp = f->bcp
  emp = f->emp
  ddd = f->ddd
  delete(f)

  system("rm -f " + outfile)
  f = addfile( outfile, "c" )
  f->bcu = cycle_bcf(bcu)
  f->bcv = cycle_bcf(bcv)
  f->bct = cycle_bcf(bct)
  f->bcs = cycle_bcf(bcs)
  f->bcp = cycle_bcf(bcp)
  f->emp = cycle_bcf(emp)
  f->ddd = cycle_bcf(ddd)

  f@data = "Cycling monthly mean boundary conditon data"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
