
; Description: cal. summer precipitation
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-29 20:26:52 CST
; Last Change: 2013-11-30 22:03:41 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

   ; dirs and files <<<1

   thc_dir = "/media/TOSHIBA/OBS/precip/1998/"

   rad3_dir = "/media/toshiba_02/radiation3/post_process/"
   rad4_dir = "/media/toshiba_02/radiation4/"
   rad5_dir = "/media/toshiba_02/radiation5/"

   draw_dir = "/home/kongxh/ou/drawings/wrf/"

   thc = addfile(thc_dir + "prate.1998.nc","r")

   rad3 = addfile(rad3_dir + "rainc.nc","r")
  
   ; data fields <<<1

   ; thc <<<2

   hour_begin = ut_inv_calendar( 1998, 06, 01, 00, 00, 00,  "hours since 1800-1-1 00:00:0.0", 0 )
   hour_end = ut_inv_calendar( 1998, 08, 31, 21, 00, 00,  "hours since 1800-1-1 00:00:0.0", 0 )
   ; check original cal.
;   print(0 + hour_begin)
;   print(0 + hour_end)
;   time = thc->time
;   print( 0 + time(1208) )
;   print( 0 + time(1943) )
   p = thc->prate({hour_begin:hour_end},:,:)
   p_new = p*p@scale_factor + p@add_offset
   p_avg =  dim_avg_n_Wrap(p_new, 0) 
;   p_mm = p_avg*3600*24/10^3*1000
   p_mm = p_avg*3600*24

   p_mm@long_name = "precipitation"
   p_mm@units = "mm/day"
   copy_VarCoords(p(0,:,:), p_mm)

   ; wrf  <<<2

   lat2d = rad3->XLAT(:,:)
   lon2d = rad3->XLONG(:,:)
   dims = dimsizes(lat2d)
   ny = dims(0)
   nx = dims(1)

   a = rad3->RAINC({19980601:19980901},:,:)
   nt = dimsizes( a(:,0,0) )
   do i = 0, nt - 2
      do j = 0, ny - 1
         do k = 0, nx - 1
            a(i,j,k) = a(i+1,j,k) - a(i,j,k)
            if ( a(i,j,k) .le. 0.0 ) then
               a(i,j,k) = a(i,j,k) + 100
            end if
         end do
      end do
   end do

   ; wks <<<1

   type = "png"
   wks = gsn_open_wks(type, draw_dir + "precip_summer")

   ; res.  <<<1

   res                       = True        ; plot mods desired
   res@tiMainString          = "Average precipitation in Summer"

   ; gsn <<<2

   res@gsnAddCyclic          = False       ; regional data: not cyclic 
   res@gsnDraw                 = False
   res@gsnFrame                = False

   ; contour <<<2

   res@cnFillDrawOrder         = "PreDraw"  ; needed for China map
   res@cnFillOn = True                        ; Create a color fill plot
	res@cnLinesOn               = False
;   res@cnLevelSelectionMode = "ManualLevels"
;   res@cnMaxLevelValF = 25.
;   res@cnMinLevelValF = -40.
;   res@cnLevelSpacingF = 5.

   ; tick mark <<<2

   res@tmXTOn = False
   res@tmXBOn = False
   res@tmYLOn = False
   res@tmYROn = False

   ; plot manager  <<<2

   res@pmTickMarkDisplayMode = "Never"

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

   ; gsn plot <<<1

;   plot                      = gsn_csm_contour_map(wks, p_mm, res)
   plot  =  new(4,graphic)
   res@tiMainString            ="20thc"
;   plot(0)=gsn_csm_contour_map(wks, p_mm, res)
;   res@tiMainString            ="WRF radiation3"
;   plot(1)=gsn_csm_contour_map(wks, p_mm, res)
;   res@tiMainString            ="WRF radiation4"
;   plot(2)=gsn_csm_contour_map(wks, p_mm, res)
;   res@tiMainString            ="WRF radiation5"
;   plot(3)=gsn_csm_contour_map(wks, p_mm, res)

   ; South Chnia Sea <<<1

   cnres           = True
	cnres@china     = True  
	cnres@river     = True 
	cnres@province  = False
	cnres@nanhai    = True 
	cnres@diqu      = False
;   chinamap = add_china_map(wks, plot, cnres)

   ; panel plot <<<1

   resP  =  True
   resP@txString  =  "Average precipitation in Summer"

   resP@gsnPanelLabelBar   =  True
   resP@gsnPanelXWhiteSpacePercent = 10
   resP@gsnPanelYWhiteSpacePercent = 10

   resP@pmLabelBarWidthF = 0.7
   resP@pmLabelBarHeightF = 0.05
   resP@pmLabelBarOrthogonalPosF = -0.02          ; move label bar closer

   resP@lbLabelFontHeightF = 0.015
   resP@lbLabelAutoStride = True

;   gsn_panel(wks,plot,(/2,2/),resP)

;   draw(plot)
;   frame(wks)
end
