
; Description: Euler's method in Thomas' Calculus
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-05-02 07:01:30 CST
; Last Change: 2013-05-02 07:54:34 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    draw_dir = "/home/ou/archive/drawing/numer_ex"

    ; exact solution <<<1

    procedure plot_exact()
    begin

        xa = 0.0
        xb = 5.0
        npts = 50
        e = 2.718281828459

        x = fspan(xa,xb,npts)
        y = 2*e^x-1

        res = True
        res@tiMainString = "Exact solution of the initial problem"
        res@xyLineThicknessF = 4

        wtype = "png"
        img = draw_dir + "/euler_exact"
        wks = gsn_open_wks(wtype, img)

        plot = gsn_csm_xy(wks, x, y, res)

        delete(wks)

    end

    plot_exact

end
