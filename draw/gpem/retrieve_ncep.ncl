
; Description: retrieve ncep data for input in GPEM
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-19 07:07:40 CST
; Last Change: 2013-05-11 15:00:42 CST

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

    ; def var <<<1

    draw_dir = "/home/ou/archive/drawing/gpem/predict"
    data_dir = "/home/ou/archive/data/gpem"
    ncep_hgt = data_dir + "/ncep1_hgt_2009_4xdaily.nc"
    ncep_uwnd = data_dir + "/ncep1_uwnd_2009_4xdaily.nc"
    ncep_vwnd = data_dir + "/ncep1_vwnd_2009_4xdaily.nc"
    foutname = data_dir + "/ncep_z.nc"

    ; retrieve z <<<1

    finz = addfile(ncep_hgt, "r")

;    hgt = finz->hgt({17601816}, {500}, :, :)
    hgt = finz->hgt(:, {500}, {-90:90:2}, {0:357.5:2})
    z = hgt*hgt@scale_factor + hgt@add_offset

    z@dataset = "regrid from " + hgt@dataset
    z@_FillValue = hgt@missing_value*hgt@scale_factor + hgt@add_offset
    z@statistic = hgt@statistic
    z@level = "500hPa"
    z@long_name = hgt@long_name

    copy_VarCoords(hgt, z)

    ; write var. <<<1

    nrec = 365*4
    system("rm -f "+foutname)
    fout = addfile(foutname, "c")
;    filedimdef(fout, "time", -1, True)
    filedimdef(fout, "time", nrec, False)
    fout->z = z

end
