
; Description: China with Lambert projection
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-02-23 20:39:01 BJT
; Last Change: 2015-08-21 17:05:19 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/path/to/my_functions.ncl"

datDir = "/home/ou/archive/data/kxh/wrf/"
inFile = datDir + "abc.nc"

f = addfile(inFile, "r")
Time = f->Time
delete(f)

dates = new(4, string)
ids   = new(4, integer)

do year = 1900, 1902
  dates(0) = year+"-01-01 00:00:00"
  dates(1) = year+"-01-31 00:00:00"

  dates(2) = year+"-02-01 00:00:00"
  dates(3) = year+"-02-28 00:00:00"

  if (isleapyear(year)) then
    dates(3) = year+"-02-29 00:00:00"
  end if

  ids = my_str2t(dates, Time)
  ouFile = datDir + "prep_mon_" + year + ".nc"
  cmd = "cdo seltime," + ids + " " + inFile + " " + ouFile

  print(cmd + "")
end do
