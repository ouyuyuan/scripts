
; Description: YES and NO curl of daily
;
;      Author: OU Yuyuan <ouyuyuan@gmail.com>
;     Created: 2013-01-28 08:42:37 CST
; Last Change: 2013-02-27 09:51:24 CST

begin

ncFile = addfile("/home/ou/archive/data/daily_log/daily_log.nc","r")

job = ncFile->job

filename = "/home/ou/archive/drawing/png/daily_log_jobs"
wtype = "png"

res = create "res" appClass defaultapp
    "appUsrDir" : "./"
    "appDefaultParent" : True
end create

wks = create "wks" imageWorkstationClass defaultapp
    "wkFileName" : filename
    "wkFormat" : wtype
end create

data = create "field" scalarFieldClass res
    "sfDataArray" : job
end create

plot = create "plot" contourPlotClass wks
    "cnScalarFieldData" : data
end create

draw(plot)
frame(wks)

delete(wks)
delete(res)

end
