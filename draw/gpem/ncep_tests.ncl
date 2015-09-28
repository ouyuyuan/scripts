
; Description: tests for input using ncep reanalysis data field
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-19 07:07:40 CST
; Last Change: 2013-05-10 20:32:29 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    draw_dir = "/home/ou/archive/drawing/gpem/predict"

;    file_cur = "/home/ou/mount/101/models/gpem/data/gpem.nc"
    file_cur = "/home/ou/archive/data/gpem/gpem_cur.nc"
;    file_0_2 = "/home/ou/mount/101/data/gpem/gpem_v0.2.nc"
    file_0_2 = "/home/ou/archive/data/gpem/gpem_v0.2.nc"
    file_dft_0_N_1 = "/home/ou/archive/data/gpem/gpem_dft_0_N-1.nc"
    file_dft_1_N = "/home/ou/archive/data/gpem/gpem_dft_1_N.nc"

;    filename = file_0_2
;    filename = file_dft_0_N_1
;    filename = file_dft_1_N
    filename = file_cur

    fin = addfile(filename, "r")

    z = fin->ph
    u = fin->u
    v = fin->v
    ek = fin->ek

    tot_mass = fin->total_mass
    tot_ek   = fin->total_ek
    tot_ep   = fin->total_ep
    tot_div  = fin->total_div
    tot_vor  = fin->total_vor
    tot_ens  = fin->total_ens
    tot_pvor = fin->total_pvor
    tot_pens = fin->total_pens

    ; functions <<<1

    ; z at a point <<<2

    procedure plot_point_z()
    begin

        res = True

        pz = z(:,{50},{0})

        wtype = "png"
        img = draw_dir + "/z_50N_0E"
        wks = gsn_open_wks(wtype, img)

        res@tiMainString = "Time series of potential height at 50N, 0E"
        plot = gsn_csm_y(wks, pz, res)

        delete(wks)

    end

    ; ek harmonics <<<2

    procedure plot_ek_harm()
    begin

        res = True
        res@gsnDraw = False
        res@gsnFrame = False

        res@gsnXYBarChart = True
        res@gsnXYBarChartColors = "blue"

        wtype = "png"
        img = draw_dir + "/ek_harmonic"
        wks = gsn_open_wks(wtype, img)

        plot = new(6, graphic)

;        lek = ek(0,{50},:)

        nlons = 72

        res@tiMainString = "Initial"
        finfo = fourier_info(ek(0, {50}, :), nlons/2, 1.0)
        plot(0) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 6 hours"
        finfo = fourier_info(ek(6,{50},:), nlons/2, 1.0)
        plot(1) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 12 hours"
        finfo = fourier_info(ek(12,{50},:), nlons/2, 1.0)
        plot(2) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 24 hours"
        finfo = fourier_info(ek(24,{50},:), nlons/2, 1.0)
        plot(3) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 48 hours"
        finfo = fourier_info(ek(48,{50},:), nlons/2, 1.0)
        plot(4) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 72 hours"
        finfo = fourier_info(ek(72,{50},:), nlons/2, 1.0)
        plot(5) = gsn_csm_y(wks, finfo(0,:), res)

        panel_res = True
        panel_res@gsnMaximize = True

        panel_res@txString = "Kinetic energy harmonics in 50N"

        panel_res@gsnPanelRowSpec = True
        panel_res@gsnPanelCenter  = False

        gsn_panel(wks, plot, (/2,2,2/), panel_res)

        delete(wks)

    end
    
    ; total phys. var. <<<2

    procedure plot_total()
    begin

        res = True
        res@gsnDraw = False
        res@gsnFrame = False

        end_hour = 72

        wtype = "png"
        img = draw_dir + "/total"
        wks = gsn_open_wks(wtype, img)

        plot = new(8, graphic)

        res@tiMainString = "(a) Mass"
        mass = tot_mass/tot_mass(0)
        plot(0) = gsn_csm_y(wks, mass(0:end_hour), res)

        res@tiMainString = "(b) Kinetic energy"
        lek = tot_ek/tot_ek(0)
        plot(1) = gsn_csm_y(wks, lek(0:end_hour), res)

        res@tiMainString = "(c) Total energy"
        e = (tot_ek+tot_ep)/(tot_ek(0)+tot_ep(0))
        plot(2) = gsn_csm_y(wks, e(0:end_hour), res)

        res@tiMainString = "(d) Divergence"
        div = tot_div/tot_div(0)
        plot(3) = gsn_csm_y(wks, div(0:end_hour), res)

        res@tiMainString = "(e) Vorticity"
        vor = tot_vor/tot_vor(0)
        plot(4) = gsn_csm_y(wks, vor(0:end_hour), res)

        res@tiMainString = "(f) Enstrophy"
        ens = tot_ens/tot_ens(0)
        plot(5) = gsn_csm_y(wks, ens(0:end_hour), res)

        res@tiMainString = "(g) Potential vorticity"
        pvor = tot_pvor/tot_pvor(0)
        plot(6) = gsn_csm_y(wks, pvor(0:end_hour), res)

        res@tiMainString = "(h) Potential enstrophy"
        pens = tot_pens/tot_pens(0)
        plot(7) = gsn_csm_y(wks, pens(0:end_hour), res)

        panel_res = True
        panel_res@gsnMaximize = True

        panel_res@txString = "Total phycical variable change"

        panel_res@gsnPanelRowSpec = True
        panel_res@gsnPanelCenter  = False

        gsn_panel(wks, plot, (/3,3,2/), panel_res)

        delete(wks)

    end

    ; z, u, v <<<2

    undef("plot_zuv")
    procedure plot_zuv(hour:integer)
    local plot, lz, lu, lv, wtype, img, wks, panel_res
    begin

        plot = new(3, graphic)

        wtype = "png"
        img = draw_dir + "/zuv_" + hour + "th_hour"
        wks = gsn_open_wks(wtype, img)

        ; set sub fig res <<<3

        res = True
        res@gsnDraw = False
        res@gsnFrame = False

        res@cnInfoLabelOn = False
        res@cnFillOn = True

        res@mpCenterLonF = 180
        res@mpMinLonF = 0
        res@mpMaxLonF = 360

        ; subplots  <<<3

        res@tiMainString = "(a) Potential Height"
        plot(0) = gsn_csm_contour_map(wks, z(hour, :, :), res)

        res@tiMainString = "(b) Zonal Wind"
;        plot(1) = gsn_csm_contour_map(wks, lu, res)
        plot(1) = gsn_csm_contour_map(wks, u(hour, :, :), res)

        res@tiMainString = "(c) Longitinual Wind"
        plot(2) = gsn_csm_contour_map(wks, v(hour, :, :), res)
;        plot(2) = gsn_csm_contour_map(wks, lv, res)

        ; set pannel res <<<3

        panel_res = True
        panel_res@gsnMaximize = True

        if (hour .eq. 0) then 
            panel_res@txString = "Initial z, u, v"
        else 
            if (hour .eq. 1) then 
                panel_res@txString = "z, u, v after " + hour + " hour"
            else
                panel_res@txString = "z, u, v after " + hour + " hours"
            end if
        end if

        panel_res@gsnPanelRowSpec = True

        gsn_panel(wks, plot, (/1,2/), panel_res)

        delete(wks)

    end

    ; plots <<<1

    ; z, u, v field after xxx hour
    plot_zuv(0)
    plot_zuv(1)
    plot_zuv(2)
    plot_zuv(3)
    plot_zuv(4)
    plot_zuv(6)
    plot_zuv(12)
    plot_zuv(24)
    plot_zuv(48)
    plot_zuv(72)

    ; conservation of some total physical variables
    plot_total

    ; time series of potential height at 50N, 0E
    plot_point_z
    
    ; Kinetic energy harmonic waves in 50N
    plot_ek_harm

end
