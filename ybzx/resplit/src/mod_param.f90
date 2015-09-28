
! Description: global parameters
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-26 08:20:12 BJT
! Last Change: 2015-06-04 09:56:17 BJT

module mod_param

  implicit none
  public

!---precision control for real number-------------------{{{1
  ! single precision
  integer, parameter :: sp = selected_real_kind( 6,  37) 
  ! double precision
  integer, parameter :: dp = selected_real_kind(12, 307) 
  integer, parameter :: wp = dp ! working precision

!-------------------------------------------------------{{{1
  integer, parameter :: missing_int = -999

!---read in from namelist-------------------------------{{{1
  character (len = 80):: rst_dir, out_dir
  character (len = 80):: rst_prefix
  integer             :: ncpu, new_ncpu

  integer :: nx_glo, ny_glo, nx, ny, nz, nt

end module mod_param !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
