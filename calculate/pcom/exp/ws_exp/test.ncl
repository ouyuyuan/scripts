
; Description: calculate ocean heat content
;              ohc = rho cp integrate(T) dz, T in Kelvin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-12 08:32:10 BJT
; Last Change: 2014-12-02 16:28:15 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; calc. ohc by volume integration
function cal_ohc(pt, dv, desc, type)
begin
  rho = 1029 ; kg/m^3, mean density of seawater
  cp = 3901 ; c_p, heat capability, J/kg/K

  time = pt&time
  nt = dimsizes(time)
  ohc = new(nt, typeof(pt))
  ohc@units = "J"
  ohc@long_name = desc
  ohc!0 = "time"
  ohc&time = time

  do it = 0, nt-1
    if (type.eq."depth") then
      ohc(it) = rho*cp*sum( pt(it,:,:,:)*dv )
    else if (type.eq."20degC") then
      ptmask = pt(it,:,:,:)
      ptmask = mask(ptmask, ptmask.ge.20, True)
      ohc(it) = rho*cp*sum( ptmask*dv )
    else
      print("unkown type: " + "type")
      exit
    end if
    end if
  end do

  return ohc
end

procedure process_file(infile, f, prefix)
begin
  print("processing "+infile+" ~ ~ ~ ~ ~ ~")

  nc = addfile(infile,"r")
  pt = nc->pt
  delete(nc)

  infile = "/home/ou/archive/data/pcom/basin/basin.nc"
  nc = addfile(infile, "r")
  basin = nc->basin
  delete(nc)

  infile = "/home/ou/archive/data/pcom/grid_info.nc"
  nc = addfile(infile, "r")
  dv_ori = nc->dv
  idx = nc->idx
  delete(nc)

  zc = conform(dv_ori, pt&z, 0) 
  latc = conform(dv_ori, pt&lat, 1) 
  basinc = conform(dv_ori, basin, (/1,2/))

  ; global ocean, all depth
  varname = prefix+"_all"
  dv = mask(dv_ori, idx.eq.1, True)
  f->$varname$ = cal_ohc(pt, dv, "global, all depth", "depth")

  ; global, 0-700m
  varname = prefix+"_700"
  dv = mask(dv_ori, (idx.eq.1 .and. zc.le.700), True)
  f->$varname$ = cal_ohc(pt, dv, "global, 0-700m", "depth")

  ; global, 0-2000m
  varname = prefix+"_2000"
  dv = mask(dv_ori, (idx.eq.1 .and. zc.le.2000), True)
  f->$varname$ = cal_ohc(pt, dv, "global, 0-2000m", "depth")

  ; above 20 degC, global
  varname = prefix+"_20deg_g"
  dv = mask(dv_ori, (idx.eq.1), True)
  f->$varname$ = cal_ohc(pt, dv, "global, above 20 degC", "20degC")

  ; above 20 degC, Indian
  varname = prefix+"_20deg_i"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 3), True)
  f->$varname$ = cal_ohc(pt, dv, "Indian Ocean, above 20 degC", "20degC")
  varname = prefix+"_20deg_i_N"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 3 .and. latc.gt.0), True)
  f->$varname$ = cal_ohc(pt, dv, "Indian Ocean, above 20 degC, north hemisphere", "20degC")
  varname = prefix+"_20deg_i_S"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 3 .and. latc.lt.0), True)
  f->$varname$ = cal_ohc(pt, dv, "Indian Ocean, above 20 degC, sourth hemisphere", "20degC")

  ; above 20 degC, Pacific
  varname = prefix+"_20deg_p"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 2), True)
  f->$varname$ = cal_ohc(pt, dv, "Pacific Ocean, above 20 degC", "20degC")
  varname = prefix+"_20deg_p_t"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 2 .and. abs(latc).le.10), True)
  f->$varname$ = cal_ohc(pt, dv, "Pacific Ocean, above 20 degC, 10S-10N", "20degC")
  varname = prefix+"_20deg_p_nt"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 2 .and. latc.gt.10), True)
  f->$varname$ = cal_ohc(pt, dv, "Pacific Ocean, above 20 degC, north of 10N", "20degC")
  varname = prefix+"_20deg_p_st"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 2 .and. latc.lt.-10), True)
  f->$varname$ = cal_ohc(pt, dv, "Pacific Ocean, above 20 degC, sourth of 10S", "20degC")

  ; above 20 degC, Atlantic
  varname = prefix+"_20deg_a"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 6), True)
  f->$varname$ = cal_ohc(pt, dv, "Atlantic Ocean, above 20 degC", "20degC")
  varname = prefix+"_20deg_a_t"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 6 .and. abs(latc).le.10), True)
  f->$varname$ = cal_ohc(pt, dv, "Atlantic Ocean, above 20 degC, 10S-10N", "20degC")
  varname = prefix+"_20deg_a_nt"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 6 .and. latc.gt.10), True)
  f->$varname$ = cal_ohc(pt, dv, "Atlantic Ocean, above 20 degC, north of 10N", "20degC")
  varname = prefix+"_20deg_a_st"
  dv = mask(dv_ori, (idx.eq.1 .and. basinc .eq. 6 .and. latc.lt.-10), True)
  f->$varname$ = cal_ohc(pt, dv, "Atlantic Ocean, above 20 degC, sourth of 10S", "20degC")

end

outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")

indir = "/home/ou/archive/data/pcom/"
clm = "year_1-64.nc"

; control run
;=============
infile = indir+"exp17_ws_control_cycle_re/"+clm
process_file(infile, f, "ctr64")

; exp_ao
;===============
infile = indir+"exp18_ws_an_ao/"+clm
process_file(infile, f, "an_ao")

; exp21_ws_30N-60N_periodic
;==============================
infile = indir+"exp21_ws_30N-60N_periodic/"+clm
process_file(infile, f, "an_30N60N_p")

