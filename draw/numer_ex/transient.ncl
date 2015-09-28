
; Description: 
; 
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-06-11 18:42:27 CST
; Last Change: 2013-06-19 10:11:01 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"

begin
 
    ; dev. var <<<1

    draw_dir = "/home/ou/archive/drawing/numer_ex/transient"
    data_dir = "/home/ou/archive/data/numer_ex"
    nc = addfile(data_dir + "/transient.nc", "r")

    img = draw_dir + "/transient"

    x_ex = nc->x_ex
    ex_40 = nc->ex_40 
    ex_80 = nc->ex_80 
    ex_120 = nc->ex_120 

    x_nu = nc->x
    phi_40 = nc->phi_40
    phi_80 = nc->phi_80
    phi_120 = nc->phi_120

    res = create "res_transient" appClass defaultapp
        "appDefaultParent" : True
        "appUsrDir" : "./"
    end create

    wks = create "wks" documentWorkstationClass defaultapp 
        "wkFileName" : img
    end create

    ; data <<<1

    data_exact = create "data_exact" coordArraysClass defaultapp
        "caYArray" : (/ex_40, ex_80, ex_120/)
        "caXArray" : (/x_ex, x_ex, x_ex/)
    end create

    data_numer = create "data_numer" coordArraysClass defaultapp
        "caYArray" : (/phi_40, phi_80, phi_120/)
        "caXArray" : (/x_nu, x_nu, x_nu/)
    end create

    ; plot <<<1

    plot = create "plot" xyPlotClass wks
;        "tiMainString" : "Transient state diffusion"
        "tiMainString" : "Implicit scheme, dt = 8s"
        "xyCoordData" : (/data_exact, data_numer/)
        "tiYAxisString" : ex_40@long_name
        "tiXAxisString" : x_ex@long_name
    end create

    ; text <<<1

    txres = True
    txres@txFontHeightF = 0.02
    txres@txJust = "bottomleft"
    n = dimsizes(x_ex)/7
    dummy = gsn_add_text(wks, plot, "  40s", x_ex(n), ex_40(n), txres)
    dummy = gsn_add_text(wks, plot, "  80s", x_ex(n), ex_80(n), txres)
    dummy = gsn_add_text(wks, plot, "  120s", x_ex(n), ex_120(n), txres)

    ; draw <<<1

    draw(plot)

    frame(wks)

    delete(wks)

    system("eps2png.sh " + img)

end
