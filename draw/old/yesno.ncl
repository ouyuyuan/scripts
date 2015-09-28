
; Description: YES and NO curl of daily
;
;      Author: OU Yuyuan <ouyuyuan@gmail.com>
;     Created: 2013-01-28 08:42:37 CST
; Last Change: 2013-02-28 14:49:38 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

ncFile = addfile("/home/ou/archive/data/daily_log/daily_log.nc","r")

; manga  <<<1

manga = ncFile->manga
days = ispan(1,dimsizes(manga),1)
days@long_name = "Days since 2012-10-01"

a4_height = 29.7 ; in centimeters
;a4_width = 23.0
a4_width = 29.7
cm_per_inch = 2.54 

;wtype = "pdf"
;wtype@wkPaperWidthF  = a4_width/cm_per_inch
;wtype@wkPaperHeightF = a4_height/cm_per_inch

wtype = "png"
file_dir = "/home/ou/archive/drawing/png/daily_log"

filename = file_dir + "/manga"
wks = gsn_open_wks(wtype,filename)

res = True
res@gsnMaximize = True
res@gsnScale = True
res@gsnPaperOrientation = "landscape"
res@gsnDraw = False
res@gsnFrame = False

res@gsnYRefLine = 0.5
res@gsnAboveYRefLineColor = "red"
res@gsnBelowYRefLineColor = "blue"

res@tiMainString = "Manga Envolved"
res@tiMainFont = "Helvetica"
res@tiXAxisFont = "Helvetica"
res@tiYAxisFont = "Helvetica"

res@xyMarkLineMode = "Markers"
res@xyMarker = 1 ; 1: dot, 3: asterisk
res@xyMarkerColor = "red"
res@xyMarkerSizeF = 0.02

res@trYMaxF = 1.1
res@trYMinF = -0.1
;res@vpHeightF = 0.4
;res@vpWidthF = 0.8
;res@vpXF = 0.1

res@tmYLMode = "Explicit"
res@tmYLValues = (/ 0, 1 /)
res@tmYLLabels = (/ "No", "Yes" /)

;plot = gsn_xy(wks,days,manga,res)
plot = gsn_csm_xy(wks,days,manga,res)

;maximize_output(wks, True)

draw(plot)
frame(wks)

delete(wks)

; doesotrue <<<1

filename = file_dir + "/so"

so = ncFile->so

wks = gsn_open_wks(wtype,filename)

res@tiMainString = "Doesotrue"

plot = gsn_csm_xy(wks,days,so,res)

draw(plot)
frame(wks)

delete(wks)

; fitness <<<1

filename = file_dir + "/fitness"

fit = ncFile->fit

wks = gsn_open_wks(wtype,filename)

res@tiMainString = "Fitness"

plot = gsn_csm_xy(wks,days,fit,res)

draw(plot)
frame(wks)

delete(wks)

end
