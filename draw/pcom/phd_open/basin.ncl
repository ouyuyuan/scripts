
; Description: dot a basin
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-03-14 18:25:34 BJT
; Last Change: 2015-01-17 20:33:05 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;   data_dir = "/home/ou/archive/data/"
   data_dir = "/home/ou/archive/data/pcom/basin/"
   draw_dir = "/home/ou/archive/drawing/pcom/phd_open/"

  basin_index = 1
   str = "basin.nc"
;   str = "basin_hand.nc"
;   str = "basin_interp.nc"
;   str = "basin_change_rect.nc"
;   filename = data_dir + "licom/" + str
;   filename = data_dir + "pcom/" + str
;   filename = data_dir + "soda/" + str
   filename = data_dir + str
   f = addfile(filename, "r")
   basin = f->basin
   delete(f)

   lat = conform(basin, basin&lat, 0)
   lon = conform(basin, basin&lon, 1)

   FillValue = -999.999
   lat = where(basin.eq.basin_index, lat, FillValue)
   lon = where(basin.eq.basin_index, lon, FillValue)
   lat@_FillValue = FillValue
   lon@_FillValue = FillValue

   img = draw_dir + str_sub_str( getenv("NCL_ARG_0"),".ncl","" )
   wks = gsn_open_wks("eps", img)

   res = True
   res@gsnFrame = False
   res@mpCenterLonF = 180
   res@mpFillColor = "black"
;   res@mpMinLatF = 30
;   res@mpMaxLatF = 50
;   res@mpMinLonF = 120 
;   res@mpMaxLonF = 180

   map = gsn_csm_map(wks, res)
;   map = gsn_map(wks, "LambertConformal", res)
;   map = gsn_map(wks, "CylindricalEquidistant", res)
   
   mkres = True
   mkres@gsMarkerIndex = 2
   mkres@gsMarkerColor = "blue"
   mkres@gsMarkerSizeF = 0.003
   
   dum = gsn_add_polymarker(wks, map, lon, lat, mkres)

   draw(map)
   frame(wks)
end
