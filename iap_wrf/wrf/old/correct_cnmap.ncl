load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"

begin

   data_dir = "/media/toshiba_02/radiation4/"
   draw_dir = "/home/kongxh/ou/drawings/wrf/"

   f = addfile(data_dir + "wrfout_d01_1997-12-30_03:00:00","r")
   times  = chartostring(f->Times)         ; convert to type string for plot
   lat2d = f->XLAT(0,:,:)
   lon2d = f->XLONG(0,:,:)

   time_rec = 15

   t = f->T2(15,:,:) - 273.15
   t@lat2d = lat2d
   t@lon2d = lon2d
   t@long_name = "TEMP at 2 M"
   t@units   =  "degrees celsius"

   wks         = gsn_open_wks("png",draw_dir + "correct_cnmap")

   res	=	True
   res@tiMainString          = times(time_rec)
	res@gsnSpreadColors         = True
	
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

   
   res@cnFillDrawOrder         = "PreDraw"
	res@cnFillOn                = True
	res@cnLinesOn               = False

   res@cnLevelSelectionMode = "ManualLevels"
   res@cnMaxLevelValF = 25.
   res@cnMinLevelValF = -40.
   res@cnLevelSpacingF = 5.

   res@gsnAddCyclic = False

	plot =gsn_csm_contour_map(wks,t,res)

end
