
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-09 14:39:57 BJT
; Last Change: 2014-10-28 14:53:18 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; add anormaly to a range of latitude
procedure add_an(outfile, lats, latn, mag, newold)
begin
  if (newold .eq. "new")
    orifile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn.nc"
    system("cp -f " + orifile + " " + outfile)
  end if

  f = addfile( outfile, "w" )
  bcu = f->bcu
  lat = f->lat

  torad = 3.14159265/180
  latc = (lats + latn) * 0.5 ; center lat
  latr = (latn - lats) * 0.5 ; range of lat
  an = mag * cos(90*(lat-latc)/latr*torad) 
  an = where(abs(lat-latc) .gt. latr, 0, an)
  bcu = bcu + conform(bcu, an, 1)

  f->bcu = bcu
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end

begin

  outfile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn_an_15S-15N.nc"
  add_an( outfile, -15, 15, -0.1, "new" )
;  add_an( outfile, -30, 0, -0.1, "old" )
;  add_an( outfile, 0, 30, 0.1, "old" )
;  add_an( outfile, 30, 60, -0.3, "old" )

end
