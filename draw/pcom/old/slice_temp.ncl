
; Description: slice of temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-04 09:02:17 CST
; Last Change: 2013-11-04 09:13:59 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

   ; variables <<<1

   draw_dir = "/home/ou/archive/drawing/pcom/assess/eps/t_res_monlong"
   data_dir = "/home/ou/archive/data"

   ; data files <<<1

   f_w = addfile(data_dir + "/woa09/temperature_annual_1deg.nc", "r")
   f_s = addfile(data_dir + "/climate/soda/climate_1981-2000.nc", "r")
   f_p = addfile(data_dir + "/climate/pcom/t_res_monlong/climate_031-050.nc", "r")
   f_l = addfile(data_dir + "/climate/licom/unmodified/climate_081-100.nc", "r")

   ; main res. <<<1

   res = True

   ; gsn <<<2
   ;
   res@gsnDraw = False
   res@gsnFrame = False
;   res@gsnMaximize = True
   res@gsnSpreadColors      = True               ; use full color map
   res@gsnSpreadColorStart  = 30                 ; start at color 17
   res@gsnSpreadColorEnd    = 240                ; end at color 200
   res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 

   ; contour <<<2
   ;
   res@cnFillOn             = True               ; turn on color for contours
   res@cnLinesOn            = False              ; turn off contour lines
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnInfoLabelOn        = False      ; turns off contour info label

   ; label bar <<<2

   res@lbLabelBarOn = False
   res@lbOrientation            = "Vertical"     ; vertical label bar
   res@lbPerimOn                = False             ; no box around it
   ;    res@lbLabelStride            = 4

   ; plot manager <<<2

   ;    res@pmLabelBarDisplayMode    = "Always"          ; Turn on a label bar.
   ;    res@pmLabelBarWidthF         = 0.08              ; make it thinner
   res@pmLabelBarOrthogonalPosF = -0.04          ; move label bar closer

   ; tick mark  <<<2

   res@tmLabelAutoStride = True
   res@tmYROn = False
   res@tmXTOn = False
;   res@tmYLMode = "Manual"
;   res@tmYLTickStartF    = 100.
;   res@tmYLTickSpacingF  = 100.
;   res@tmXBMode = "Manual"
;   res@tmXBTickSpacingF = 5
;   res@tmXBTickStartF    = -25
;   res@tmXBTickEndF      = 25
;   res@tmYLTickEndF      = 300.

   ; transformation <<<2

   res@trYMaxF = 500.
;   res@trXMaxF = 25
;   res@trXMinF = -25
   res@trYReverse               = True   ; reverses y-axis

   ; overlay res. <<<1

   sres = True
   sres@cnFillOn             = False
   sres@cnLinesOn            = True
   sres@cnLevelSelectionMode = "ExplicitLevels"
   sres@cnLevels = (/20/)
   sres@cnLineThicknessF = 2.0

   ; lon string to integer <<<1

   function lon_str2int(str:string)
   local num_str, id, lon
   begin
      num_str = str_get_cols(str, 0, -2)
      id = str_get_cols(str, -1, -1)
      if (id .eq. "E") then
         lon = stringtointeger(num_str)
      else if (id .eq. "W") then
         lon = 360 - stringtointeger(num_str)
      else
         print("Warning: unrecognized suffix of lon string")
      end if
      end if
      return (lon)
   end

   ; lat string to integer <<<1

   function lat_str2int(str:string)
   local num_str, id, lat
   begin
      num_str = str_get_cols(str, 0, -2)
      id = str_get_cols(str, -1, -1)
      if (id .eq. "N") then
         lat = stringtointeger(num_str)
      else if (id .eq. "S") then
         lat = -stringtointeger(num_str)
      else
         print("Warning: unrecognized suffix of lat string")
      end if
      end if
      return (lat)
   end

