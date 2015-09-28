
; Description: test plots to verify model modification
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-19 07:07:40 CST
; Last Change: 2013-05-14 10:35:08 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    draw_dir = "/home/ou/archive/drawing/gpem/rh_tests/current"

    filename = "/home/ou/archive/data/gpem/gpem_rh_tests.nc"

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

        wtype = "pdf"
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

        wtype = "pdf"
        img = draw_dir + "/ek_harmonic"
        wks = gsn_open_wks(wtype, img)

        plot = new(5, graphic)

;        lek = ek(0,{50},:)

        nlons = 72

        res@tiMainString = "Initial"
        finfo = fourier_info(ek(0, {50}, :), nlons/2, 1.0)
        plot(0) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 150 days"
        finfo = fourier_info(ek(150,{50},:), nlons/2, 1.0)
        plot(1) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 170 days"
        finfo = fourier_info(ek(170,{50},:), nlons/2, 1.0)
        plot(2) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 200 days"
        finfo = fourier_info(ek(200,{50},:), nlons/2, 1.0)
        plot(3) = gsn_csm_y(wks, finfo(0,:), res)

        res@tiMainString = "After 250 days"
        finfo = fourier_info(ek(250,{50},:), nlons/2, 1.0)
        plot(4) = gsn_csm_y(wks, finfo(0,:), res)

        panel_res = True
        panel_res@gsnMaximize = True

        panel_res@txString = "Kinetic energy harmonics in 50N"

        panel_res@gsnPanelRowSpec = True
        panel_res@gsnPanelCenter  = False

        gsn_panel(wks, plot, (/3,2/), panel_res)

        delete(wks)

    end
    
    ; total phys. var. <<<2

    procedure plot_total()
    begin

        res = True
        res@gsnDraw = False
        res@gsnFrame = False

        res@xyLineThicknessF = 2
        res@xyLineColor = "blue"

        end_day = 300

        wtype = "pdf"
;        wtype@wkWidth = 3000
;        wtype@wkHeight = 3000

        img = draw_dir + "/total"
        wks = gsn_open_wks(wtype, img)

        plot = new(8, graphic)

        res@tiMainString = "(a) Mass"
        mass = tot_mass/tot_mass(0)
        plot(0) = gsn_csm_y(wks, mass(0:end_day), res)

        res@tiMainString = "(b) Kinetic energy"
        lek = tot_ek/tot_ek(0)
        plot(1) = gsn_csm_y(wks, lek(0:end_day), res)

        res@tiMainString = "(c) Total energy"
        e = (tot_ek+tot_ep)/(tot_ek(0)+tot_ep(0))
        plot(2) = gsn_csm_y(wks, e(0:end_day), res)

        res@tiMainString = "(d) Divergence"
        div = tot_div/tot_div(0)
        plot(3) = gsn_csm_y(wks, div(0:end_day), res)

        res@tiMainString = "(e) Vorticity"
        vor = tot_vor/tot_vor(0)
        plot(4) = gsn_csm_y(wks, vor(0:end_day), res)

        res@tiMainString = "(f) Enstrophy"
        ens = tot_ens/tot_ens(0)
        plot(5) = gsn_csm_y(wks, ens(0:end_day), res)

        res@tiMainString = "(g) Potential vorticity"
        pvor = tot_pvor/tot_pvor(0)
        plot(6) = gsn_csm_y(wks, pvor(0:end_day), res)

        res@tiMainString = "(h) Potential enstrophy"
        pens = tot_pens/tot_pens(0)
        plot(7) = gsn_csm_y(wks, pens(0:end_day), res)

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
    procedure plot_zuv(day:integer)
    local plot, lz, lu, lv, wtype, img, wks, panel_res
    begin

        plot = new(3, graphic)

        wtype = "pdf"
        img = draw_dir + "/zuv_" + day + "th_rec"
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
        plot(0) = gsn_csm_contour_map(wks, z(day, :, :), res)

        res@tiMainString = "(b) Zonal Wind"
;        plot(1) = gsn_csm_contour_map(wks, lu, res)
        plot(1) = gsn_csm_contour_map(wks, u(day, :, :), res)

        res@tiMainString = "(c) Longitinual Wind"
        plot(2) = gsn_csm_contour_map(wks, v(day, :, :), res)
;        plot(2) = gsn_csm_contour_map(wks, lv, res)

        ; set pannel res <<<3

        panel_res = True
        panel_res@gsnMaximize = True

        if (day .eq. 0) then 
            panel_res@txString = "Initial RH wave"
        else 
            if (day .eq. 1) then 
                panel_res@txString = "RH wave after " + day + " day"
            else
                panel_res@txString = "RH wave after " + day + " days"
            end if
        end if

        panel_res@gsnPanelRowSpec = True

        gsn_panel(wks, plot, (/1,2/), panel_res)

        delete(wks)

    end

    ; plots <<<1

    ; z, u, v field after xxx day
    plot_zuv(0)
    plot_zuv(160)
    plot_zuv(172)
    plot_zuv(200)
    plot_zuv(250)

    ; conservation of some total physical variables
    plot_total

    ; time series of potential height at 50N, 0E
    plot_point_z
    
    ; Kinetic energy harmonic waves in 50N
    plot_ek_harm

end
