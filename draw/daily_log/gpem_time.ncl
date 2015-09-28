
; Description: plot used time in GPEM coding
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-23 18:12:38 CST
; Last Change: 2013-03-23 19:42:45 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ori_date = "2012,10,01"
    beg_date = "2013,03,07"
    end_date = "2013,03,22"
    jobid = 3  ; code gpem <1:3>, ncdump to get

    nc = addfile("/home/ou/archive/data/daily_log/daily_log.nc","r")
    jobs = nc->job;

    wtype = "png"
    file_dir = "/home/ou/archive/drawing/daily_log"
    filename = file_dir + "/gpem_time"
    wks = gsn_open_wks(wtype,filename)

    ; get plan data <<<1

    quote=inttochar(34)
    cmd = "perl -e " + "'" + "use Date::Calc qw(Delta_Days); " + "printf " + \ 
        quote + "%d\n" + quote + ", Delta_Days(" + ori_date + "," + beg_date + \
        ");'"
    bday = stringtointeger(systemfunc(cmd))

    cmd = "perl -e " + "'" + "use Date::Calc qw(Delta_Days); " + "printf " + \ 
        quote + "%d\n" + quote + ", Delta_Days(" + ori_date + "," + end_date + \
        ");'"
    eday = stringtointeger(systemfunc(cmd))

    gpem = jobs(bday:eday,:)

    time = new(eday-bday+1, float)
    time = 0
    
    dim = dimsizes(gpem)
    days = ispan(0,dim(0)-1,1)

    do i = 0, dim(0)-1
        do j = 0, dim(1)-1
            if ( ismissing(gpem(i,j)) ) then
                continue
            end if

            if ( gpem(i,j) .eq. jobid ) then 
                time(i) = time(i) + 1
            end if
        end do 
    end do
    
    time = time/60.0

    time@long_name = "time(hour)"

    ; set res <<<1

    res = True
    res@gsnMaximize = True
    res@tiMainString = "Used time in coding GPEM ~C~" + "total: " + \
        sum(time) + " " + "average: " + avg(time)

    res@xyMarkLineMode = "MarkLines"
    res@xyMarker = 1 
    res@xyMarkerColor = "red"
    res@xyMarkerSizeF = 0.04
    res@xyLineThicknessF = 3.0

    plot = gsn_csm_xy(wks, days, time, res)

    delete(wks)
    delete(plot)
    delete(jobs)

end
