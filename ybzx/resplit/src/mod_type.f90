
! Description: data-type definition
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-26 08:20:12 BJT
! Last Change: 2015-06-28 08:07:46 BJT

module mod_type

  use mod_param, only: sp, wp

  implicit none
  public

!---dictionary type of netcdf attributes----------------{{{1
  type :: dict_str
    character (len = 80) :: key, val
  end type dict_str

  type :: dict_int
    character (len = 80) :: key
    integer :: val
  end type dict_int

  type :: dict_int2
    character (len = 80) :: key
    integer :: val(2)
  end type dict_int2

!---structure of a netcdf file--------------------------{{{1
  type :: struct_nc
    character (len = 200) :: fname
    integer :: nx, ny, nz, nt
    type(dict_int)  :: cpus
    type(dict_int)  :: cpu
    type(dict_int2) :: dim_ids
    type(dict_int2) :: size_glo
    type(dict_int2) :: size_loc
    type(dict_int2) :: pos_fst
    type(dict_int2) :: pos_lst
    type(dict_int2) :: ha_sta
    type(dict_int2) :: ha_end
    type(dict_str)  :: dm_type
    logical vac_west ! vacant mask in the west, north, east, south direction
    logical vac_north
    logical vac_east
    logical vac_south
  end type struct_nc

!---netcdf variable-------------------------------------{{{1
  type :: ncvar_int1d
    character (len = 80) :: varname, longname
    integer, pointer :: p(:)
  end type ncvar_int1d

  type :: ncvar_float2d
    character (len = 80) :: varname
    real(kind=sp), pointer :: p(:,:)
  end type ncvar_float2d

  type :: ncvar_double2d
    character (len = 80) :: varname
    real(kind=wp), pointer :: p(:,:)
  end type ncvar_double2d

end module mod_type !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
