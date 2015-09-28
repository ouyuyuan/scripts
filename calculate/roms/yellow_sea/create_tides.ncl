
; Description: create tides file, adapted from tide_file.ncl from the website
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-08-18 19:17:08 BJT
; Last Change: 2014-08-18 19:41:13 BJT

begin
  data_dir = "/home/ou/archive/models/roms/roms_734/Apps/yellow_sea/in/"
  fname = data_dir + "tides_yellow_sea.nc"

  Lp = 82
  Mp = 82
  Ntc = 8

  system("rm -f "+fname)
  ncid = addfile(fname, "cw")

  tide_period = new((/Ntc/), double)

; For just M2
;  tide_name = (/ "M2" /)
;  tide_period = (/ 12.42060 /)
; For six constituents
;  tide_name = (/ "O1", "P1", "K1", "N2", "M2", "S2" /)
;  tide_period = (/ 25.81934, 24.06589, 23.93447, 12.65835, 12.42060, 12.0 /)

; For eight constituents
  tide_name = (/ "Q1", "O1", "P1", "K1", "N2", "M2", "S2", "K2" /)
  tide_period = (/ 26.868357, 25.81934, 24.06589, 23.93447, 12.65835, 12.42060, 12.0, 11.967235 /)

; Shouldn't need to change anything below here

  tide_Cangle = new((/Ntc, Mp, Lp/), double)
  tide_Cmax = new((/Ntc, Mp, Lp/), double)
  tide_Cmin = new((/Ntc, Mp, Lp/), double)
  tide_Cphase = new((/Ntc, Mp, Lp/), double)
  tide_Eamp = new((/Ntc, Mp, Lp/), double)
  tide_Ephase = new((/Ntc, Mp, Lp/), double)
  tide_period!0 = "tide_period"
  tide_period@units = "hours"
  tide_period@long_name = "tide angular period"
  tide_period@field = "tide_period, scalar"

; Fill in the values

  tide_Cangle!0 = "tide_period"
  tide_Cangle!1 = "eta_rho"
  tide_Cangle!2 = "xi_rho"
  tide_Cmax!0 = "tide_period"
  tide_Cmax!1 = "eta_rho"
  tide_Cmax!2 = "xi_rho"
  tide_Cmin!0 = "tide_period"
  tide_Cmin!1 = "eta_rho"
  tide_Cmin!2 = "xi_rho"
  tide_Cphase!0 = "tide_period"
  tide_Cphase!1 = "eta_rho"
  tide_Cphase!2 = "xi_rho"
  tide_Eamp!0 = "tide_period"
  tide_Eamp!1 = "eta_rho"
  tide_Eamp!2 = "xi_rho"
  tide_Ephase!0 = "tide_period"
  tide_Ephase!1 = "eta_rho"
  tide_Ephase!2 = "xi_rho"
  tide_name!0 = "tide_period"
  
  tide_Cangle@units = "degrees between semi-major axis and East"
  tide_Cangle@long_name = "tidal current inclination angle"
  tide_Cangle@field = "tide_Cangle, scalar"
  tide_Cmax@units = "meter second-1"
  tide_Cmax@long_name = "maximum tidal current, ellipse semi-major axis"
  tide_Cmax@field = "tide_Cmax, scalar"
  tide_Cmin@units = "meter second-1"
  tide_Cmin@long_name = "minimum tidal current, ellipse semi-minor axis"
  tide_Cmin@field = "tide_Cmin, scalar"
  tide_Cphase@units = "degrees, time of maximum velocity"
  tide_Cphase@long_name = "tidal current phase angle"
  tide_Cphase@field = "tide_Cphase, scalar"
  tide_Eamp@units = "meter"
  tide_Eamp@long_name = "tidal elevation amplitude"
  tide_Eamp@field = "tide_Eamp, scalar"
  tide_Ephase@units = "degrees, time of maximum elevation with respect chosen time origin"
  tide_Ephase@long_name = "tidal elevation phase angle"
  tide_Ephase@field = "tide_Ephase, scalar"

; global attributes
  fileAtt = True
  fileAtt@type = "FORCING File"
  fileAtt@creation_date = systemfunc("date")
  fileAtt@history = "Tides from Egbert and Ray"
  fileattdef(ncid, fileAtt)

; Write to file
  filedimdef(ncid, "namelen", 4, False)
  ncid->tide_period = tide_period
  ncid->tide_Eamp = tide_Eamp
  ncid->tide_Ephase = tide_Ephase
  ncid->tide_Cmax = tide_Cmax
  ncid->tide_Cmin = tide_Cmin
  ncid->tide_Cangle = tide_Cangle
  ncid->tide_Cphase = tide_Cphase

  dims = (/ "tide_period", "namelen" /)
  filevardef(ncid, "tide_name", "character", dims)
  do i=0,Ntc-1
    chars = stringtochar(tide_name(i))
    len = dimsizes(chars)
    ncid->tide_name(i,0:len-1) = chars
  end do

end
