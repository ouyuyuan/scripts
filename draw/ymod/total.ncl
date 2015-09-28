
; Description: total statistic physical variable
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-04-16 07:51:18 CST
; Last Change: 2013-04-17 20:51:56 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; retrieve data <<<1

;    data_dir = "/home/ou/archive/data/ymod"
;    data_dir = "/home/ou/archive/data/ymod"
;    data_dir = "/home/ou/mount/101/models/ymod/data"
    data_dir = "/home/ou/mount/101/models/gpem/data"
    draw_dir = "/home/ou/archive/drawing/ymod"
    fin      = data_dir + "/total.dat"

    nvars = 8
    nrecs = 301

    var = new((/nrecs,nvars/),"float")

    var = fbindirread(fin,0,(/nrecs,nvars/),"float")
    time       = fspan(0,nrecs-1,nrecs)

    mass = var(:,0)
    ek   = var(:,1)
    ep   = var(:,2)
    div  = var(:,3)
    vor  = var(:,4)
    ens  = var(:,5)
    pvor = var(:,6)
    pens = var(:,7)

    res = True
    res@gsnDraw = False
    res@gsnFrame = False

    wtype = "png"
    img = draw_dir + "/total"
    wks = gsn_open_wks(wtype, img)

    plot = new(nvars, graphic)

    res@tiMainString = "(a) Mass"
    plot(0) = gsn_csm_xy(wks, time, mass/mass(0), res)

    res@tiMainString = "(b) Kinetic energy"
    plot(1) = gsn_csm_xy(wks, time, ek/ek(0), res)

    res@tiMainString = "(c) Total energy"
    plot(2) = gsn_csm_xy(wks, time, (ek+ep)/(ek(0)+ep(0)), res)

    res@tiMainString = "(d) Divergence"
    plot(3) = gsn_csm_xy(wks, time, div/div(0), res)

    res@tiMainString = "(e) Vorticity"
    plot(4) = gsn_csm_xy(wks, time, vor/vor(0), res)

    res@tiMainString = "(f) Enstrophy"
    plot(5) = gsn_csm_xy(wks, time, ens/ens(0), res)

    res@tiMainString = "(g) Potential vorticity"
    plot(6) = gsn_csm_xy(wks, time, pvor/pvor(0), res)

    res@tiMainString = "(h) Potential enstrophy"
    plot(7) = gsn_csm_xy(wks, time, pens/pens(0), res)

    panel_res = True
    panel_res@gsnMaximize = True

    panel_res@txString = "Total phycical variable change"

    panel_res@gsnPanelRowSpec = True
    panel_res@gsnPanelCenter  = False

    gsn_panel(wks, plot, (/3,3,2/), panel_res)

end
