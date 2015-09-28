
! Description: print the domian infomation
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-06-06 07:16:32 BJT

program print_domain_info

  use mod_param, only: ncpu
  use mod_p, only: p_check_alloc, p_print_domain_info
  use mod_type, only: struct_nc
  use mod_io,   only: io_read

  implicit none

  type (struct_nc), dimension(:), allocatable :: rsts
  character (len = 200) :: infofname
  integer :: istat

  namelist /param/ ncpu

  open(10, file='namelist_print_domain_info')
  read(10, param)
  close(10)

  call pre_check()

  allocate( rsts(ncpu), stat = istat )
  call p_check_alloc( istat )

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call io_read( trim(infofname), rsts )

  call p_print_domain_info( rsts )

contains

subroutine pre_check() !{{{1
  logical :: hasfile

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  inquire( file = trim(infofname), exist = hasfile )
  if ( .not. hasfile ) then 
    write(*,*)'run create_domain_info to get '//infofname//&
      ' first. stop.'
    stop
  end if
end subroutine pre_check

end program print_domain_info !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
