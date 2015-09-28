
! Description: check whether all the restart files have the same dimensions
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
! Last Change: 2014-04

program check_file

  use mod_type, only:    &
    struct_nc

  use mod_io,   only:    &
    mod_io_get_nc_info,      &
    mod_io_print_att,    &
    mod_io_print_dims,   &
    mod_io_is_similar

  Implicit none

  ! change these parameters for new cases if needed
  character (len = *), parameter ::   rst_dir = "/WORK/home/qhyc1/zhangyu/ouniansen/EXP_480/"
  character (len = *), parameter :: rst_style = "ORCAR12_00000720"
  integer, parameter             ::      ncpu = 480

  character (len = 200) :: ncname
  integer :: i
  type (struct_nc) :: nc0, nc
  
  write(ncname, "(A,I0.4,A)") rst_dir//rst_style//"_restart_",0,".nc"
  nc0 = mod_io_get_nc_info(ncname)

  write(*,*) "information of  ", trim(ncname), ": "
  call print_nc_info(nc0)

  if (nc0 % cpus % val /= ncpu) then
    write(*,*) "number of cpus in ", trim(ncname), &
      " is not equal to the value defined in the parameter. STOP. "
    stop 
  end if

  do i = 1, ncpu - 1
    write(ncname, "(A,I0.4,A)") rst_dir//rst_style//"_restart_",i,".nc"
    write(*,*) "checking: ", trim(ncname), " ~ ~ ~ "
    nc = mod_io_get_nc_info(ncname)
    if ( .not. mod_io_is_similar(nc, nc0) ) then
      write(*,*) trim(nc % fname), " is not the similar type of ", trim(nc0 % fname)
      stop
    end if
  end do
  write(*,*) "All files are similar in size and global attributes."

contains

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! print the information of an nc file
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine print_nc_info(nc)

  type (struct_nc), intent(in) :: nc

  call mod_io_print_dims(nc)

  print *, ""

  call mod_io_print_att(nc % cpus)
  call mod_io_print_att(nc % cpu)
  call mod_io_print_att(nc % dim_ids)
  call mod_io_print_att(nc % size_glo)
  call mod_io_print_att(nc % size_loc)
  call mod_io_print_att(nc % pos_fst)
  call mod_io_print_att(nc % pos_lst)
  call mod_io_print_att(nc % ha_sta)
  call mod_io_print_att(nc % ha_end)
  call mod_io_print_att(nc % dm_type)

end subroutine print_nc_info 

end program check_file
