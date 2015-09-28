
; Description: trend of global average properties, e.g. potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-24 21:40:23 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/home/ou/archive/scripts/utils/ncl.ncl"

begin
  data_dir = "/home/ou/archive/data/licom/"
  inp = data_dir + "levitus_ts.nc"

  f = addfile( inp, "r" )
  st = f->st(0,:,:,:)
  ss = f->ss(0,:,:,:)
  delete(f)
  s_an_ave = ou_cal_hor_mean( ou_cal_ver_mean(st) )
  s_mn_ave = ou_cal_hor_mean( ou_cal_ver_mean(ss) )

  print(s_an_ave+0)
  print(s_mn_ave+0)
end
