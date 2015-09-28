
; Description: type of jobs
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-01-28 08:42:37 CST
; Last Change: 2013-03-23 09:27:25 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    ncFile = addfile("/home/ou/archive/data/daily_log/daily_log.nc","r")
    file_dir = "/home/ou/archive/drawing/daily_log"
    jobs = ncFile->job

    ; plot func <<<1

    ; na: start day, nb: end day

    procedure plot_type(na:integer, nb:integer)
    begin

        dim = dimsizes(jobs)

        if ( nb .le. dim(0) ) then
            job = jobs(na-1:nb-1,:)
        else
            job = jobs(na-1:,:)
        end if

        wtype = "png"

        filename = file_dir + "/job_type_" + na + "-" + nb + "_days"
        wks = gsn_open_wks(wtype, filename)

        res = True
        res@gsnDraw = False
        res@gsnFrame = False

        res@cnInfoLabelOn = False
        res@cnLevelSpacingF = 1
        res@cnLineLabelsOn = False

        gsn_define_colormap(wks,"wh-bl-gr-ye-re")

        plot = new(4,graphic)
        title = (/"All jobs", "Work", "Learn", "Other"/)

        res@cnLinesOn = False
        do i = 0, dimsizes(title)-1
            res@tiMainString = title(i)
            plot(i) = gsn_contour(wks, job, res)
        end do

        opt = True
        opt@gsnShadeMid = "black"

        plot(0) = gsn_contour_shade(plot(0), 1, 18, opt)

        opt@gsnShadeMid = "red"
        plot(1) = gsn_contour_shade(plot(1), 1, 6, opt)

        opt@gsnShadeMid = "blue"
        plot(2) = gsn_contour_shade(plot(2), 7, 11, opt)

        opt@gsnShadeMid = "green"
        plot(3) = gsn_contour_shade(plot(3), 12, 19, opt)

        panres = True
        panres@gsnMaximize = True

        gsn_panel(wks, plot, (/2,2/), panres)

        delete(plot)
        delete(res)
        delete(opt)
    end

    ; plot days <<<1

;    plot_type(1,70)
;    plot_type(71,140)
    plot_type(141,210)

end
