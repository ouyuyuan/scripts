
; Description: z, u, v field
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-19 07:07:40 CST
; Last Change: 2013-04-19 15:31:05 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; retrieve data <<<1

;    data_dir = "/home/ou/archive/data/ymod"
;    data_dir = "/home/ou/archive/data/ymod"
    data_dir = "/home/ou/mount/101/models/gpem/data"
    draw_dir = "/home/ou/archive/drawing/ymod"
    fin      = data_dir + "/zuv.dat"

    nlat = 37
    nlon = 72
    nrec = 301
;    nrec = 4

    z = new((/nrec,nlat,nlon/),"float")
    u = new((/nrec,nlat,nlon/),"float")
    v = new((/nrec,nlat,nlon/),"float")

    do rec = 0, nrec - 1
        z(rec,:,:) = fbindirread(fin,3*rec+0,(/nlat,nlon/),"float")
        u(rec,:,:) = fbindirread(fin,3*rec+1,(/nlat,nlon/),"float")
        v(rec,:,:) = fbindirread(fin,3*rec+2,(/nlat,nlon/),"float")
    end do


    ; set sub fig res <<<1

    res = True
    res@gsnDraw = False
    res@gsnFrame = False

    res@cnInfoLabelOn = False
    res@cnFillOn = True

    res@mpCenterLonF = 180
    res@mpMinLonF = 0
    res@mpMaxLonF = 360

    ; set att <<<1

    lat        = fspan(-90,90,nlat) ; NOT ispan
    lat@units  = "degrees_north"
    lon        = fspan(0,355,nlon)
    lon@units  = "degrees_east"
    time       = fspan(0,nrec-1,nrec)
    time@units = "day"

    z!0         = "time"
    z&time      = time
    z!1         = "lat"
    z&lat       = lat
    z!2         = "lon"
    z&lon       = lon

    u!0         = "time"
    u&time      = time
    u!1         = "lat"
    u&lat       = lat
    u!2         = "lon"
    u&lon       = lon

    v!0         = "time"
    v&time      = time
    v!1         = "lat"
    v&lat       = lat
    v!2         = "lon"
    v&lon       = lon

    z@long_name = "potential height"
    u@long_name = "horizontal component of wind-vector"
    v@long_name = "vertical component of wind-vector"

    z@units     = "m"
    u@units     = "m/s"
    v@units     = "m/s"

    ; plot func <<<1

    undef("plot_zuv")
    procedure plot_zuv(n:integer)
    local plot, lz, lu, lv, wtype, img, wks, panel_res
    begin

        lz = z(n,:,:)
        lu = u(n,:,:)
        lv = v(n,:,:)

        plot = new(3, graphic)

        wtype = "png"
        img = draw_dir + "/zuv_" + n + "th_rec"
        wks = gsn_open_wks(wtype, img)

        res@tiMainString = "(a) Potential Height"
        plot(0) = gsn_csm_contour_map(wks, lz, res)

        res@tiMainString = "(b) Zonal Wind"
        plot(1) = gsn_csm_contour_map(wks, lu, res)

        res@tiMainString = "(c) Longitinual Wind"
        plot(2) = gsn_csm_contour_map(wks, lv, res)

        ; set pannel res <<<2

        panel_res = True
        panel_res@gsnMaximize = True

        if (n .eq. 0) then 
            panel_res@txString = "Initial RH wave"
        else 
            if (n .eq. 1) then 
                panel_res@txString = "RH wave after " + n + " day"
            else
                panel_res@txString = "RH wave after " + n + " days"
            end if
        end if

        panel_res@gsnPanelRowSpec = True

        gsn_panel(wks, plot, (/1,2/), panel_res)

        delete(wks)

    end

    ; plot nth day RH wave <<<1

    plot_zuv(0)
    plot_zuv(160)
    plot_zuv(172)
    plot_zuv(200)

    ; z in a single point <<<1

    delete(res)
    res = True

    ; 50 N , 0E
    pz = z(:,28,0)

    wtype = "png"
    img = draw_dir + "/z_50N_0E"
    wks = gsn_open_wks(wtype, img)

    res@tiMainString = "Potential height at 50N, 0E"
    plot = gsn_csm_xy(wks, time, pz, res)

end
