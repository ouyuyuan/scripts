
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-05-30 10:52:27 CST
; Last Change: 2013-05-30 15:56:11 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    draw_dir = "/home/ou/archive/drawing/numer_ex"
    data_dir = "/home/ou/archive/data/numer_ex"

    nc_5p  = addfile(data_dir + "/convect_5p.nc", "r")
    phi_5p = nc_5p->phi

    wtype = "eps"
    img = draw_dir + "/convect"
    wks = gsn_open_wks(wtype, img)

    res = True
    res@gsnDraw = False
    res@gsnFrame = False
    res@xyLineThicknessF = 1
    res@xyMarkerSizeF = 0.01
    res@tmLabelAutoStride = True ; nice tick mark labels

    ; plot results <<<1

    procedure plot_result(u: float)
    begin

        phi_0 = 1.0
        phi_l = 0.0
        rho   = 1.0
        gama  = 0.1
        l     = 1.0

        npts = 500
        x = fspan(0,l,npts)

        y = phi_0 + (phi_l - phi_0)*(exp(rho*u*x/gama) - 1) / \
            (exp(rho*u*l/gama) - 1)

        res@tiMainString = "Exact solution of the convection diffusion problem"
        plot = gsn_csm_xy(wks, x, y, res)

        res@xyMarkLineMode = "Markers"
        res@xyMarkerColor = "red"
        res@xyMarker = 16
        plot = gsn_csm_xy(wks, phi_5p&x, phi_5p, res)

        draw(plot)
        frame(wks)

        delete(wks)
        system("eps2png.sh " + img)

    end

    plot_result(0.1)

end
