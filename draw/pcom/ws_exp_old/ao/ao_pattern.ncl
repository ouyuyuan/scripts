
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-15 16:10:24 BJT
; Last Change: 2014-11-17 10:58:34 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 

procedure draw_pattern(img, inres, arg)
begin

  nc = getenv("NCL_ARG_1")
  cmap = "BlueWhiteOrangeRed"

  ; the last 3 year is climatory
  f = addfile(nc, "r")
  ts = f->ts_sd
  eof_regres = f->eof_regres
  delete(f)
  eof_regres = eof_regres*ts(0)

  wks = gsn_open_wks("eps", img)
  gsn_define_colormap(wks,cmap)                    

  res                  = True       
  res@tiMainFontHeightF = 0.03
  res@gsnPolar             = "NH"
  res@gsnDraw          = False       
  res@gsnFrame         = False     
  res@gsnLeftString  = "EOF 1"
  res@gsnRightString = sprintf("%5.1f", eof_regres@pcvar) +"%"
  res@gsnAddCyclic = False

;  res@vpHeightF        = 0.4            ; change aspect ratio of plot
;  res@vpWidthF         = 0.9            
;  res@vpXF             = 0.1            ; start plot at x ndc coord 
 
  res@mpFillOn             = False        ; turn off map fill
  res@mpMinLatF            = 20
  res@mpCenterLonF         = 180

  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False        ; True is default
  res@cnLineLabelsOn       = False        ; True is default
;  res@lbLabelBarOn         = False        ; turn off individual lb's

  symMinMaxPlt(eof_regres, 16, False, res)       ; contributed.ncl
  res@cnLevelSpacingF      = 5.0          ; *special* match CPC
  
  copy_VarAtts(inres, res)
  plot=gsn_csm_contour_map_polar(wks,eof_regres,res)

  draw(plot)
  frame(wks)
  delete(wks)
  system("eps2png_trim "+img)
end

res = True
arg = True
img = getenv("NCL_ARG_2")
years = "1948-2008"

; slp pattern
;====================================
res@tiMainString = "Sea level pressure pattern"
draw_pattern(img, res, arg)
