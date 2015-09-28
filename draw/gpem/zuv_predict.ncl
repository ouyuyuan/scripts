
; Description: 3 days prediction
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-19 07:07:40 CST
; Last Change: 2013-05-11 19:29:51 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    ; files <<<2

    draw_dir = "/home/ou/archive/drawing/gpem/predict"
    data_dir = "/home/ou/archive/data/gpem"
    ncep_hgt = data_dir + "/ncep1_hgt_2009_4xdaily.nc"
    ncep_uwnd = data_dir + "/ncep1_uwnd_2009_4xdaily.nc"
    ncep_vwnd = data_dir + "/ncep1_vwnd_2009_4xdaily.nc"
    gpem = data_dir + "/gpem.nc"

    finz_ncep = addfile(ncep_hgt, "r")
    finu_ncep = addfile(ncep_uwnd, "r")
    finv_ncep = addfile(ncep_vwnd, "r")
    fin_gpem = addfile(gpem, "r")

    day = 0              ; day after 2008-1-1
    sta_rec = day*4
    end_rec = sta_rec + 72/6

    ; pic. type <<<2

    a4_height   = 29.7
    a4_width    = 23.0
    cm_per_inch = 2.54

;    wtype = "png"
;    wtype@wkWidth = 3000
;    wtype@wkHeight = 3000

    wtype = "pdf"
    wtype@wkPaperWidthF  = a4_height/cm_per_inch
    wtype@wkPaperHeightF = a4_width/cm_per_inch

    ; res <<<2

    res = True
    res@gsnDraw = False
    res@gsnFrame = False
    res@gsnPolar = "NH"

    res@cnInfoLabelOn = False
    res@cnFillOn = True
    res@cnLinesOn = False

    res@mpMinLatF = 0

    resP = True
    resP@gsnMaximize = True
    resP@gsnPanelRowSpec = True
    resP@gsnPanelYWhiteSpacePercent = 10
    resP@gsnPanelXWhiteSpacePercent = 5 

    resP@gsnPaperOrientation = "portrait"

    ; plot z in 500 <<<1

    procedure plot_z_predict()
    begin

        ; retrieve z <<<2

        hgt_ncep = finz_ncep->hgt(sta_rec:end_rec, {500}, {-90:90:2}, {0:357.5:2})

        z_ncep = hgt_ncep*hgt_ncep@scale_factor + hgt_ncep@add_offset
        z_ncep@_FillValue = hgt_ncep@missing_value*hgt_ncep@scale_factor + \ 
        hgt_ncep@add_offset
        z_ncep@long_name = hgt_ncep@long_name

        copy_VarCoords(hgt_ncep, z_ncep)

        ; per nc record predict 72 hours, per 6 hours make a output
        z_gpem = fin_gpem->ph(sta_rec*13:end_rec, :, :) 

        plot = new(8, graphic)

        img = draw_dir + "/z_500_predict"
        wks = gsn_open_wks(wtype, img)

        res@lbLabelBarOn = False

        res@cnLevelSelectionMode = "ManualLevels"
;        res@cnLevelSpacingF = 100
        res@cnLevelSpacingF = 50
        res@cnMinLevelValF = 4900
        res@cnMaxLevelValF = 5800

        res@tiMainString = "(a1) ncep, 2009-1-1 00:00"
        plot(0) = gsn_csm_contour_map_polar(wks, z_ncep(0/6,:,:), res)

        res@tiMainString = "(a2) ncep, 2009-1-2 00:00"
        plot(1) = gsn_csm_contour_map_polar(wks, z_ncep(24/6,:,:), res)

        res@tiMainString = "(a3) ncep, 2009-1-3 00:00"
        plot(2) = gsn_csm_contour_map_polar(wks, z_ncep(48/6,:,:), res)

        res@tiMainString = "(a4) ncep, 2009-1-4 00:00"
        plot(3) = gsn_csm_contour_map_polar(wks, z_ncep(72/6,:,:), res)

        res@tiMainString = "(b1) gpem, 2009-1-1 00:00"
        plot(4) = gsn_csm_contour_map_polar(wks, z_gpem(0,:,:), res)

        res@tiMainString = "(b2) gpem, 2009-1-2 00:00"
        plot(5) = gsn_csm_contour_map_polar(wks, z_gpem(24/6,:,:), res)

        res@tiMainString = "(b3) gpem, 2009-1-3 00:00"
        plot(6) = gsn_csm_contour_map_polar(wks, z_gpem(48/6,:,:), res)

        res@tiMainString = "(b4) gpem, 2009-1-4 00:00"
        plot(7) = gsn_csm_contour_map_polar(wks, z_gpem(72/6,:,:), res)

        resP@txString = "500 hPa potential height prediction"
        resP@lbLabelStride = 2
        resP@gsnPanelLabelBar = True
        resP@lbLabelFontHeightF = 0.01

        gsn_panel(wks, plot, (/4,4/), resP)

        delete(wks)

    end

    ; plot u in 500 <<<1

    procedure plot_u_predict()
    begin

        uwnd_ncep = finu_ncep->uwnd(sta_rec:end_rec, {500}, {-90:90:2}, {0:357.5:2})

        u_ncep = uwnd_ncep*uwnd_ncep@scale_factor + uwnd_ncep@add_offset
        u_ncep@_FillValue = uwnd_ncep@missing_value*uwnd_ncep@scale_factor + \ 
        uwnd_ncep@add_offset
        u_ncep@long_name = uwnd_ncep@long_name

        copy_VarCoords(uwnd_ncep, u_ncep)

        u_gpem = fin_gpem->u(sta_rec*13:end_rec, :, :) 

        plot = new(8, graphic)

        img = draw_dir + "/u_500_predict"
        wks = gsn_open_wks(wtype, img)

        res@lbLabelBarOn = True

        res@cnLevelSelectionMode = "ManualLevels"
        res@cnLevelSpacingF = 5
        res@cnMinLevelValF = -25
        res@cnMaxLevelValF = 50

        res@tiMainString = "(a1) ncep, 2009-1-1 00:00"
        plot(0) = gsn_csm_contour_map_polar(wks, u_ncep(0/6,:,:), res)

        res@tiMainString = "(a2) ncep, 2009-1-2 00:00"
        plot(1) = gsn_csm_contour_map_polar(wks, u_ncep(24/6,:,:), res)

        res@tiMainString = "(a3) ncep, 2009-1-3 00:00"
        plot(2) = gsn_csm_contour_map_polar(wks, u_ncep(48/6,:,:), res)

        res@tiMainString = "(a4) ncep, 2009-1-4 00:00"
        plot(3) = gsn_csm_contour_map_polar(wks, u_ncep(72/6,:,:), res)

        res@cnLevelSpacingF = 1
        res@cnMinLevelValF = -5
        res@cnMaxLevelValF = 5

        res@tiMainString = "(b1) gpem, 2009-1-1 00:00"
        plot(4) = gsn_csm_contour_map_polar(wks, u_gpem(0,:,:), res)

        res@tiMainString = "(b2) gpem, 2009-1-2 00:00"
        plot(5) = gsn_csm_contour_map_polar(wks, u_gpem(24/6,:,:), res)

        res@tiMainString = "(b3) gpem, 2009-1-3 00:00"
        plot(6) = gsn_csm_contour_map_polar(wks, u_gpem(48/6,:,:), res)

        res@tiMainString = "(b4) gpem, 2009-1-4 00:00"
        plot(7) = gsn_csm_contour_map_polar(wks, u_gpem(72/6,:,:), res)

        resP@txString = "500 hPa uwnd prediction"
        resP@lbLabelStride = 1
        resP@gsnPanelLabelBar = False

        gsn_panel(wks, plot, (/4,4/), resP)

        delete(wks)

    end

    ; plot v in 500 <<<1

    procedure plot_v_predict()
    begin

        vwnd_ncep = finv_ncep->vwnd(sta_rec:end_rec, {500}, {-90:90:2}, {0:357.5:2})

        v_ncep = vwnd_ncep*vwnd_ncep@scale_factor + vwnd_ncep@add_offset
        v_ncep@_FillValue = vwnd_ncep@missing_value*vwnd_ncep@scale_factor + \ 
        vwnd_ncep@add_offset
        v_ncep@long_name = vwnd_ncep@long_name

        copy_VarCoords(vwnd_ncep, v_ncep)

        v_gpem = fin_gpem->v(sta_rec*13:end_rec, :, :) 

        plot = new(8, graphic)

        img = draw_dir + "/v_500_predict"
        wks = gsn_open_wks(wtype, img)

        res@lbLabelBarOn = True

        res@cnLevelSelectionMode = "ManualLevels"
        res@cnLevelSpacingF = 5
        res@cnMinLevelValF = -30
        res@cnMaxLevelValF = 25

        res@tiMainString = "(a1) ncep, 2009-1-1 00:00"
        plot(0) = gsn_csm_contour_map_polar(wks, v_ncep(0/6,:,:), res)

        res@tiMainString = "(a2) ncep, 2009-1-2 00:00"
        plot(1) = gsn_csm_contour_map_polar(wks, v_ncep(24/6,:,:), res)

        res@tiMainString = "(a3) ncep, 2009-1-3 00:00"
        plot(2) = gsn_csm_contour_map_polar(wks, v_ncep(48/6,:,:), res)

        res@tiMainString = "(a4) ncep, 2009-1-4 00:00"
        plot(3) = gsn_csm_contour_map_polar(wks, v_ncep(72/6,:,:), res)

        res@cnLevelSpacingF = 1
        res@cnMinLevelValF = -3
        res@cnMaxLevelValF = 3

        res@tiMainString = "(b1) gpem, 2009-1-1 00:00"
        plot(4) = gsn_csm_contour_map_polar(wks, v_gpem(0,:,:), res)

        res@tiMainString = "(b2) gpem, 2009-1-2 00:00"
        plot(5) = gsn_csm_contour_map_polar(wks, v_gpem(24/6,:,:), res)

        res@tiMainString = "(b3) gpem, 2009-1-3 00:00"
        plot(6) = gsn_csm_contour_map_polar(wks, v_gpem(48/6,:,:), res)

        res@tiMainString = "(b4) gpem, 2009-1-4 00:00"
        plot(7) = gsn_csm_contour_map_polar(wks, v_gpem(72/6,:,:), res)

        resP@txString = "500 hPa vwnd prediction"
        resP@lbLabelStride = 1
        resP@gsnPanelLabelBar = False

        gsn_panel(wks, plot, (/4,4/), resP)

        delete(wks)

    end
    ; plot z in xx hours <<<1
    
    plot_z_predict
    plot_u_predict
    plot_v_predict

end
