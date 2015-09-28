
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
;     Created: 2013-07-04 16:57:20 CST
; Last Change: 2013-07-04 17:04:36 CST

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
    ; dev. var <<<1

    draw_dir = "/home/ou/archive/drawing/pcom"
    data_dir = "/home/ou/archive/data/pcom/INPUT"
    setfileoption("nc","MissingToFillValue",False)
    nc = addfile(data_dir + "/pcom_ini.nc", "r")

    img = draw_dir + "/layers"

    z = nc->z

    res = create "res_layers" appClass defaultapp
        "appDefaultParent" : True
        "appUsrDir" : "./"
    end create

    wks = create "wks" documentWorkstationClass defaultapp 
        "wkFileName" : img
    end create

    ; data <<<1

    data = create "data" coordArraysClass defaultapp
      "caYArray": z
    end create

    ; plot <<<1

    plot = create "plot" xyPlotClass wks
        "xyCoordData": data
    end create

    ; draw <<<1

    draw(plot)

    frame(wks)

    delete(wks)

    system("eps2png.sh " + img)

end
