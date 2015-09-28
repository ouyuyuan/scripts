
; Description: 
; 
;       Usage: ncl 'mainname="xxxx"' xxxx.ncl
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-05-30 10:51:54 CST
; Last Change: 2013-06-04 15:15:58 CST

begin
 
    ; dev. var <<<1

    draw_dir = "/home/ou/archive/drawing/numer_ex/convect"
    data_dir = "/home/ou/archive/data/numer_ex/convect"
;    mainname = "center"

    img = draw_dir + "/" + mainname
    nc_5p  = addfile(data_dir + "/" + mainname + "_5p.nc", "r")
    nc_20p = addfile(data_dir + "/" + mainname + "_20p.nc", "r")

    phi_5p_slow = nc_5p->phi
    phi_5p_fast = nc_5p->phi2
    x_5p = nc_5p->x

    phi_20p_slow = nc_20p->phi
    phi_20p_fast = nc_20p->phi2
    x_20p = nc_20p->x

    ya    = 1.0
    yb    = 0.0
;    ya    = 0.0
;    yb    = 1.0
    rho   = 1.0
    gama  = 0.1
    l     = 1.0
    u1    = 0.1  
    u2    = 2.5  
    npts  = 500
    x     = fspan(0,l,npts)

    phi_exact_slow = ya + (yb - ya)*(exp(rho*u1*x/gama) - 1) / \
        (exp(rho*u1*l/gama) - 1)
    phi_exact_fast = ya + (yb - ya)*(exp(rho*u2*x/gama) - 1) / \
        (exp(rho*u2*l/gama) - 1)

    ; positions <<<1

    margin = 0.1
    pos = True

    pos@tiWidth = .6
    pos@tiHeight = .6

    pos@subWidth = .33
    pos@subHeight = .27

    pos@tiMainX = .2
    pos@tiMainY = 1 - margin

    pos@ltx = margin
    pos@lty = pos@tiMainY - margin 

    pos@lbx = pos@ltx
    pos@lby = pos@tiMainY/2 - margin

    pos@rtx = pos@ltx + .5
    pos@rty = pos@lty
    pos@rbx = pos@lbx + .5
    pos@rby = pos@lby

    ; calc. closeness <<<1

    procedure calc_close()
    begin
        y_5p_slow = ya + (yb - ya)*(exp(rho*u1*x_5p/gama) - 1) / \
            (exp(rho*u1*l/gama) - 1)
        y_5p_fast = ya + (yb - ya)*(exp(rho*u2*x_5p/gama) - 1) / \
            (exp(rho*u2*l/gama) - 1)
        y_20p_slow = ya + (yb - ya)*(exp(rho*u1*x_20p/gama) - 1) / \
            (exp(rho*u1*l/gama) - 1)
        y_20p_fast = ya + (yb - ya)*(exp(rho*u2*x_20p/gama) - 1) / \
            (exp(rho*u2*l/gama) - 1)

        close_5p_slow = avg((phi_5p_slow - y_5p_slow)^2)
        close_5p_fast = avg((phi_5p_fast - y_5p_fast)^2)
        close_20p_slow = avg((phi_20p_slow - y_20p_slow)^2)
        close_20p_fast = avg((phi_20p_fast - y_20p_fast)^2)

        print(close_5p_slow)
        print(close_5p_fast)
        print(close_20p_slow)
        print(close_20p_fast)
    end

    ; resource file <<<1

    res = create "convect" appClass defaultapp
        "appDefaultParent" : True
        "appUsrDir" : "./"
    end create

    ; workstation <<<1

    wks = create "wks" documentWorkstationClass defaultapp 
        "wkFileName" : img
    end create

    ; data object <<<1

    data_exact_slow = create "data_exact_slow" coordArraysClass defaultapp
        "caXArray" : x
        "caYArray" : phi_exact_slow
    end create

    data_exact_fast = create "data_exact_fast" coordArraysClass defaultapp
        "caXArray" : x
        "caYArray" : phi_exact_fast
    end create

    data_5p_slow = create "data_5p_slow" coordArraysClass defaultapp
        "caXArray" : x_5p
        "caYArray" : phi_5p_slow
    end create

    data_5p_fast = create "data_5p_fast" coordArraysClass defaultapp
        "caXArray" : x_5p
        "caYArray" : phi_5p_fast
    end create

    data_20p_slow = create "data_20p_slow" coordArraysClass defaultapp
        "caXArray" : x_20p
        "caYArray" : phi_20p_slow
    end create

    data_20p_fast = create "data_20p_fast" coordArraysClass defaultapp
        "caXArray" : x_20p
        "caYArray" : phi_20p_fast
    end create

    ; plot object <<<1

    title = create "title" titleClass wks
        "vpXF" : pos@tiMainX
        "vpYF" : pos@tiMainY
        "vpWidthF" : pos@tiWidth
        "vpHeightF" : pos@tiHeight
        "tiMainString" : "1-D convective diffusion: " + mainname + " scheme"
;        "tiMainString" : "upstream scheme (swap boundary)"
    end create

    plot_5p_slow = create "plot_5p_slow" xyPlotClass wks
        "vpXF" : pos@ltx
        "vpYF" : pos@lty
        "vpWidthF" : pos@subWidth
        "vpHeightF" : pos@subHeight
        "xyCoordData" : (/data_exact_slow, data_5p_slow/)
        "tiYAxisString" : phi_5p_slow@long_name
        "tiXAxisString" : x_5p@long_name
    end create

    plot_5p_fast = create "plot_5p_fast" xyPlotClass wks
        "vpXF" : pos@rtx
        "vpYF" : pos@rty
        "vpWidthF" : pos@subWidth
        "vpHeightF" : pos@subHeight
        "xyCoordData" : (/data_exact_fast, data_5p_fast/)
        "tiYAxisString" : phi_5p_fast@long_name
        "tiXAxisString" : x_5p@long_name
    end create

    plot_20p_slow = create "plot_20p_slow" xyPlotClass wks
        "vpXF" : pos@lbx
        "vpYF" : pos@lby
        "vpWidthF" : pos@subWidth
        "vpHeightF" : pos@subHeight
        "xyCoordData" : (/data_exact_slow, data_20p_slow/)
        "tiYAxisString" : phi_20p_slow@long_name
        "tiXAxisString" : x_20p@long_name
    end create

    plot_20p_fast = create "plot_20p_fast" xyPlotClass wks
        "vpXF" : pos@rbx
        "vpYF" : pos@rby
        "vpWidthF" : pos@subWidth
        "vpHeightF" : pos@subHeight
        "xyCoordData" : (/data_exact_fast, data_20p_fast/)
        "tiYAxisString" : phi_20p_fast@long_name
        "tiXAxisString" : x_20p@long_name
    end create

    ; draw it <<<1

    procedure drawit()
    begin
        draw(title)
        draw(plot_5p_slow)
        draw(plot_5p_fast)
        draw(plot_20p_slow)
        draw(plot_20p_fast)

        frame(wks)
        delete(wks)
        system("eps2png.sh " + img)
    end

    ; driver <<<1

;    calc_close
    drawit

end
