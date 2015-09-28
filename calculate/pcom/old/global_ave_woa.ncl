
; Description: trend of global average properties, e.g. potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-24 07:16:27 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/home/ou/archive/scripts/utils/ncl.ncl"

begin
  data_dir = "/home/ou/archive/data/woa09/"
  out = data_dir + "post/salinity_global_ave.nc"
  inp = data_dir + "salinity_annual_1deg.nc"

  f = addfile( inp, "r" )
  s_an = f->s_an(0,:,:,:)
  s_mn = f->s_mn(0,:,:,:)
  delete(f)
  s_an_ave = ou_cal_hor_mean( ou_cal_ver_mean(s_an) )
  s_mn_ave = ou_cal_hor_mean( ou_cal_ver_mean(s_mn) )

  system("rm -f " + out)
  f = addfile(out, "c")
  f->s_an_ave = s_an_ave
  f->s_mn_ave = s_mn_ave
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
end
