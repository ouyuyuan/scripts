
; Description: 
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-31 18:58:51 BJT
; Last Change: 2014-10-31 19:08:32 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

nc_gradient = "/home/ou/archive/data/plot/pcom/ws_exp/bcp_gradient.nc"
nc = addfile(nc_gradient, "r")
px_ori = nc->px
py_ori = nc->py
lat_ori = nc->lat
lon_ori = nc->lon
t_ori = nc->t
delete(nc)

lat = doubletofloat(lat_ori)
lon = doubletofloat(lon_ori)
t   = doubletofloat(t_ori)

px = doubletofloat(px_ori)
py = doubletofloat(py_ori)
px!0 = "t"
px!1 = "lat"
px!2 = "lon"
px&t = t
px&lat = lat
px&lon = lon

copy_VarAtts(px_ori,px)
copy_VarAtts(py_ori,py)
copy_VarAtts(lat_ori,lat)
copy_VarAtts(lon_ori,lon)
copy_VarAtts(t_ori,t)

py!0 = "t"
py!1 = "lat"
py!2 = "lon"
py&t = t
py&lat = lat
py&lon = lon

outfile = getenv("NCL_ARG_1")
system("rm -f " + outfile)
f = addfile(outfile, "c")

f->px = px
f->py = py

f@data = "geostrophic wind"
f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
", " + systemfunc("date")
delete(f)
