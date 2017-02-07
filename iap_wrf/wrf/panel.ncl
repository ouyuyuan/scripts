
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

   ; dirs and files <<<1

   data_dir_thc = "/home/kongxh/process_data/data/"
   data_dir_wrf = "/media/toshiba_02/radiation4/"
   draw_dir = "/home/kongxh/ou/drawings/wrf/"

	f_thc=addfile(data_dir_thc + "air.2m.1998.nc", "r")
   f_wrf=addfile(data_dir_wrf + "wrfout_d01_1997-12-30_03:00:00", "r")

   ; data fiels <<<1

   t = f_thc->air(0,:,:)
   t_thc =  t*0.01 + 427.66 - 273.15
   copy_VarCoords(t, t_thc)
   t_thc@units   =  "degrees celsius"

   t_wrf = f_wrf->T2(15,:,:) - 273.15
   t_wrf@lat2d = f_wrf->XLAT(0,:,:)
   t_wrf@lon2d = f_wrf->XLONG(0,:,:)
   t_wrf@units   =  "degrees celsius"
   
   ; workstation <<<1

   wks  = gsn_open_wks("png", draw_dir + "panel")
;   gsn_define_colormap(wks,"matlab_jet")

   ; res <<<1

   res	=	True

   ; gsn <<<2

   res@gsnDraw                 = False
   res@gsnFrame                = False
	res@gsnSpreadColors         = True
   res@gsnAddCyclic = False
   ;res@gsnSpreadColorStart = 6
	;res@gsnSpreadColorEnd  = 60
	
   ; map <<<2

   res@mpMinLatF               = 17.
   res@mpMaxLatF               = 55.
   res@mpMinLonF               = 72.
   res@mpMaxLonF               = 136.
 
   res@mpFillOn                = True
   res@mpOutlineOn             = False

   res@mpDataBaseVersion       = "MediumRes"
   res@mpDataSetName           = "Earth..4"
   res@mpAreaMaskingOn         = True
   res@mpMaskAreaSpecifiers    = (/"China","Taiwan","Disputed area between India and China","India:Arunachal Pradesh"/)
   res@mpLandFillColor         = "white"
   res@mpInlandWaterFillColor  = "white"
   res@mpOceanFillColor        = "white"
   res@mpOutlineBoundarySets   = "NoBoundaries"

   ; contour <<<2

   res@cnFillDrawOrder         = "PreDraw"
	res@cnFillOn                = True
	res@cnLinesOn               = False
   res@cnLineLabelsOn       = False              ; turn off contour line labels
   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF = 25.
   res@cnMinLevelValF = -40.
   res@cnLevelSpacingF = 5.

   ; label bar <<<2

   res@lbLabelBarOn  =  False

   ; gsn plots <<<1

   plot  =  new(2,graphic)
   res@tiMainString            ="20thc"
	plot(0)=gsn_csm_contour_map(wks,t_thc,res)
   res@tiMainString            ="WRF"
   plot(1)=gsn_csm_contour_map(wks,t_wrf,res)

   ; South China Sea <<<1

   cnres           = True
	cnres@china     = True  
	cnres@river     = True 
	cnres@province  = False
	cnres@nanhai    = True 
	cnres@diqu      = False 
   chinamap = add_china_map(wks,plot(0),cnres)
;   chinamap = add_china_map(wks,plot(1),cnres)

   ; panel plot <<<1

   resP  =  True
   resP@txString  =  "Temperatrue at 2 M"

   resP@gsnPanelLabelBar   =  True
   resP@gsnPanelYWhiteSpacePercent = 10

   resP@pmLabelBarWidthF = 0.7
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.02          ; move label bar closer

   resP@lbLabelFontHeightF = 0.015
   resP@lbLabelAutoStride = True

	gsn_panel(wks,plot,(/2,1/),resP)

end
