
; Description: select a box of the ETOPO1 data
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-22 07:57:11 BJT
; Last Change: 2014-07-22 08:16:20 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
   data_dir = "/home/ou/archive/data/etopo"
   out_dir  = "/home/ou/archive/models/roms/matlab/data"

   fname = data_dir + "/ETOPO1_Bed_g_gmt4.nc"

Llon=-76.0;              % Left   corner longitude     % US west Coast
Rlon=-71.5;              % Right  corner longitude
Blat=38.0;                % Bottom corner latitude
Tlat=41.5;                % Top    corner latitude

   f = addfile( fname, "r" )
   z = f->z( {Tlat:Blat}, {Llon:Rlon} )
   delete(f)

  fname = out_dir + "/NewJersey_box.nc"
  f = addfile( fname, "c")
  f->topo = z

end
