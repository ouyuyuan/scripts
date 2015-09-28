! Description: basic NetCDF input/output interface, intent to be called by
!              other I/O module 
!
!      Author: Ou Niansen <ouyuyuan@lasg.iap.ac.cn>
!        Date: 2015-03

module mod_io 

  use netcdf
  use mod_type, only: struct_nc, dict_str, dict_int, dict_int2

  implicit none
  private

  public &
    mod_io_nc_info

  ! define var <<<1

  integer, parameter :: ndim = 3
  integer, dimension(ndim) :: dimids, sta, cnt
  integer :: ncid, varid

  interface get_att_val
    module procedure get_att_val_str
    module procedure get_att_val_int
    module procedure get_att_val_int2
  end interface

contains

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! get the information of the .nc files
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
function mod_io_nc_info(filename)

    character (len = *), intent(in) :: filename
    type (struct_nc) :: nc, mod_io_nc_info

    call check( nf90_open(filename, nf90_nowrite, ncid) )

    nc % nx = get_dim_len(ncid, "x")
    nc % ny = get_dim_len(ncid, "y")
    nc % nz = get_dim_len(ncid, "z")
    nc % nt = get_dim_len(ncid, "t")

    call get_att_val(ncid, nc % dm_type)
    call get_att_val(ncid, nc % cpus)
    call get_att_val(ncid, nc % cpu)
    call get_att_val(ncid, nc % dim_ids)
    call get_att_val(ncid, nc % size_glo)
    call get_att_val(ncid, nc % size_loc)
    call get_att_val(ncid, nc % pos_fst)
    call get_att_val(ncid, nc % pos_lst)
    call get_att_val(ncid, nc % ha_sta)
    call get_att_val(ncid, nc % ha_end)

    call check( nf90_close(ncid) )

    mod_io_nc_info = nc

end function mod_io_nc_info

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! get the value of a global attribute (string type) by name
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine get_att_val_str(ncid, dict)

    integer, intent(in) :: ncid
    type(dict_str) :: dict

    call check( nf90_get_att(ncid, nf90_global, dict % key, dict % val) )

end subroutine get_att_val_str

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! get the value of a global attribute (integer type) by name
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine get_att_val_int(ncid, dict)

    integer, intent(in) :: ncid
    type(dict_int) :: dict

    call check( nf90_get_att(ncid, nf90_global, dict % key, dict % val) )

end subroutine get_att_val_int

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! get the value of a global attribute (integer type, 1d array, 2 elements) by name
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine get_att_val_int2(ncid, dict)

    integer, intent(in) :: ncid
    type(dict_int2) :: dict

    call check( nf90_get_att(ncid, nf90_global, dict % key, dict % val) )

end subroutine get_att_val_int2

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! get the type and length of an attriubute
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine get_att_type_len(filename, attname, atttype, attlen)

    character (len = *), intent(in) :: filename, attname 
    integer :: atttype, attlen

    call check( nf90_open(filename, nf90_nowrite, ncid) )

    call check( nf90_inquire_attribute(ncid, nf90_global, attname, &
    xtype = atttype, len = attlen) )

    call check( nf90_close(ncid) )

end subroutine get_att_type_len

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! get length of a specific dimension
! get the length of a dimension with "dimname" from a NetCDF file with
! "filename"
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
function get_dim_len(ncid, dimname)

    integer, intent(in) :: ncid
    character (len = *), intent(in) :: dimname
    integer :: get_dim_len
    integer :: dimid, nlen

    call check( nf90_inq_dimid(ncid, dimname, dimid) )

    call check( nf90_inquire_dimension(ncid, dimid, len = nlen) )

    get_dim_len = nlen
    
    return

end function get_dim_len

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! check netcdf call
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine check(status)

    integer, intent (in) :: status

    if(status /= nf90_noerr) then 
        print *, trim(nf90_strerror(status))
        stop
    end if

end subroutine check  


end module mod_io 
