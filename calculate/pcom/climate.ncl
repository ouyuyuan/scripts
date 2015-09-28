
; Description: calc. a climate filed from the monthly data
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-21 20:33:57 BJT
; Last Change: 2014-11-14 15:38:15 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/media/pcom/exp17_ws_control_cycle_re/"

;  yb = 55
;  ye = 64

  yb = 41
  ye = 50

  mb = (yb - 1) * 12 + 1
  me = ye * 12
  do mon = mb, me 
   fname = data_dir + sprinti( "N%0.8i.nc", mon )
   f = addfile( fname, "r" )
   print("Processing " + fname)
   if ( mon.eq.mb ) then
     u = f->u(0,:,:,:)
     v = f->v(0,:,:,:)
     w = f->w(0,:,:,:)
     pt = f->pt(0,:,:,:)
     sa = f->sa(0,:,:,:)
     ssh = f->ssh(0,:,:)
   else
     u = u + f->u(0,:,:,:)
     v = v + f->v(0,:,:,:)
     w = w + f->w(0,:,:,:)
     pt = pt + f->pt(0,:,:,:)
     sa = sa + f->sa(0,:,:,:)
     ssh = ssh + f->ssh(0,:,:)
   end if
   delete(f)
  end do
  
  nmon = me - mb + 1
  u = u / nmon
  v = v / nmon
  w = w / nmon
  pt = pt / nmon
  sa = sa / nmon
  ssh = ssh / nmon

  fv = default_fillvalue("float")
  big = 1e10
   u = where(u.gt.big, fv, u)
   delete(u@missing_value)
   v = where(v.gt.big, fv, v)
   delete(v@missing_value)
   w = where(w.gt.big, fv, w)
   delete(w@missing_value)
   pt = where(pt.gt.big, fv, pt)
   delete(pt@missing_value)
   sa = where(sa.gt.big, fv, sa)
   delete(sa@missing_value)
   ssh = where(ssh.gt.big, fv, ssh)
   delete(ssh@missing_value)

   u@_FillValue = fv
   v@_FillValue = fv
   w@_FillValue = fv
   pt@_FillValue = fv
   sa@_FillValue = fv
   ssh@_FillValue = fv

  outfile = data_dir + "climate_y"+yb+"-y"+ye+".nc"
  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  f->u = u
  f->v = v
  f->w = w
  f->pt = pt
  f->sa = sa
  f->ssh = ssh
  f@data = "climate mean filed of year " + yb + " to year " + ye
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
