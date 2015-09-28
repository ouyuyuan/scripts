
; Description: calc. vertical mixing coeff. by temperature profile
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-10-12 09:06:46 BJT
; Last Change: 2014-10-16 21:23:51 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  nc = "/home/ou/archive/data/pcom/input/pcom_ini.nc"
  f = addfile( nc, "r" )
  ct = f->ct
  delete(f)

  dims = dimsizes(ct)
  nz = dims(0)
  nlat = dims(1)
  nlon = dims(2)

  kappa = ct
  kappa = 0
  kmin = 0.1
  kmax = 20

  tmax = conform(ct, ct(0,:,:), (/1,2/))
  tmin = ct
  tmin = -2

;  do j = 0, nlat - 1
;    do i = 0, nlon - 1
;      tmax = ct(0,j,i)
;      tmin = ct(nz-1,j,i)
      ; tmin set to the value of sea bottom
;      if (ismissing(tmin))
;        idx = ind(ismissing(ct(:,j,i)))
;        tmin = ct(idx(0),j,i)
;        kappa(idx,j,i) = (kmax - kmin) / (tmax - tmin) * (ct(idx,j,i) - tmin) + kmin
;        delete(idx)
;      else
        ; two point form of a line
;        kappa(:,j,i) = (kmax - kmin) / (tmax - tmin) * (ct(:,j,i) - tmin) + kmin
;      end if
;    end do
;  end do

  kappa = (kmax - kmin) / (tmax - tmin) * (ct - tmin) + kmin
  kappa = where(ismissing(kappa), kmin, kappa)
  kappa = where(kappa.lt.kmin, kmin, kappa)
  kappa = where(kappa.gt.kmax, kmax, kappa)
  kappa = smth9( kappa, 0.5, 0.25, False )

  kappa@long_name = "vertical coefficient"
  kappa@units = ""

  nc = "/home/ou/archive/data/pcom/input/vmix_ou.nc"
  system("rm -f " + nc)
  f = addfile( nc, "c" )
  f->vmix = kappa
  f@data = "vertical mixing coefficient paramerized by simple method"
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")

end
