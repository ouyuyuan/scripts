
; Description: test plots to verify model modification
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2013-03-19 07:07:40 CST
; Last Change: 2013-05-11 07:19:58 CST

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
    foutname = data_dir + "/ncep_zuv.nc"

    ; retrieve z <<<2

    finz = addfile(ncep_hgt, "r")

;    hgt = finz->hgt({17601816}, {500}, :, :)
    hgt = finz->hgt(0, {500}, {-90:90:2}, {0:357.5:2})
    z = (hgt + hgt@add_offset)*hgt@scale_factor

    z@dataset = "regrid from " + hgt@dataset
    z@_FillValue = (hgt@missing_value + hgt@add_offset)*hgt@scale_factor
    z@statistic = hgt@statistic
    z@level = "500hPa"
    z@long_name = hgt@long_name
    z@time = "2009-1-1 00:00"

    copy_VarCoords(hgt, z)

    ; retrieve u <<<2

    finu = addfile(ncep_uwnd, "r")

    uwnd = finu->uwnd(0, {500}, {-90:90:2}, {0:357.5:2})
    u = (uwnd + uwnd@add_offset)*uwnd@scale_factor

    u@dataset = "regrid from " + uwnd@dataset
    u@_FillValue = (uwnd@missing_value + uwnd@add_offset)*uwnd@scale_factor
    u@statistic = uwnd@statistic
    u@level = "500hPa"
    u@long_name = uwnd@long_name
    u@time = "2009-1-1 00:00"

    copy_VarCoords(uwnd, u)

    ; retrieve v <<<2

    finv = addfile(ncep_vwnd, "r")

    vwnd = finv->vwnd(0, {500}, {-90:90:2}, {0:357.5:2})
    v = (vwnd + vwnd@add_offset)*vwnd@scale_factor

    v@dataset = "regrid from " + vwnd@dataset
    v@_FillValue = (vwnd@missing_value + vwnd@add_offset)*vwnd@scale_factor
    v@statistic = vwnd@statistic
    v@level = "500hPa"
    v@long_name = vwnd@long_name
    v@time = "2009-1-1 00:00"

    copy_VarCoords(vwnd, v)

    ; z in 500 <<<1

    procedure plot_z()
    begin

        wtype = "png"
        img = draw_dir + "/ncep_z_500"
        wks = gsn_open_wks(wtype, img)

        res = True
        res@gsnMaximize = True

        res@cnInfoLabelOn = False
        res@cnFillOn = True

        res@gsnPolar = "NH"
        res@mpMinLatF = 0

        res@tiMainString = "500 hPa, 2009-1-1 00:00"
        plot = gsn_csm_contour_map_polar(wks, z, res)

        delete(wks)

    end

    ; output regrid z <<<1

    procedure output_zuv()
    begin

        system("rm "+foutname)
        fout = addfile(foutname, "c")
        fout->z = z
        fout->u = u
        fout->v = v

    end

    ; plot <<<1
    
    plot_z
    output_zuv

end
