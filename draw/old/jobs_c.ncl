
; Description: YES and NO curl of daily
;
;      Author: OU Yuyuan <ouyuyuan@gmail.com>
;     Created: 2013-01-28 08:42:37 CST
; Last Change: 2013-03-10 07:08:52 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

ncFile = addfile("/home/ou/archive/data/daily_log/daily_log.nc","r")
file_dir = "/home/ou/archive/drawing/png/daily_log"

job = ncFile->job(141:,:)

wtype = "png"
;gsn_define_colormap(wks, "gui_default")

filename = file_dir + "/job_type_c"
wks = gsn_open_wks(wtype, filename)

res = True
res@gsnDraw = False
res@gsnFrame = False

res@cnInfoLabelOn = False
res@cnLevelSpacingF = 1
res@cnLineLabelsOn = False

gsn_define_colormap(wks,"wh-bl-gr-ye-re")
;gsn_define_colormap(wks,(/"white","blue","green","yellow","red"/))

plot = new(4,graphic)
title = (/"All jobs", "Work", "Learn", "Other"/)

res@cnLinesOn = False
do i = 0, dimsizes(title)-1
    res@tiMainString = title(i)
    plot(i) = gsn_contour(wks, job, res)
end do

opt = True
opt@gsnShadeMid = "black"

plot(0) = gsn_contour_shade(plot(0), 1, 18, opt)

opt@gsnShadeMid = "red"
plot(1) = gsn_contour_shade(plot(1), 1, 6, opt)

opt@gsnShadeMid = "blue"
plot(2) = gsn_contour_shade(plot(2), 7, 11, opt)

opt@gsnShadeMid = "green"
plot(3) = gsn_contour_shade(plot(3), 12, 19, opt)

panres = True
panres@gsnMaximize = True
gsn_panel(wks, plot, (/2,2/), panres)

delete(plot)
delete(res)
delete(opt)

end
