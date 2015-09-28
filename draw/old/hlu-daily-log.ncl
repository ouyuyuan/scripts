
; Description: YES and NO curl of daily
;
;      Author: OU Yuyuan <ouyuyuan@gmail.com>
;     Created: 2013-01-28 08:42:37 CST
; Last Change: 2013-02-18 09:17:26 CST

begin

ncFile = addfile("/home/ou/archive/data/daily-log.nc","r")

data = create "xyData" coordArraysClass defaultapp
    "caYArray": ncFile->manga
    "caYMissingV": ncFile->manga@_FillValue
end create

wks_type = "pdf"
wks_filename = "/home/ou/archive/drawing/daily-log-yesno"

wks = create "wks" documentWorkstationClass defaultapp
    "wkFileName" : wks_filename
    "wkFormat"   : wks_type
end create

plot = create "xyPlot" xyPlotClass wks
    "xyCoordData": data
    "xyLineColors": "blue"
end create

draw(plot)
frame(wks)

end
