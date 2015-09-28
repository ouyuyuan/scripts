
! Description: check whether all the restart files have the same dimensions
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
! Last Change: 2014-04

program check_dims

  use mod_io, only: mod_io_dim_len

  Implicit none

  ! change these parameters for new cases if needed
  integer, parameter             ::        nx = 146, ny = 75, nz = 75, nt = 1
  integer, parameter             ::      ncpu = 960
  character (len = *), parameter ::   rst_dir = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_960/"
  character (len = *), parameter :: rst_style = "ORCAR12_00000720"

  character (len = 200) :: ncname
  integer :: nlen, i

  do i = 0, ncpu - 1

    write(ncname, "(A,I0.4,A)") rst_dir//rst_style//"_restart_",i,".nc"

    call check(trim(ncname), "x", nx)

    call check(trim(ncname), "y", ny)

    call check(trim(ncname), "z", nz)

    call check(trim(ncname), "t", nt)

    write(ncname, "(A,I0.4,A)") rst_dir//rst_style//"_restart_ice_",i,".nc"

    call check(trim(ncname), "x", nx)

    call check(trim(ncname), "y", ny)

    call check(trim(ncname), "z", nz)

    call check(trim(ncname), "t", nt)

  end do
  
  write(*,*) "Done. All files pass check."

contains

  subroutine check(ncname, dimname, dimlen)
    
    character (len = *), intent(in) :: ncname, dimname
    integer, intent(in)             :: dimlen
    integer :: nlen

    nlen = mod_io_dim_len(ncname, dimname)

    if (nlen == dimlen) then
      write(*,*) dimname//" in "//ncname//" is equal to ",dimlen
    else
      write(*,*) dimname//" in "//ncname//" is not equal to ",dimlen
      stop
    end if

  end subroutine check

end program check_dims
