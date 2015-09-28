
; Description: trend of global average properties, e.g. potential temperature
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-25 20:22:00 BJT

data_dir = "/home/ou/archive/data/woa09/"
inp = data_dir + "salinity_annual_1deg.nc"

torad = 3.14159265 / 180

f = addfile( inp, "r" )
s_an = f->s_an(0,:,:,:)
depth = f->depth
lat = f->lat * torad
lat_bnds = f->lat_bnds * torad
lon_bnds = f->lon_bnds * torad
nlev = dimsizes(depth)

midlev = depth * 0
midlev(0:nlev-2) = ( depth(0:nlev-2) + depth(1:nlev-1) ) / 2.0
midlev(nlev-1) = (6000 + 5500) / 2 ; extrapolation, check the trend of depth in WOA

dlev = depth * 0
dlev(0) = 5 ; depth(0) is 0 m in WOA
dlev(1:nlev-1) = midlev(1:nlev-1) - midlev(0:nlev-2)

;;; area using sphere formular will get the same result as rectangular formular
;dims = dimsizes(s_an)
;nlat = dims(1)
;nlon = dims(2)
;area = new( (/nlat, nlon/), float)
;do j = 0, nlat - 1
;  do i = 0, nlon - 1
;    area(j, i) = ( lon_bnds(i,2) - lon_bnds(i,1) ) * ( sin(lat_bnds(j,2) - sin(lat_bnds(j,1) )
;  end do
;end do
;wgt = conform(s_an, dlev, 0) * conform(s_an, area, (/1,2/))

wgt = conform(s_an, dlev, 0) * conform(s_an, cos(lat), 1)
wgt = where( ismissing(s_an), 0, wgt)
wgt = wgt / sum(wgt)

ave = sum(wgt * s_an)
print(ave+0)

