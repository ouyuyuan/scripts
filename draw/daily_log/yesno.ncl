
; Description: YES and NO curl of daily
;
;      Author: OU Yuyuan <ouyuyuan@gmail.com>
;     Created: 2013-01-28 08:42:37 CST
; Last Change: 2013-03-23 09:11:23 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

ncFile = addfile("/home/ou/archive/data/daily_log/daily_log.nc","r")

; manga  <<<1

manga = ncFile->manga
so = ncFile->so
fit = ncFile->fit
days = ispan(1,dimsizes(manga),1)

wtype = "png"
file_dir = "/home/ou/archive/drawing/daily_log"
filename = file_dir + "/yesno"
wks = gsn_open_wks(wtype,filename)

res = True
res@gsnDraw = False
res@gsnFrame = False

res@gsnYRefLine = 0.5
res@gsnAboveYRefLineColor = "red"
res@gsnBelowYRefLineColor = "blue"

res@xyMarkLineMode = "Markers"
res@xyMarker = 1 ; 1: dot, 3: asterisk
res@xyMarkerColor = "red"
res@xyMarkerSizeF = 0.02

res@tmYLMode = "Explicit"
res@tmYLValues = (/ 0, 1 /)
res@tmYLLabels = (/ "No", "Yes" /)

plot = new(3,graphic)

res@tiMainString = "Manga"
plot(0) = gsn_csm_xy(wks, days, manga, res)
res@tiMainString = "Doesotrue"
plot(1) = gsn_csm_xy(wks, days, so, res)
res@tiMainString = "Fitness"
plot(2) = gsn_csm_xy(wks, days, fit, res)

panelRes = True
panelRes@gsnMaximize = True
stime = systemfunc("date +%Y-%m-%d")
panelRes@gsnPanelFigureStrings = (/stime,stime,stime/)

gsn_panel(wks, plot, (/2,2/), panelRes)

delete(wks)
delete(plot)

end
