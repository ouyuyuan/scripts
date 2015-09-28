
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-10 09:25:11 BJT
; Last Change: 2014-10-24 16:41:13 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure add_lat_lon( v )
begin
  v!0 = "lat"
  v!1 = "lon"
  v&lat = lat
  v&lon = lon
end

begin

  outfile = getenv("NCL_ARG_1")

  infile = "/home/ou/archive/data/pcom/input/pcom_bcf_mn.nc"
  f = addfile( infile, "r" )
  lat = f->lat
  lon = f->lon
  bcu = f->bcu
  bcv = f->bcv
  delete(f)

  bcu = bcu*0.1 ; change dyne/cm^2 to N/m^2 (1 dyne = 10^-5 N)
  bcv = bcv*0.1
  bcu@units = "N/m^2"
  bcv@units = "N/m^2"

  vx = dim_avg_n_Wrap(bcu, 0)
  vy = dim_avg_n_Wrap(bcv, 0)

  mag = sqrt(vx*vx + vy*vy)
  mag@long_name = "magnitude of wind stress vector"
  mag@units = "N/m^2"
  mag!0 = "lat"
  mag!1 = "lon"
  mag&lat = lat
  mag&lon = lon

  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->taux = vx
  f->tauy = vy
  f->mag = mag
  f@data = "year mean wind stress frocing of PCOM"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

end
