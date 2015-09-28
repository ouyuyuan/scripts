load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;=====================================================================
YEAR="0105"
print("the YEAR is:"+YEAR)

DIR_in		=	"/disk4/lhl2011/licom_evaluation/test_star_ahisop1000_athkdf500/"
DIR_out		=	"/disk4/lhl2011/licom_evaluation/test_star_ahisop1000_athkdf500/"
ncs 		=	systemfunc("ls "+DIR_in+"MMEAN"+YEAR+".nc")

nc_num		=	dimsizes(ncs)

;;; I think WK1 lies on T-grid, and  MMEAN*.nc has only T-grid, U-grid must be caculated manually.
;;; U-grid and its lat lon is different from that of T-grid.
nc0="/disk4/lhl2011/licom/test_star_ahisop1000_athkdf500/exe/MMEAN0001-01.nc"
fin0	= addfile(nc0,"r")  
UU      = fin0->us(0,0,::-1,0:359)
not_vit=where(ismissing(UU) .eq. "True", 0, 1)      ;;; sea is 1, land is 0.
LEV1 = fin0->lev1*(-1)
num_lev1  = dimsizes(LEV1)
LEV=fin0->lev*(-1.)
LAT=fin0->lat(::-1)
LON=fin0->lon(0:359)

num_lev  = dimsizes(LEV)
dlev = LEV1(1:num_lev1-1)-LEV1(0:num_lev1-2)
num_lat   = dimsizes(LAT)
dlat = (/LAT/)
dlat=0.0
dlat(1:num_lat-1) = LAT(1:num_lat-1) - LAT(0:num_lat-2)     
;;; U-grid lies south of T-grid,No NP
;;; but when bsf is achieved, we still store it in the T-grid
deg2rad = atan(1.0)/45.0
dy =  6.371* deg2rad * dlat
delete(fin0)

do n=0,nc_num-1
  nc=ncs(n)
;  print("")
;  print("====================================  "+n+"  ======================================")
;  print("Now,the nc is:	"+nc)
  fin		=	addfile(nc,"r")  
  u_temp = fin->us(0,:,::-1,0:359)
  u = u_temp
  delete(u_temp)
  
  dlev_conform   = conform_dims(dimsizes(u),dlev,0)
  dy_conform   = conform_dims(dimsizes(u),dy,1)
  temp=  u * dlev_conform * dy_conform
;;; still missing where FillValue exits in u, temp is filled exactly the same as u

  WK2 = dim_sum_n_Wrap(temp,0) 
  WK2=WK2
  delete(u)
  delete(dlev_conform)
  delete(dy_conform)
  delete(temp)

;;; calculate from S to N, then if WK2_j = missing then WK1_j = missing; 	if WK2_j is not missing then WK1_j is not missing.
;;;                 as a result,if WK2_j-1 = missing then WK1_j-1 = missing;
;;;                 as a result,if WK2_j-1 = missing but WK2_j is not missing then let WK1_j = 0.5 * WK2_j.
;;; -------------- above is a direct calculation, but here is a amart one, all are zero, missing won't set until at last. -------

WK1=(/UU/)
WK1=0.0
;;; convert _FillValue to 0.0 and then delete all the attributes of WK2 
;;; WK1(j,:)= ?? : ?? will cover all of WK1, even FillValue grid.
;;; that's very annoying.
;;; but to BSF, it's quite fittable.
;;; Remeber that WK1 has its FillValue, WK1(0,:) must be set.
;;; Itegration must be done from North to South, or you will get wrong values.

  do j=1,num_lat-1
    j1=num_lat-j-1
    j2=num_lat-j
    WK1(j1,:) = dim_avg_n(WK2(j1:j2,:),0)
    WK1(j1,:) = dim_sum_n(WK1(j1:j2,:),0)
  end do
  delete(WK2)
  WK1 = where(ismissing(UU) .eq. "False",WK1,UU@_FillValue)

;;; ================================== output ==================================")

  WK1!0	= "lat"
  WK1!1	= "lon"
;;;  WK1&lat	= LAT*(-1.)
  WK1&lat	= LAT
  WK1&lon	= LON
  WK1@long_name	= "Barotropic Streamfunction"
  WK1@units	= "Sv"

  WK1_smth = smth9_Wrap(WK1, 0.50, 0.25, True)

  system("rm "+DIR_out+"bsf"+YEAR+".nc")
  fout	=	addfile(DIR_out+"bsf"+YEAR+".nc","c")       ;;===== for all levs compare
  fout->bsf = WK1_smth

  delete(WK1)
end do
;=====================================================================
