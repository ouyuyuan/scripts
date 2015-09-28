
; Description: AAO index to nc file
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-06 20:37:58 BJT
; Last Change: 2014-12-22 20:36:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  dir = "/home/ou/archive/data/enso_ao_aao/"
  fname = "monthly.aao.index.b79.current"
  asc = dir+fname+".ascii"
  outFile = dir+fname+".nc"

  nrow = numAsciiRow(asc)
  ncol = numAsciiCol(asc)

  dat = asciiread(asc, (/nrow, ncol/), "float")
  yr = floattoint(dat(:,0))
  mn = floattoint(dat(:,1))
  dy = mn
  dy = 15
  hr = mn*0
  mi = mn*0
  se = mn*0

  time_units = "months from 1978-12-15 00:00:00"
;  time = doubletoint(cd_inv_calendar(yr, mn, dy, hr, mi, se, time_units, 0))
  time = cd_inv_calendar(yr, mn, dy, hr, mi, se, time_units, 0)
  time@units = time_units

  idx = dat(:,2)
  idx@long_name = "AAO index from CPC"
  idx@units = ""
  idx!0 = "time"
  idx&time = time

  system("rm -f "+outFile)
  f = addfile(outFile, "c")
  filedimdef(f, "time", -1, True)
  f->idx = idx
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
