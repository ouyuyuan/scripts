
; Description: modify the basin created by scripts from
;              http://www.ncl.ucar.edu/Applications/popmask.shtml
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-10 19:42:27 BJT
; Last Change: 2014-11-10 20:20:01 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/data/pcom/"
  infile = data_dir + "basin/popMask.PCOM.nc"
  inifile = data_dir+"input/pcom_ini.nc"
  outfile  = data_dir+"basin/basin.nc"

  f = addfile( inifile, "r" )
  seamask = f->itn
  delete(f)

  f = addfile( infile, "r" )
  basin = f->GMASK
  delete(f)
  
  basin = where(seamask.eq.0, basin@_FillValue, basin)

  system("rm -f "+outfile)
  f = addfile( outfile, "c" )
  f->basin = basin
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
