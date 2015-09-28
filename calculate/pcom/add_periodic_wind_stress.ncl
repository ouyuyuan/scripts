
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 14:39:57 BJT
; Last Change: 2014-11-09 10:49:17 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; add periodic anormaly to a range of latitude
procedure add_an(outfile, lats, latn, mag, period, newold)
begin
  if (newold .eq. "new")
    orifile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle.nc"
    system("cp -f " + orifile + " " + outfile)
  end if

  f = addfile( outfile, "w" )
  bcu = f->bcu
  lat = f->lat

  mon = floattoint(f->t)
  yr = (mon - 1)/12 + 1

  pi = 3.14159265
  torad = pi/180.0
  latc = (lats + latn) * 0.5 ; center lat
  latr = (latn - lats) * 0.5 ; range of lat
  an_x = mag * cos(90*(lat-latc)/latr*torad) 
  an_x = where(abs(lat-latc) .gt. latr, 0, an_x)
  an_t = sin(2.0*pi/period * yr) 
  an = conform(bcu, an_x, 1)*conform(bcu, an_t, 0)
  bcu = bcu + an

  f->bcu = bcu
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end

begin

;  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle_60S-30S_periodic.nc"
  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_re_cycle_30N-60N_periodic.nc"
; add periodic wind stress between 60S~30S with magnitude 0.3 dyne/cm^2 
;     and period 20 years
; add periodic wind stress between 30N~60N with magnitude 0.3 dyne/cm^2 
;     and period 20 years
;  add_an( outfile, -60, -30, 0.3, 20, "new" )
  add_an( outfile, 30, 60, 0.3, 20, "new" )
;  add_an( outfile, -30, 0, -0.1, "old" )
;  add_an( outfile, 0, 30, 0.1, "old" )
;  add_an( outfile, 30, 60, -0.3, "old" )

end
