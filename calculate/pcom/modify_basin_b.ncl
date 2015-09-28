
; Description: modify the basin.nc, make Pacific, Atlancitic, Indian overlap
;              with the Souther Ocean
;
;      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
;     Created: 2014-11-10 19:42:27 BJT
; Last Change: 2015-07-13 15:31:51 BJT

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  data_dir = "/home/ou/archive/data/pcom/"
  infile   = data_dir + "basin/basin.nc"
  outfile  = data_dir + "basin/basin_b.nc"

  PacId = 2
  AtlId = 6
  IndId = 3
  SouId = 1

  lonPacW = 145.5
  lonPacE = 360 - 70.5

  lonAtlW = lonPacE
  lonAtlE = 25.5

  lonIndW = lonAtlE
  lonIndE = lonPacW
  
  f = addfile( infile, "r" )
  bsOld = f->basin
  lon = f->lon
  lat = f->lat
  delete(f)

  bsNew = bsOld

  nlat = dimsizes(lat)
  nlon = dimsizes(lon)

  do i = 0, nlat - 1
    do j = 0, nlon - 1
      if (.not.ismissing(bsNew(i,j)) .and. (bsNew(i,j) .eq. SouId)) then
        if (lon(j).ge.lonPacW .and. lon(j).lt.lonPacE) then
          bsNew(i,j) = PacId
        else if (lon(j).ge.lonIndW .and. lon(j).lt.lonIndE) then
          bsNew(i,j) = IndId
        else
          bsNew(i,j) = AtlId
        end if
        end if
      end if

      if (.not.ismissing(bsNew(i,j)) .and. (bsNew(i,j) .eq. 8)) then
        bsNew(i,j) = AtlId
      else if (.not.ismissing(bsNew(i,j)) .and. (bsNew(i,j) .eq. 9)) then
        bsNew(i,j) = AtlId
      else if (.not.ismissing(bsNew(i,j)) .and. (bsNew(i,j) .eq. 10)) then
        bsNew(i,j) = AtlId
      else if (.not.ismissing(bsNew(i,j)) .and. (bsNew(i,j) .eq. -5)) then
        bsNew(i,j) = IndId
      end if
      end if
      end if
      end if
    end do
  end do

  system("rm -f "+outfile)
  f = addfile( outfile, "c" )
  f->basin = bsNew
  f@source = "create by " + systemfunc("pwd") + "/" + getenv("NCL_ARG_0") + \
  ", " + systemfunc("date")
  delete(f)
end
