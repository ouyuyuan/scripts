
; Description: extract latitude sections of potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-28 08:04:29 BJT
; Last Change: 2014-11-14 09:36:23 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function get_lat_sec(filename, varname, latsec)
local f, t1, t2, lat1, lat2
begin
  f = addfile( filename, "r" )
  if isinteger(latsec) ; pcom's lat is half-integer
    lat1 = latsec - 0.5
    lat2 = latsec + 0.5
    t1 = f->$varname$(:,{lat1},:)
    t2 = f->$varname$(:,{lat2},:)
    t = t1
    t@lat = latsec
    t = ( t1 + t2 ) * 0.5
  else
    t = f->$varname$(:,{latsec},:)
  end if
  return t
end

procedure write_pt(f, filename, prefix, lat)
local name
begin
  if (lat .lt. 0) then
    name = prefix + "_" + abs(lat) + "S"
  else 
    name = prefix + "_" + lat + "N"
  end if

  f->$name$ = get_lat_sec(filename, "pt", lat)
end

begin

  outfile = getenv("NCL_ARG_1")
  system("rm -f " + outfile)
  f = addfile(outfile, "c")

  dir = "/home/ou/archive/data/pcom/"
  clm = "climate_y541-y550.nc"

  write_pt(f, dir+"exp08_fkh1/"+clm, "control", 45)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", 15)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", 5)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", 0)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", -15)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", -45)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", -25)
  write_pt(f, dir+"exp08_fkh1/"+clm, "control", -50)

  write_pt(f, dir+"exp10_ws_sh/"+clm, "an_70S30S", -50)
  write_pt(f, dir+"exp11_ws_nh/"+clm, "an_30N60N", 45)
  write_pt(f, dir+"exp12_ws_sm/"+clm, "an_40S10S", -25)
  write_pt(f, dir+"exp13_ws_nm/"+clm, "an_EQ30N", 15)
  write_pt(f, dir+"exp14_ws_eq/"+clm, "an_10S20N", 5)

  write_pt(f, dir+"exp15_ws_60S-60N/"+clm, "an_60S60N", 45)
  write_pt(f, dir+"exp15_ws_60S-60N/"+clm, "an_60S60N", 15)
  write_pt(f, dir+"exp15_ws_60S-60N/"+clm, "an_60S60N", 0)
  write_pt(f, dir+"exp15_ws_60S-60N/"+clm, "an_60S60N", -15)
  write_pt(f, dir+"exp15_ws_60S-60N/"+clm, "an_60S60N", -45)

  write_pt(f, dir+"exp16_ws_15S-15N/"+clm, "an_15S15N", 0)

  clm = "climate_y55-y64.nc"
  write_pt(f, dir+"exp17_ws_control_cycle_re/"+clm, "ctr64", 0)
  write_pt(f, dir+"exp18_ws_an_ao/"+clm, "an_ao", 0)

  f@data = "potential temperature at latitude sections"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)

end
