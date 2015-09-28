
; Description: kinetic harmonics distribution on a certain latitude (50N)
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-04-16 14:28:30 CST
; Last Change: 2013-04-17 20:51:57 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; retrieve data <<<1

;    data_dir = "/home/ou/mount/101/models/ymod/data"
    data_dir = "/home/ou/mount/101/models/gpem/data"
    draw_dir = "/home/ou/archive/drawing/ymod"
    fin      = data_dir + "/statistic.dat"

    nlats = 37
    nlons = 72
    nrecs = 301
    nvars = 6

    ek   = new((/nrecs,nlats,nlons/),"float")
    wave = fspan(0,nlons/2-1,nlons/2)

    do rec = 0, nrecs - 1
        ek(rec,:,:) = fbindirread(fin,nvars*rec+0,(/nlats,nlons/),"float")
    end do
    
    res = True
    res@gsnDraw = False
    res@gsnFrame = False

    res@gsnXYBarChart = True
    res@gsnXYBarChartColors = "blue"

    wtype = "png"
    img = draw_dir + "/ek_harmonic"
    wks = gsn_open_wks(wtype, img)

    plot = new(4, graphic)

    res@tiMainString = "Initial"
    finfo = fourier_info(ek(0,29,:), nlons/2, 1.0)
    amps = finfo(0,:)
    amps@long_name = "amplitude"
    plot(0) = gsn_csm_xy(wks, wave, amps, res)

    res@tiMainString = "After 150 days"
    finfo = fourier_info(ek(150,29,:), nlons/2, 1.0)
    amps = finfo(0,:)
    amps@long_name = "amplitude"
    plot(1) = gsn_csm_xy(wks, wave, amps, res)

    res@tiMainString = "After 170 days"
    finfo = fourier_info(ek(170,29,:), nlons/2, 1.0)
    amps = finfo(0,:)
    amps@long_name = "amplitude"
    plot(2) = gsn_csm_xy(wks, wave, amps, res)

    res@tiMainString = "After 200 days"
    finfo = fourier_info(ek(200,29,:), nlons/2, 1.0)
    amps = finfo(0,:)
    amps@long_name = "amplitude"
    plot(3) = gsn_csm_xy(wks, wave, amps, res)

    panel_res = True
    panel_res@gsnMaximize = True

    panel_res@txString = "Kinetic energy harmonics in 50N"

    panel_res@gsnPanelRowSpec = True
    panel_res@gsnPanelCenter  = False

    gsn_panel(wks, plot, (/2,2/), panel_res)

end
