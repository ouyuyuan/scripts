
! Description: compare a variable of a specific CPU outpt
!              between the two files
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-07-02 10:02:22 BJT

program compare_variable

  use mod_param, only: sp, dp
  use mod_io,   only: io_read

  implicit none

  integer, parameter :: nx = 290, ny = 81, nz = 75, ncpu = 480
  character (len = *), parameter :: &
    ori_dir = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/", &
    new_dir = "/WORK/home/qhyc1/zhangyu/ouniansen/output/EXP_600_to_480/", &
    prefix  = "ORCAR12_00000720_restart_"

! check restart files {{{1
  if ( prefix == 'ORCAR12_00000720_restart_' ) then
!  call check_float2d( 'nav_lon' )
!  call check_float2d( 'nav_lat' )

!  call check_double2d( 'ssh_ibb' )

!  call check_double2d( 'ssu_m' )
!  call check_double2d( 'ssv_m' )
!  call check_double2d( 'sst_m' )
!  call check_double2d( 'sss_m' )
  call check_double2d( 'ssh_m' ) ! problem, random val at bnd

!  call check_double2d( 'rnf_b' ) ! problem, 49, one grid
!  call check_double2d( 'rnf_hc_b' )
!  call check_double2d( 'rnf_sc_b' )

!  call check_double2d( 'utau_b' )
!  call check_double2d( 'vtau_b' )
!  call check_double2d( 'qns_b' )

!  call check_double2d( 'emp_b' )
!  call check_double2d( 'emps_b' )

!  call check_double3d( 'en' )
!  call check_double3d( 'avt' )
!  call check_double3d( 'avm' )
!  call check_double3d( 'avmu' )
!  call check_double3d( 'avmv' )

!  call check_double3d( 'dissl' )

!  call check_double2d( 'sbc_hc_b' )
!  call check_double2d( 'sbc_sc_b' )

!  call check_double2d( 'gcx' )
!  call check_double2d( 'gcxb' )

!  call check_double3d( 'ub' )
!  call check_double3d( 'vb' )
!  call check_double3d( 'tb' )
!  call check_double3d( 'sb' )

!  call check_double3d( 'rotb' )
!  call check_double3d( 'hdivb' )

!  call check_double2d( 'sshb' )

!  call check_double3d( 'un' )
!  call check_double3d( 'vn' )
!  call check_double3d( 'tn' )
!  call check_double3d( 'sn' )

!  call check_double3d( 'rotn' )
!  call check_double3d( 'hdivn' )

!  call check_double2d( 'sshn' )

!  call check_double3d( 'rhop' )
end if

contains !{{{1

subroutine check_float2d( varname ) !{{{1

  character (len = *), intent(in) :: varname
  real (kind=sp), dimension(nx, ny) :: ori, new
  character (len = 200) :: ori_file, new_file, nc
  integer :: i, j, n, ndiff
  logical :: isdiff
  
  isdiff = .false.
  ndiff = 0

  do n = 0, ncpu-1
    if (isdiff) then
      ndiff = ndiff + 1
      isdiff = .false.
      if (ndiff > 1) exit
    end if

    write(nc, '(A,I0.4,A)') prefix, n, '.nc'
    write(*, '(A)') 'comparing '//trim(nc)//' for '//varname//' ~ ~ ~'
    ori_file = ori_dir//trim(nc)
    new_file = new_dir//trim(nc)
    call io_read( trim(ori_file), varname, ori )
    call io_read( trim(new_file), varname, new )

    if ( sum(abs(new - ori)) /=0 ) then
      isdiff = .true.
      do j = 1, ny
        do i = 1, nx
          if (new(i,j) /= ori(i,j)) then
            write(*,'(A, 2I5, 2(A, f20.15))') 'different (i,j): (', &
            i, j, ');  ori: ', ori(i,j), ' new: ', new(i,j)
          end if
        end do
      end do
    end if
  end do

end subroutine check_float2d

subroutine check_double2d( varname ) !{{{1

  character (len = *), intent(in) :: varname
  real (kind=dp), dimension(nx, ny) :: ori, new
  character (len = 200) :: ori_file, new_file, nc
  integer :: i, j, n, ndiff
  logical :: isdiff
  
  isdiff = .false.
  ndiff = 0

  do n = 0, ncpu-1
    if (isdiff) then
      ndiff = ndiff + 1
      isdiff = .false.
      if (ndiff > 1) exit
    end if

    write(nc, '(A,I0.4,A)') prefix, n, '.nc'
    write(*, '(A)') 'comparing '//trim(nc)//' for '//varname//' ~ ~ ~'
    ori_file = ori_dir//trim(nc)
    new_file = new_dir//trim(nc)
    call io_read( trim(ori_file), varname, ori )
    call io_read( trim(new_file), varname, new )

    if ( sum(abs(new - ori)) /=0 ) then
      isdiff = .true.
      do j = 1, ny
        do i = 1, nx
          if (new(i,j) /= ori(i,j)) then
            write(*,'(A, 2I5, 2(A, f20.15))') 'different (i,j): (', &
            i, j, ');  ori: ', ori(i,j), ' new: ', new(i,j)
          end if
        end do
      end do
    end if
  end do

end subroutine check_double2d

subroutine check_double3d( varname ) !{{{1

  character (len = *), intent(in) :: varname
  real (kind=dp), dimension(nx, ny, nz) :: ori, new
  character (len = 200) :: ori_file, new_file, nc
  integer :: i, j, n, ndiff
  logical :: isdiff
  
  isdiff = .false.
  ndiff = 0

  do n = 0, ncpu-1
    if (isdiff) then
      ndiff = ndiff + 1
      isdiff = .false.
      if (ndiff > 1) exit
    end if

    write(nc, '(A,I0.4,A)') prefix, n, '.nc'
    write(*, '(A)') 'comparing '//trim(nc)//' for '//varname//' ~ ~ ~'
    ori_file = ori_dir//trim(nc)
    new_file = new_dir//trim(nc)
    call io_read( trim(ori_file), varname, ori )
    call io_read( trim(new_file), varname, new )

    if ( sum(abs(new(:,:,1) - ori(:,:,1))) /=0 ) then
      isdiff = .true.
      do j = 1, ny
      do i = 1, nx
        if (new(i,j,1) /= ori(i,j,1)) &
          write(*,'(A, 2I5, 2(A, f20.15))') 'different (i,j): (', &
          i, j, ');  ori: ', ori(i,j,1), ' new: ', new(i,j,1)
      end do
      end do
    end if
  end do

end subroutine check_double3d

end program compare_variable
