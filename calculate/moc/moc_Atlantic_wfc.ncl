load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   flag=1   ---    moc     ---     True   
;   flag=0   ---    moc2    ---     False (default)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
flag    = 0
YEAR="0105"
print("the YEAR is:"+YEAR)

DIRs_in="~/licom/test_star_ahisop1000_athkdf500/exe/"
DIR_out="test_star_ahisop1000_athkdf500/"
DIR_in2 = "/disk4/lhl2011/licom/data/"

ncs		=	systemfunc("cd "+DIRs_in+";ls MMEAN"+YEAR+"-*.nc")
num_nc	=	dimsizes(ncs)
if (num_nc .ne. 12)then
   print("***** Error: the number of MMEAN"+YEAR+"-??.nc is not right *****")
   print("***** ncs in "+DIR_out+" is: "+ncs+" *****")
end if
;print(ncs)

nc  = systemfunc("ls "+DIR_in2+"BASIN_362X196.nc")
;print("Now,the nc is:	"+nc)
fin	= addfile(nc,"r") 
basin = fin->ind(::-1,0:359)

nc  = systemfunc("ls "+DIR_in2+"INDEX.DATA_362X196_db.nc")
;print("Now,the nc is:	"+nc)
fin	= addfile(nc,"r") 
temp = dble2flt(fin->ind(:,::-1,0:359))
num_lev=dimsizes(fin->lev)

do i=0,num_lev-1
 temp(i,:,:) = where(basin.eq.2,temp(i,:,:),0)
end do

;print("basin:  "+basin(98,:)+"vit  "+temp(0,98,:))

vit = dim_sum_n_Wrap(temp,2)
vit = where(vit .gt. 0.5, 1, 0)
delete(temp)
;printVarSummary(vit)

moc13   = new((/1,30,196,13/),float,-1.e30)
moc     = new((/1,30,196,1/),float,-1.e30)

;do n=num_nc-1,num_nc-1
do n=0,num_nc-1
;============================================================================== vs
  Mark  = "vs"
  nc=ncs(n)
;  print("Now,the nc is:	"+nc)
  fin	=	addfile(DIRs_in+nc,"r")
  var_temp  = fin->$Mark$(0,:,::-1,0:359)
;  printVarSummary(var_temp)
  var  = dim_sum_n_Wrap(var_temp,2)
  delete(var_temp)

;============================================================================== lev
  LEV   = fin->lev
  lev1  = fin->lev1
  num_lev1  = dimsizes(lev1)
  num_lev  = dimsizes(LEV)
  dzp   = lev1(1:num_lev1-1)-lev1(0:num_lev1-2)
;  print(dzp)
  dzp_conform   = conform_dims(dimsizes(var),dzp,0)
;  printVarSummary(dzp_conform)

;============================================================================== lat
  LAT  = fin->lat(::-1)
  num_lat   = dimsizes(LAT)
  LAT(1:num_lat-2)  = (LAT(0:num_lat-3)+LAT(2:num_lat-1))/2.
  LAT(num_lat-1)    = (LAT(num_lat-1)+LAT(num_lat-2))/2.
  LAT(0)    = (LAT(0)+LAT(1))/2.
  dgree2rad = atan(1.)/45.
  oux   = cos(LAT *dgree2rad) * (1.*dgree2rad) * 6371000.
;  print("oux=  "+oux)
  oux_conform   = conform_dims(dimsizes(var),oux,1)
;  printVarSummary(oux_conform)

;============================================================================== psai with vstar
  psai_JK   = var                  ; to keep the grids and attributes.
  psai_JK   = var * dzp_conform * oux_conform * vit(0:29,:) * (-1.e-6)

  psai_JK_accum = new((/num_lev,num_lat/),float,-1.e30)
  psai_JK_accum = 0.
  psai_JK_accum!0  = "lev"
  psai_JK_accum!1  = "lat"
  psai_JK_accum&lev  = LEV
  psai_JK_accum&lat  = LAT
  psai_JK_accum&lev@long_name  = "Depth (m)"
  psai_JK_accum&lat@long_name  = "latitude"
  psai_JK_accum&lev@units  = "None"
  psai_JK_accum&lev@units  = "m"
  psai_JK_accum&lat@units  = "degree_north"

;  printVarSummary(psai_JK_accum)
  do k=1,num_lev-1
     psai_JK_accum(k,:)  = dim_sum_n_Wrap(psai_JK(0:k-1,:),0)
  end do
;  printVarSummary(psai_JK_accum)
;  print(psai_JK_accum(29,:))
  delete(psai_JK)

 do k=0,num_lev-1
 do j=0,num_lat-1
   if (vit(k,j) .le. 0.5) then
     psai_JK_accum(k,j)   = psai_JK_accum@_FillValue
   end if
 end do
 end do

 moc13(0,:,:,n)=(/psai_JK_accum/)
end do

moc13(0,:,:,num_nc)=dim_avg_Wrap(moc13(0,:,:,0:num_nc-1))

moc(0,:,:,0)     = (/moc13(0,:,:,num_nc)/)
moc!0  = "time"
moc!1  = "lev"
moc!2  = "lat"
moc!3  = "lon"
moc&time = 0.0
moc&lev  = LEV 
moc&lat  = LAT
moc&lon  = 0.0
moc@long_name  = "moc"
moc&time@long_name  = "time"
moc&lev@long_name  = "Depth (m)"
moc&lat@long_name  = "latitude"
moc&lon@long_name  = "longitude"
moc@units  = "Sv"
moc&time@units  = "year"
moc&lev@units  = "m"
moc&lat@units  = "degree_north"
moc&lon@units  = "degree_east"


system("rm "+DIR_out+"Atlantic_am_moc_"+YEAR+".nc")
fout    = addfile(DIR_out+"Atlantic_am_moc_"+YEAR+".nc","c")
fout->Atlantic_moc = moc

