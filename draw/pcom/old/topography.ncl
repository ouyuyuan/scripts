
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>, All Rights Reserved.
;     Created: 2013-06-23 20:46:30 CST
; Last Change: 2013-06-25 16:54:17 CST

;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
    ; dev. var <<<1

    draw_dir = "/home/ou/archive/drawing/pcom"
    data_dir = "/home/ou/archive/data/pcom/INPUT"
    setfileoption("nc","MissingToFillValue",False)
    nc = addfile(data_dir + "/pcom_ini.nc", "r")

    img = draw_dir + "/topography"

    depth = nc->depth
    lat = nc->lat
    lon = nc->lon

    res = create "res_topography" appClass defaultapp
        "appDefaultParent" : True
        "appUsrDir" : "./"
    end create

    wks = create "wks" documentWorkstationClass defaultapp 
        "wkFileName" : img
    end create

    ; data <<<1

    data_topo = create "data_topo" scalarFieldClass defaultapp
        "sfDataArray" : depth
        "sfXCStartV" :  lon(0)
        "sfXCEndV"   :  lon(dimsizes(lon)-1)
        "sfYCStartV" :  lat(0)
        "sfYCEndV"   :  lat(dimsizes(lat)-1)
        "sfMissingValueV": depth@missing_value
    end create

    ; plot <<<1

    plot = create "plot" contourPlotClass wks
        "cnScalarFieldData": data_topo
    end create

    ; draw <<<1

    draw(plot)

    frame(wks)

    delete(wks)

    system("eps2png.sh " + img)

end
