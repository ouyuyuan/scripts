
! Description: print some data to debug
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-07-02 09:14:54 BJT

program main

  use mod_param, only: sp, dp
  use mod_io,   only: io_read

  implicit none

  integer, parameter :: nx = 290, ny = 81, nz = 75, ncpu = 480
  character (len = 200) :: fname, nc, prefix
  real (kind=dp) :: val
  real (kind=dp), dimension(nx, ny) :: var
  real (kind=dp), dimension(nx, ny, nz) :: var3d
  integer :: n, i, j, col, row, nth

  nth = 199
  prefix = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/ORCAR12_00000720_restart_"
  write(fname, '(A,I0.4,A)') trim(prefix), nth, '.nc'
  write(*,*) fname
  call io_read( trim(fname), 'ssh_m', var )
!  write(*,'(3f50.40)') var(100, 81), var(100,80), var(100,79)
!  write(*,'(3f50.40)') var(100, 3), var(100,2), var(100,1)
  val = var(100,81)

  
  do n = 0, ncpu-1
    write(fname, '(A,I0.4,A)') trim(prefix), i, '.nc'
    call io_read( trim(fname), 'ssh_m', var )
    do i = 1, nx
      do j = 1, ny
        if (var(i,j) == val) print *, n, i, j, var(i,j)
      end do
    end do
  end do
    
!  nth = 199
!  prefix = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/ORCAR12_00000720_restart_"
!  write(fname, '(A,I0.4,A)') trim(prefix), nth, '.nc'
!  write(*,*) fname
!  call io_read( trim(fname), 'ssh_m', var3d )
!  write(*,'(3f50.40)') var3d(100, 81, 1), var3d(100,80, 1), var3d(100,79, 1)

!  nth = 214
!  prefix = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/ORCAR12_00000720_restart_"
!  write(fname, '(A,I0.4,A)') trim(prefix), nth, '.nc'
!  write(*,*) fname
!  call io_read( trim(fname), 'ssh_m', var )
!  write(*,'(3f50.40)') var(100, 3), var(100,2), var(100,1)

end program main
