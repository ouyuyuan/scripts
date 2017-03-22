
! Description: change Xie's data from binary to netCDF format
!
!              This program was coded follow the examples at: netcdf-4.1.3/examples/F90
!
!       Usage: ./bin2nc
!             The output filename will append .nc to the input's.
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2013-12-21 20:09:18 BJT
! Last Change: 2013-12-22 22:10:01 BJT

program main

   use netcdf
   implicit none

   ! change the name and records here
   ! the units of rec dimension should follow specific convensions for
   !  some software to process, like sdfopen in grads, panoply
   character (len = *), parameter :: filename = 'data/EA_ANAL_DLY_PRCP_V0409B.lnx.2003'
   character (len = *), parameter :: rec_units = "days since 2003-01-01 00:00:00"
   integer, parameter :: nrecs = 365

   ! these settings are according to the corressponding ctl file
   integer, parameter :: nlats = 110, nlons = 180, nlvls = 1
   integer, parameter :: ndims = 4
   real, parameter ::  start_lat = 5.25, start_lon = 65.25
   real, parameter :: stride_lat = 0.5, stride_lon = 0.5

   ! these settings are according to the corressponding ctl file
   character (len = *), parameter :: title          = 'YR Gauge-Based Analysis [Base Product]'
   character (len = *), parameter :: anal_name      = "anal"
   character (len = *), parameter :: nobs_name      = "nobs"
   character (len = *), parameter :: anal_long_name = "daily precipitation analysis"
   character (len = *), parameter :: nobs_long_name = "number of gauges in a grid box"
   character (len = *), parameter :: anal_units     = "0.1mm/day"
   character (len = *), parameter :: nobs_units     = ""
   real, parameter :: anal_fill_value = -999.0
   real, parameter :: nobs_fill_value = -999.0

   integer :: i
   real, dimension(nlons, nlats, nlvls, nrecs) :: anal, nobs

   write (*,*) 'process: '//filename//'......'
   call read_bin
   call write_nc

contains

   subroutine read_bin
      integer, parameter :: fileid = 10
      integer :: i, j

      open (unit = fileid, file = filename, access = 'direct', &
         recl = nlats*nlons, status = 'old')
      do i = 1, nrecs
         do j = 1, nlvls
            read (fileid, rec = 2*i-1) anal(:,:,j,i)
            read (fileid, rec = 2*i) nobs(:,:,j,i)
         end do
!         if (i==3) write(*,*) anal(:,1,1,i)
      end do

      close(fileid)
   end subroutine read_bin

   subroutine write_nc
      character (len = *), parameter :: units = "units"
      character (len = *), parameter :: long_name = "long_name"
      character (len = *), parameter :: fill_value = "_FillValue"

      character (len = *), parameter :: lvl_name = "lev"
      character (len = *), parameter :: lat_name = "lat"
      character (len = *), parameter :: lon_name = "lon"
      character (len = *), parameter :: rec_name = "time"

      character (len = *), parameter :: lat_units = "degrees_north"
      character (len = *), parameter :: lon_units = "degrees_east"

      integer :: ncid
      integer :: lon_dimid, lat_dimid, lvl_dimid, rec_dimid
      integer :: start(ndims), count(ndims)

      real :: lats(nlats), lons(nlons), lvls(nlvls), recs(nrecs)
      integer :: lon_varid, lat_varid, lvl_varid, rec_varid

      integer :: anal_varid, nobs_varid
      integer :: dimids(ndims)

      integer :: lat, lon, lvl, rec, i

      ! calculate coordinate variables
      do lat = 1, nlats
         lats(lat) = start_lat + (lat - 1) * stride_lat
      end do
      do lon = 1, nlons
         lons(lon) = start_lon + (lon - 1) * stride_lon
      end do
      do lvl = 1, nlvls
         lvls(lvl) = lvl - 1
      end do
      do rec = 1, nrecs
         recs(rec) = rec-1
      end do

      call check( nf90_create(filename//'.nc', nf90_clobber, ncid) )

      ! define the dimensions.
      call check( nf90_def_dim(ncid, lon_name, nlons, lon_dimid) )
      call check( nf90_def_dim(ncid, lat_name, nlats, lat_dimid) )
      call check( nf90_def_dim(ncid, lvl_name, nlvls, lvl_dimid) )
      call check( nf90_def_dim(ncid, rec_name, nf90_unlimited, rec_dimid) )

      ! define the coordinate variables.
      call check( nf90_def_var(ncid, lat_name, nf90_real, lat_dimid, lat_varid) )
      call check( nf90_def_var(ncid, lon_name, nf90_real, lon_dimid, lon_varid) )
      call check( nf90_def_var(ncid, lvl_name, nf90_real, lvl_dimid, lvl_varid) )
      call check( nf90_def_var(ncid, rec_name, nf90_real, rec_dimid, rec_varid) )

      ! assign units attributes to coordinate variables.
      ! sdfopen of grads needs the units attribute of coordinate variables
      call check( nf90_put_att(ncid, lat_varid, long_name, 'latitude') )
      call check( nf90_put_att(ncid, lat_varid, units, lat_units) )
      call check( nf90_put_att(ncid, lon_varid, long_name, 'longitude') )
      call check( nf90_put_att(ncid, lon_varid, units, lon_units) )
      call check( nf90_put_att(ncid, lvl_varid, long_name, 'level') )
      call check( nf90_put_att(ncid, lvl_varid, units, 'm') )
      call check( nf90_put_att(ncid, rec_varid, long_name, 'Time') )
      call check( nf90_put_att(ncid, rec_varid, units, rec_units) )
      
      ! global attributes
      call check( nf90_put_att(ncid, nf90_global, 'title', title) )

      dimids = (/ lon_dimid, lat_dimid, lvl_dimid, rec_dimid /)

      ! define the netcdf variables
      call check( nf90_def_var(ncid, anal_name, nf90_real, dimids, anal_varid) )
      call check( nf90_def_var(ncid, nobs_name, nf90_real, dimids, nobs_varid) )

      ! assign units attributes to the netcdf variables.
      call check( nf90_put_att(ncid, anal_varid, units, anal_units) )
      call check( nf90_put_att(ncid, nobs_varid, units, nobs_units) )
      call check( nf90_put_att(ncid, anal_varid, long_name, anal_long_name) )
      call check( nf90_put_att(ncid, nobs_varid, long_name, nobs_long_name) )
      call check( nf90_put_att(ncid, anal_varid, fill_value, anal_fill_value) )
      call check( nf90_put_att(ncid, nobs_varid, fill_value, nobs_fill_value) )

      ! end define mode.
      call check( nf90_enddef(ncid) )

      ! write the coordinate variable data.
      call check( nf90_put_var(ncid, lat_varid, lats) )
      call check( nf90_put_var(ncid, lon_varid, lons) )
      call check( nf90_put_var(ncid, lvl_varid, lvls) )
      call check( nf90_put_var(ncid, rec_varid, recs) )

      count = (/ nlons, nlats, nlvls, nrecs /)
      start = (/ 1, 1, 1, 1 /)

      call check( nf90_put_var(ncid, anal_varid, anal, start = start, count = count) )
      call check( nf90_put_var(ncid, nobs_varid, nobs, start = start, count = count) )

      call check( nf90_close(ncid) )

      print *,"*** success writing netCDF file ", filename, ".nc"
   end subroutine write_nc

   subroutine check(status)
      integer, intent (in) :: status
    
      if(status /= nf90_noerr) then 
         print *, trim(nf90_strerror(status))
         stop 2
      end if
   end subroutine check  

end program main
