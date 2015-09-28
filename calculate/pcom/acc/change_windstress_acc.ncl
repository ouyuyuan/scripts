
; Description: move wind south of 50S
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 14:39:57 BJT
; Last Change: 2014-11-25 18:52:48 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
;  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_acc_no_ws.nc"
  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_acc_no_ws_S.nc"
  orifile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn.nc"
  system("cp -f " + orifile + " " + outfile)

  f = addfile( outfile, "w" )
  bcu = f->bcu
  bcv = f->bcv
  lat = f->lat

  latc = conform(bcu, lat, 1)
  latc@_FillValue = bcu@_FillValue
  latc = where(ismissing(bcu), bcu@_FillValue, latc)
  bcu = where(latc .lt. -0.0, 0, bcu)
  bcv = where(latc .lt. -0.0, 0, bcv)

  f->bcu = bcu
  f->bcv = bcv
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
