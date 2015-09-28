
; Description: Global average of each layers
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-07-10 09:19:53 BJT
; Last Change: 2014-09-04 08:18:55 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/home/ou/archive/scripts/utils/pcom.ncl"

begin

  data_dir = "/home/ou/archive/data/pcom/moc_re_s"
  outfile  = data_dir + "/post/layer_ave.nc"

  nyear  = 500
;  nyear  = 5

  ; initial field
  print("Calculate initial file pcom_ini.nc")
  f = addfile( "/home/ou/archive/data/pcom/input/pcom_ini.nc", "r" )
  t = f->ct(:,:,:)
  s = f->sa(:,:,:)
  z = f->z(:)
  delete(f)

  nlev = dimsizes(z)
  pt = new( (/nyear+1, nlev/), typeof(t) )
  sa = new( (/nyear+1, nlev/), typeof(s) )

  do lev = 0, nlev - 1
    pt(0, lev) = pcom_area_mean( t(lev, :, :) )
    sa(0, lev) = pcom_area_mean( s(lev, :, :) )
  end do

  do yr = 1, nyear
    fname = sprinti( "year_%0.4i.nc", yr )
    print("Calculate " + fname)
    f = addfile( data_dir + "/" + fname, "r")
    t = f->pt(0,:,:,:)
    s = f->sa(0,:,:,:)
    delete(f)
    do lev = 0, nlev - 1
      pt(yr, lev) = pcom_area_mean( t(lev, :, :) )
      sa(yr, lev) = pcom_area_mean( s(lev, :, :) )
    end do
  end do

;  time = fspan(0, nyear, nyear+1)
  time = ispan(0, nyear, 1)
  time@units = "years since model initial run"
  pt!0 = "time"
  pt&time = time
  sa!0 = "time"
  sa&time = time

  pt!1 = "z"
  pt&z = z
  sa!1 = "z"
  sa&z = z

  system("rm -f " + outfile)
  f = addfile(outfile, "c")
  filedimdef( f, "time", -1, True )
  f->pt = pt
  f->sa = sa

end
