
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-12-15 19:10:47 BJT
; Last Change: 2014-12-15 19:26:38 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  datDir = "/snfs01/ou/data/pcom/"
  inifile = datDir+"pcom_ini.nc"
  outfile = datDir+"pcom_ini_exp35.nc"

  f = addfile( inifile, "r" )
  itn = f->itn
  lat = f->lat
  delete(f)

  latc = conform(itn, lat, 0)
  itn = where(latc.gt.-35, 0, itn) ; only preserve southern ocean

  system("cp -f " + inifile + " " + outfile)
  f = addfile( outfile, "w" )
  f->itn = itn
end
