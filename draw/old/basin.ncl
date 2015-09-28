
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-10 20:09:10 BJT
; Last Change: 2014-12-10 20:16:07 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"    
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"  

datDir = getenv("NCL_ARG_1")
imgDir = getenv("NCL_ARG_2")
nc = "basin.nc"
f = addfile(datDir+nc, "r")
basin = f->basin
delete(f)

;************************************************
; create plot
;************************************************
img = imgDir+getenv("NCL_ARG_0_base")
wks = gsn_open_wks("eps",img)

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
res@lbLabelStrings    = ""+ (/ -14,1,2,3,6,8,9,10/)

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
