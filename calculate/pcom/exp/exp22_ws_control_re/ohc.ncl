
; Description: ocean heat content
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 08:32:10 BJT
; Last Change: 2014-11-16 17:42:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

procedure cal_ohc(arg)
begin
  indir = "/media/pcom/exp22_ws_control_re/"
  yrStrt = 1948
  yrLast = 2008

  depth = arg@depth
  ohc_long_name = "OHC"
  basinName = arg@basin

  outfile = getenv("NCL_ARG_1")
  outfile = outfile+"_"+depth+"_"+basinName+".nc"

  ; end of user input
  ;=========================================================

  ; create mask: dv
  f = addfile("/home/ou/archive/data/pcom/grid_info.nc", "r")
  dv = f->dv
  idx = f->idx
  z = f->z
  delete(f)
  zc = conform(dv, z, 0)
  dv = where(zc.gt.depth, 0, dv)
  dv = where(idx.eq.1, dv, 0)

  nc = addfile("/home/ou/archive/data/pcom/basin/basin.nc","r")
  basin = nc->basin
  delete(nc)
  basinc = conform(dv, basin, (/1,2/))

  if (basinName.eq."glo") then
    data_desc = "0~"+depth+"m, Global"
  else if (basinName.eq."Ind") then
    data_desc = "0~"+depth+"m, Indian Ocean"
    dv = where( basinc.eq.3, dv, 0 ) ; Indian Ocean
  else if (basinName.eq."Pac") then
    data_desc = "0~"+depth+"m, Pacific Ocean"
    dv = where( basinc.eq.2, dv, 0 ) ; Indian Ocean
  else if (basinName.eq."Atl") then
    data_desc = "0~"+depth+"m, Pacific Ocean"
    dv = where( basinc.eq.6, dv, 0 ) ; Indian Ocean
  else if (basinName.eq."Sou") then
    data_desc = "0~"+depth+"m, Southern Ocean"
    dv = where( basinc.eq.1, dv, 0 ) ; Southern Ocean
  end if
  end if
  end if
  end if
  end if

  mb = (yrStrt - 1948)*12 + 1
  me = (yrLast - 1948)*12 + 12

  nmon = me - mb + 1
  time = new(nmon, integer)
  time@units = "months since 1947-12-15"
  time@long_name = "Time"

  ohc = new(nmon, float)
  ohc@units = "J"
  ohc@long_name = ohc_long_name

  rho = 1029 ; kg/m^3, mean density of seawater
  cp = 3901 ; c_p, heat capability, J/kg/K
  do mon = mb, me 
    time(mon-1) = mon
    fname = indir + sprinti( "N%0.8i.nc", mon )
    print("Processing " + fname)
    f = addfile(fname, "r")
    pt = f->pt(0,:,:,:)
    delete(f)
    ohc(mon-1) = rho*cp*sum( pt*dv )
  end do

  ohc!0 = "time"
  ohc&time = time

  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->ohc = ohc
  f@data = data_desc
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
    ", " + systemfunc("date")
end

arg = True

; 0~700m
;=====================
arg@depth = 700

;arg@basin = "Glo"
;cal_ohc(arg)

;arg@basin = "Ind"
;cal_ohc(arg)

;arg@basin = "Pac"
;cal_ohc(arg)

;arg@basin = "Atl"
;cal_ohc(arg)

arg@basin = "Sou"
cal_ohc(arg)

; 0~1500m
;=====================
arg@depth = 1500

;arg@basin = "Glo"
;cal_ohc(arg)

;arg@basin = "Ind"
;cal_ohc(arg)

;arg@basin = "Pac"
;cal_ohc(arg)

;arg@basin = "Atl"
;cal_ohc(arg)

arg@basin = "Sou"
cal_ohc(arg)
