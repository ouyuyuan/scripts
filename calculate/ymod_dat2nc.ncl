
; Description: convert binary files written by ymod to nc files
;
;      Author: OU Yuyuan <ouyuyuan@gmail.com>
;     Created: 2012-04-19 08:46:43 CST
; Last Change: 2013-03-18 21:59:00 CST

;in zuv.dat:
;binary, direct, record len = nx*ny (72*37)
;order: z,u,v
;float presison
;300 day + 1, write z,u,v per day, so 301 times

begin

    ; data info <<<1

    data_dir = "/snfs01/ou/data/ymod"
    binFile = data_dir + "/zuv.dat"
    fname = data_dir + "/zuv.nc"
    nlat = 37
    nlon = 72
    nrec = 300

    ; create nc file <<<1

    system("rm " + fname)
    fout = addfile(fname,"c")
    fout@title  = "z, u, v"
    fout@source = "converted results of GPEM of YU Haiyang"
    fout@creation_date = systemfunc("date +%Y-%m-%d\ %H:%M:%S\ CST")

    dim_names = (/"time", "lat", "lon"/)
    dim_sizes = (/nrec, nlat, nlat/)
    dim_unlim = (/False, False, False/)
    filedimdef(fout, dim_names, dim_sizes, dim_unlim)

    ; retrieve data from .dat <<<1

    z = new((/nrec,nlat,nlon/),"float")
    u = new((/nrec,nlat,nlon/),"float")
    v = new((/nrec,nlat,nlon/),"float")

    do rec = 0, nrec - 1
        z(rec,:,:) = fbindirread(binFile,3*rec+0,(/nlat,nlon/),"float")
        u(rec,:,:) = fbindirread(binFile,3*rec+1,(/nlat,nlon/),"float")
        v(rec,:,:) = fbindirread(binFile,3*rec+2,(/nlat,nlon/),"float")
    end do

    ; assign atts <<<1

    z@units = "m"
    u@units = "m/s"
    v@units = "m/s"

    z@long_name    = "potential height"
    u@long_name    = "horizontal component of wind-vector"
    v@long_name    = "vertical component of wind-vector"

    ; define vars <<<1

    ; dimension info <<<2

    lat = fspan(-90,90,nlat) ; NOT ispan
    lat!0 = "lat"
    lat@units = "degrees_north"

    lon = fspan(0,355,nlon)
    lon!0 = "lon"
    lon@units = "degrees_east"

    fout->lat = lat
    fout->lon = lon
;    fout->z = (/z/)
;    fout->u = (/u/)
;    fout->v = (/v/)

    ; dimension var <<<2

;    filevardef(fout, "lat", "float", "lat")
;    filevardef(fout, "lon", "float", "lon")

;    filevarattdef(fout, "lat", lat)
;    filevarattdef(fout, "lon", lon)

    ; filed var <<<2

;    filevardef(fout, "z", "float", (/"time", "lat", "lon"/))
;    filevardef(fout, "u", "float", (/"time", "lat", "lon"/))
;    filevardef(fout, "v", "float", (/"time", "lat", "lon"/))

;    filevarattdef(fout, "z", z)
;    filevarattdef(fout, "u", u)
;    filevarattdef(fout, "v", v)

    ; put var to nc <<<1

end
