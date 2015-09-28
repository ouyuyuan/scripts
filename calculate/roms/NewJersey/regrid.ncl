
; Description: regrid data to ROMS horizontal grid
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-31 08:02:37 BJT
; Last Change: 2014-07-31 20:24:13 BJT

; The assumption is that the rectilinear grid will be represented
; as coordinate arrays of the "var" variable. If this isn't the
; case, you will need to read the lat/lon rectilinear arrays 
; separately and set them via the SrcLat/SrcLon attributes (see
; later code).
;
; Both grids are assumed to be contained in separate NetCDF files.
; 
; For more information on ESMF_regrid, see: 
;
;    http://www.ncl.ucar.edu/Document/Functions/ESMF/ESMF_regrid.shtml
;----------------------------------------------------------------------
; This example uses the ESMF application "ESMF_RegridWeightGen" to 
; generate the weights.
;
; For more information about ESMF:
;
;        http://www.earthsystemmodeling.org/
;
; This script uses built-in functions that are only available in 
; NCL V6.1.0-beta and later.
;----------------------------------------------------------------------

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

  data_dir = "/home/ou/archive/data/soda/climate/"
  ;--Data file containing source grid
;  src_file = data_dir + "climate_1981-2000.nc"              ;;---Change (likely)
  src_file = "soda.nc"
  sfile    = addfile(src_file,"r")

  ;---Get variable to regrid
  varname = "temp"                      ;;---Change (likely)
  var     = sfile->$varname$(0,:,:)         ; Assumption is that "var"
  src_lat = sfile->lat
  src_lon = sfile->lon
                                     ; contains coordinate arrays.
  printVarSummary(var)               ; Make sure it has coord arrays.

  ;---Data file containing destination grid
  dst_dir  = "/home/ou/archive/data/roms/latte/in/"
;  dst_file = dst_dir + "roms_latte_grid_4b.nc"                      ;;---Change (likely)
  dst_file = "roms_grid.nc"
  dfile    = addfile(dst_file,"r")
  dst_lat  = dfile->lat_rho                     ;;---Change (likely)
  dst_lon  = dfile->lon_rho                     ;;---Change (likely)

  ;---Set up regridding options
  Opt                   = True

  ;---"bilinear" is the default. "patch" and "conserve" are other options.
  Opt@InterpMethod      = "patch"        ;;---Change (maybe)

  Opt@WgtFileName       = dst_dir + "rect_to_curv.nc"

  ;
  ; These next two lines only needed if "var" doesn't
  ; contain coordinate arrays.
  ;
  Opt@SrcGridLat        = src_lat        ;;--Change (maybe)
  Opt@SrcGridLon        = src_lon        ;;--Change (maybe)

  Opt@SrcRegional       = False             ;;--Change (maybe)
  Opt@SrcInputFileName  = src_file          ; optional, but good idea
  Opt@SrcMask2D         = where(.not.ismissing(var),1,0) ; Necessary if has
                                                         ; missing values.

  Opt@DstGridLat        = dst_lat           ; destination grid
  Opt@DstGridLon        = dst_lon
  Opt@DstRegional       = True              ;;--Change (maybe)
  Opt@DstMask2D = where(.not.ismissing(dst_lat).and.\
                        .not.ismissing(dst_lon),1,0) ; Necessary if lat/lon
                                                    ; has missing values.

  Opt@ForceOverwrite    = True
  Opt@PrintTimings      = True
  Opt@Debug             = True

  var_regrid = ESMF_regrid(var,Opt)     ; Do the regridding

  printVarSummary(var_regrid)           ; Check that everything
  printMinMax(var_regrid,0)             ; looks okay.

  ;----------------------------------------------------------------------
  ; Plotting section
  ;
  ; This section creates filled contour plots of both the original
  ; data and the regridded data, and panels them.
  ;----------------------------------------------------------------------
  wks = gsn_open_wks("eps","rect_to_curv")
  gsn_define_colormap(wks, "NCL_default")

  res                       = True

  res@gsnMaximize           = True

  res@gsnDraw               = False
  res@gsnFrame              = False

  res@cnFillOn              = True
  res@cnLinesOn             = False
  res@cnLineLabelsOn        = False
  res@cnFillMode            = "RasterFill"

  res@lbLabelBarOn          = False    ; Turn on later in panel

  res@mpMinLatF             = min(dst_lat)
  res@mpMaxLatF             = max(dst_lat)
  res@mpMinLonF             = min(dst_lon)
  res@mpMaxLonF             = max(dst_lon)

  ;;--Change (maybe)
  mnmxint = nice_mnmxintvl( min(var), max(var), 18, False)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)

  ;---Resources for plotting regridded data
  res@gsnAddCyclic  = False            ;;---Change (maybe)
  res@tiMainString  = "Curvilinear grid (" + Opt@InterpMethod + ")"

  plot_regrid = gsn_csm_contour_map(wks,var_regrid,res)

  ;---Resources for plotting original data
;  res@gsnAddCyclic = False            ;;---Change (maybe)
  res@tiMainString = "Original rectilinear grid"

  res@mpMinLatF             = min(src_lat)
  res@mpMaxLatF             = max(src_lat)
  res@mpMinLonF             = min(src_lon)
  res@mpMaxLonF             = max(src_lon)

  plot_orig = gsn_csm_contour_map(wks,var,res)  

  ;---Compare the plots in a panel
  pres                   = True
  pres@gsnMaximize       = True
  pres@gsnPanelLabelBar  = True

  gsn_panel(wks,(/plot_orig,plot_regrid/),(/2,1/),pres)
end
