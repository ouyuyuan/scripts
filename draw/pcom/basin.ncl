
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-10 20:09:10 BJT
; Last Change: 2015-07-13 15:33:26 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  

nc = "/home/ou/archive/data/pcom/basin/basin.nc"
f = addfile(nc, "r")
basin = f->basin
delete(f)

;************************************************
; create plot
;************************************************
;;wks = gsn_open_wks("ps","Mask_"+keyi)  
  img = "/home/ou/archive/drawing/pcom/basin"
  wks = gsn_open_wks("eps",img)
  gsn_define_colormap(wks, "amwg")  

  res                  = True                ; plot mods desired
  res@gsnFrame         = False
  res@gsnDraw          = False
  res@gsnAddCyclic     = True 
;  res@gsnMaximize      = True

  res@cnFillOn         = True               ; color Fill 
  res@cnFillMode       = "RasterFill"       ; Raster Mode
  res@cnLinesOn        =  False             ; Turn off contour lines
  res@cnLineLabelsOn   =  False
  res@cnLevelSelectionMode = "ExplicitLevels" 
  res@cnLevels         =   (/ 1,2,3,6,8,9,10/)
 
;  res@lbLabelBarOn     = False              ; turn off individual lb's
  res@lbLabelPosition  = "Center"           ; label position
  res@lbLabelAlignment = "BoxCenters"       ; label orientation
 ;res@lbLabelStrings    = ""+ res@cnLevels   ; trick 
  res@lbLabelStrings    = ""+ (/ -5,1,2,3,6,8,9,10/)

  res@mpCenterLonF     = 205                ; set map center
  res@mpFillOn         = False

  res@gsnLeftString    = "Selected Basins"        

;  rmask@lat2d   = lat2d
;  rmask@lon2d   = lon2d

;  res@tiMainString     = "POP: Basin Index Values"
;  plot(0) = gsn_csm_contour_map_ce(wks, rmask, res) ; create plot

  res@tiMainString     = "PCOM Basin Index Values"
  plot = gsn_csm_contour_map_ce(wks, basin, res) ; create plot

  draw(plot)
  frame(wks)

  delete(wks)
  system("eps2png_trim " + img)
