
! Description: extract a variable from the original files and output
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-07-01 08:31:23 BJT

program extract_variable

  use mod_param, only: sp, dp, &
    rst_dir, out_dir, rst_prefix, ncpu, &
    nx, ny, nz
  use mod_p, only: p_check_alloc
  use mod_type, only: struct_nc
  use mod_io,   only: io_read, io_output, io_create_rst, io_create_rst_ice


  implicit none

  type (struct_nc), dimension(:), allocatable :: rsts
  character (len = 200) :: ncname, infofname
  integer :: istat, i

  namelist /param/ rst_dir, out_dir, rst_prefix, ncpu 

  open(10, file='namelist_extract_variable')
  read(10, param)
  close(10)

  call pre_check()

  allocate( rsts(ncpu), stat = istat )
  call p_check_alloc( istat )

!extract restart files {{{1
!read in domain info------------------------------------{{{2
  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call io_read( trim(infofname), rsts )

  nx = rsts(1) % nx
  ny = rsts(1) % ny
  nz = rsts(1) % nz

!create new restart files-------------------------------{{{2
  do i = 1, ncpu
    call io_create_rst( rsts(i) )
  end do
  write(*,'(A,I5,A)') "*** SUCCESS created ",ncpu," restart files in "//trim(out_dir)

!write to new files-------------------------------------{{{2
!  call extract_float2d( 'nav_lat' )
!  call extract_float2d( 'nav_lon' )
!  call extract_float1d( 'nav_lev' )
!  call extract_scalar( 'time_counter' )
!  call extract_scalar( 'kt' )
!  call extract_scalar( 'ndastp' )
!  call extract_scalar( 'adatrj' )

  call extract_double2d( 'ssh_ibb' )
  call extract_scalar( 'nn_fsbc' )

!  call extract_double2d( 'ssu_m' )
!  call extract_double2d( 'ssv_m' )
!  call extract_double2d( 'sst_m' )
!  call extract_double2d( 'sss_m' )
!  call extract_double2d( 'ssh_m' )

!  call extract_double2d( 'rnf_b' )
!  call extract_double2d( 'rnf_hc_b' )
!  call extract_double2d( 'rnf_sc_b' )

!  call extract_double2d( 'utau_b' )
!  call extract_double2d( 'vtau_b' )
!  call extract_double2d( 'qns_b' )

!  call extract_double2d( 'emp_b' )
!  call extract_double2d( 'emps_b' )

!  call extract_double3d( 'en' )
!  call extract_double3d( 'avt' )
!  call extract_double3d( 'avm' )
!  call extract_double3d( 'avmu' )
!  call extract_double3d( 'avmv' )

!  call extract_double3d( 'dissl' )

!  call extract_double2d( 'sbc_hc_b' )
!  call extract_double2d( 'sbc_sc_b' )

!  call extract_double2d( 'gcx' )
!  call extract_double2d( 'gcxb' )

!  call extract_scalar( 'rdt' )
!  call extract_scalar( 'rdttra1' )

!  call extract_double3d( 'ub' )
!  call extract_double3d( 'vb' )
!  call extract_double3d( 'tb' )
!  call extract_double3d( 'sb' )

!  call extract_double3d( 'rotb' )
!  call extract_double3d( 'hdivb' )

!  call extract_double2d( 'sshb' )

!  call extract_double3d( 'un' )
!  call extract_double3d( 'vn' )
!  call extract_double3d( 'tn' )
!  call extract_double3d( 'sn' )

!  call extract_double3d( 'rotn' )
!  call extract_double3d( 'hdivn' )

!  call extract_double2d( 'sshn' )

!  call extract_double3d( 'rhop' )

!extract restart ice files {{{1
!read in domain info------------------------------------{{{2
  ! info is the same as restart files, except filenames
  rst_prefix = trim(rst_prefix)//'ice_' 

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call io_read( trim(infofname), rsts )

!create new restart ice files---------------------------{{{2
!  do i = 1, ncpu
!    call io_create_rst_ice( rsts(i) )
!  end do
!  write(*,'(A,I5,A)') "*** SUCCESS created ",ncpu," restart ice files in "//trim(out_dir)

!write to new ice files---------------------------------{{{2
!  call extract_float2d( 'nav_lon' )
!  call extract_float2d( 'nav_lat' )
!  call extract_float1d( 'nav_lev' )

!  call extract_scalar( 'time_counter' )
!  call extract_scalar( 'kt_ice' )

!  call extract_double2d( 'hicif' )
!  call extract_double2d( 'hsnif' )
!  call extract_double2d( 'frld' )
!  call extract_double2d( 'sist' )

!  call extract_double2d( 'tbif1' )
!  call extract_double2d( 'tbif2' )
!  call extract_double2d( 'tbif3' )
!  call extract_double2d( 'u_ice' )
!  call extract_double2d( 'v_ice' )

!  call extract_double2d( 'qstoif' )
!  call extract_double2d( 'fsbbq' )

!  call extract_double2d( 'stress1_i' )
!  call extract_double2d( 'stress2_i' )
!  call extract_double2d( 'stress12_i' )

!  call extract_double2d( 'sxice' )
!  call extract_double2d( 'syice' )
!  call extract_double2d( 'sxxice' )
!  call extract_double2d( 'syyice' )
!  call extract_double2d( 'sxyice' )

!  call extract_double2d( 'sxsn' )
!  call extract_double2d( 'sysn' )
!  call extract_double2d( 'sxxsn' )
!  call extract_double2d( 'syysn' )
!  call extract_double2d( 'sxysn' )

!  call extract_double2d( 'sxa' )
!  call extract_double2d( 'sya' )
!  call extract_double2d( 'sxxa' )
!  call extract_double2d( 'syya' )
!  call extract_double2d( 'sxya' )

!  call extract_double2d( 'sxc0' )
!  call extract_double2d( 'syc0' )
!  call extract_double2d( 'sxxc0' )
!  call extract_double2d( 'syyc0' )
!  call extract_double2d( 'sxyc0' )

!  call extract_double2d( 'sxc1' )
!  call extract_double2d( 'syc1' )
!  call extract_double2d( 'sxxc1' )
!  call extract_double2d( 'syyc1' )
!  call extract_double2d( 'sxyc1' )

!  call extract_double2d( 'sxc2' )
!  call extract_double2d( 'syc2' )
!  call extract_double2d( 'sxxc2' )
!  call extract_double2d( 'syyc2' )
!  call extract_double2d( 'sxyc2' )

!  call extract_double2d( 'sxst' )
!  call extract_double2d( 'syst' )
!  call extract_double2d( 'sxxst' )
!  call extract_double2d( 'syyst' )
!  call extract_double2d( 'sxyst' )

contains !{{{1

subroutine extract_scalar( varname ) !{{{1

  character (len=*), intent(in) :: varname

  real (kind=dp) :: var
  type (struct_nc) :: rst
  integer :: i

  do i = 1, ncpu
    rst = rsts(i)
    call io_read( trim(rst_dir)//trim(rst%fname), varname, var )
    call io_output( trim(out_dir)//trim(rst%fname), varname, var )
  end do

  write(*,*) "*** SUCCESS extract scalar '"//varname//"'"
end subroutine extract_scalar

subroutine extract_double3d( varname ) !{{{1

  character (len=*), intent(in) :: varname

  real (kind=dp) :: var(nx,ny,nz)
  type (struct_nc) :: rst
  integer :: i

  do i = 1, ncpu
    rst    = rsts(i)
    call io_read( trim(rst_dir)//trim(rst%fname), varname, var )
    call io_output( trim(out_dir)//trim(rst%fname), varname, var )
  end do
  write(*,*) "*** SUCCESS extract variable '"//varname//"'"

end subroutine extract_double3d

subroutine extract_double2d( varname ) !{{{1

  character (len=*), intent(in) :: varname

  real (kind=dp) :: var(nx,ny)
  type (struct_nc) :: rst
  integer :: i

  do i = 1, ncpu
    rst    = rsts(i)
    call io_read( trim(rst_dir)//trim(rst%fname), varname, var )
    call io_output( trim(out_dir)//trim(rst%fname), varname, var )
  end do

  write(*,*) "*** SUCCESS extract variable '"//varname//"'"
end subroutine extract_double2d

subroutine extract_float1d( varname ) !{{{1

  character (len=*), intent(in) :: varname

  real (kind=sp) :: var(nz)
  type (struct_nc) :: rst
  integer :: i

  do i = 1, ncpu
    rst = rsts(i)
    call io_read( trim(rst_dir)//trim(rst%fname), varname, var )
    call io_output( trim(out_dir)//trim(rst%fname), varname, var )
  end do

  write(*,*) "*** SUCCESS extract variable '"//varname//"'"
end subroutine extract_float1d

subroutine extract_float2d( varname ) !{{{1

  character (len=*), intent(in) :: varname

  real (kind=sp) :: var(nx,ny)
  type (struct_nc) :: rst
  integer :: i

  do i = 1, ncpu
    rst    = rsts(i)
    call io_read( trim(rst_dir)//trim(rst%fname), varname, var )
    call io_output( trim(out_dir)//trim(rst%fname), varname, var )
  end do

  write(*,*) "*** SUCCESS extract variable '"//varname//"'"
end subroutine extract_float2d

subroutine pre_check() !{{{1
  logical :: hasfile, hasdir, needstop

  if (trim(rst_dir)==trim(out_dir)) then
    write(*,*) 'restart and output directory should not the same. stop.'
  end if

  needstop = .false.

  inquire( directory = trim(rst_dir), exist = hasdir )
  if ( .not.hasdir ) then 
    write(*,*)'directory holding restart files  "'//rst_dir//&
      '" not exists.' 
    needstop = .true.
  end if

  call system("mkdir -p "//out_dir)

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  inquire( file = trim(infofname), exist = hasfile )
  if ( .not. hasfile ) then 
    write(*,*)'run create_domain_info to get '//infofname//&
      ' first.'
    needstop = .true.
  end if

  if ( needstop ) stop

end subroutine pre_check

end program extract_variable!{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
