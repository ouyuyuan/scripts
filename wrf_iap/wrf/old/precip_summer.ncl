
; Description: cal. summer precipitation
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-11-29 20:26:52 CST
; Last Change: 2013-11-30 20:33:27 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

   ; dirs and files <<<1

   thc_dir = "/media/TOSHIBA/OBS/precip/1998/"

   rad3_dir = "/media/toshiba_02/radiation3/"
   rad4_dir = "/media/toshiba_02/radiation4/"
   rad5_dir = "/media/toshiba_02/radiation5/"

   draw_dir = "/home/kongxh/ou/drawings/wrf/"

   thc = addfile(thc_dir + "prate.1998.nc","r")
  
   rad3_May = addfile(rad3_dir + "wrfout_d01_1998-05-29_00:00:00","r")
   rad3_Jun = addfile(rad3_dir + "wrfout_d01_1998-06-28_00:00:00","r")
   rad3_Jul = addfile(rad3_dir + "wrfout_d01_1998-07-28_00:00:00","r")
   rad3_Aug = addfile(rad3_dir + "wrfout_d01_1998-08-27_00:00:00","r")
;   
;   rad4_1 = addfile(rad4_dir + "wrfout_d01_1998-05-29_03:00:00","r")
;   rad4_2 = addfile(rad4_dir + "wrfout_d01_1998-06-28_03:00:00","r")
;   rad4_3 = addfile(rad4_dir + "wrfout_d01_1998-07-28_03:00:00","r")
;   rad4_4 = addfile(rad4_dir + "wrfout_d01_1998-08-27_03:00:00","r")
;   
;   rad5_1 = addfile(rad5_dir + "wrfout_d01_1998-05-29_03:00:00","r")
;   rad5_2 = addfile(rad5_dir + "wrfout_d01_1998-06-28_03:00:00","r")
;   rad5_3 = addfile(rad5_dir + "wrfout_d01_1998-07-28_03:00:00","r")
;   rad5_4 = addfile(rad5_dir + "wrfout_d01_1998-08-27_03:00:00","r")
	
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

   lat2d = rad3_May->XLAT(0,:,:)
   lon2d = rad3_May->XLONG(0,:,:)

   ; check cal. date
;   print("" + t(24,:))

   ; get the record when summer begin
   t = rad3_May->Times
   nt = dimsizes(t(:,0))
   do i = 0, nt - 1
      if ( ("" + t(i,:)) .eq. "1998-06-01_00:00:00" ) then
         rec_begin = i
      end if
   end do
;   rad3_May_r = new(/nt-rec_begin,119,139/)
   rad3_May_rainc = rad3_May->RAINC(rec_begin:, :, :)
   rad3_May_rainnc = rad3_May->RAINNC(rec_begin:, :, :)

   nt = nt - rec_begin

   rad3_Jun_rainc = rad3_Jun->RAINC(:, :, :)
   rad3_Jun_rainnc = rad3_Jun->RAINNC(:, :, :)

   rad3_Jul_rainc = rad3_Jul->RAINC(:, :, :)
   rad3_Jul_rainnc = rad3_Jul->RAINNC(:, :, :)
;   print(rad3_Jun_rainc(:,3,3))

   ; get the record when summer end
   t = rad3_Aug->Times
   nt = dimsizes(t(:,0))
   do i = 0, nt - 1
      if ( ("" + t(i,:)) .eq. "1998-08-31_21:00:00" ) then
         rec_end = i
      end if
   end do
;   print(0+rec_end)
   rad3_Aug_rainc = rad3_Aug->RAINC(:rec_end, :, :)
   rad3_Aug_rainnc = rad3_Aug->RAINNC(:rec_end, :, :)


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

   ; South Chnia Sea <<<1

   cnres           = True
	cnres@china     = True  
	cnres@river     = True 
	cnres@province  = False
	cnres@nanhai    = True 
	cnres@diqu      = False
;   chinamap = add_china_map(wks, plot, cnres)

;   draw(plot)
;   frame(wks)
end
