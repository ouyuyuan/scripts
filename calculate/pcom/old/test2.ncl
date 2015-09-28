torad = 3.14159265 / 180
f = addfile("/home/ou/archive/data/woa09/salinity_annual_1deg.nc","r")
lat = f->lat * torad
depth = f->depth
s_an = f->s_an(0,:,:,:)

nz = dimsizes(depth)

midz = depth*0
midz(0:nz-2) = ( depth(0:nz-2) + depth(1:nz-1) ) / 2.0
midz(nz-1) = (6000+5500)/2

dz = depth*0
dz(0) = 5
dz(1:nz-1) = midz(1:nz-1) - midz(0:nz-2)

weight = conform(s_an, cos(lat), 1) * conform(s_an, dz, 0)
weight = where(ismissing(s_an), 0, weight)
weight = weight/sum(weight)

ave = sum(s_an*weight)

print(ave+0)
