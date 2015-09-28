
; Description: steady-state heat distribution
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-05-29 06:44:25 CST
; Last Change: 2013-05-29 10:05:25 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    draw_dir = "/home/ou/archive/drawing/numer_ex"
    data_dir = "/home/ou/archive/data/numer_ex"

    nc = addfile(data_dir + "/heat_3.nc", "r")

    wtype = "eps"

    res = True
;    res@gsnDraw = False
;    res@gsnFrame = False

    res@cnInfoLabelOn = False
    res@cnFillOn = True
    res@cnLinesOn = False

    ; temperature plot <<<1

    procedure plot_temp()
    begin
        temp = nc->temp

        img = draw_dir + "/heat_3"
        wks = gsn_open_wks(wtype, img)

        res@tiMainString = "Temperature distribution"

        plot = gsn_csm_contour(wks, temp(y|:,x|:), res)

        delete(wks)

        system("eps2png.sh " + img) ; put after delete(wks)
    end

    plot_temp
end
