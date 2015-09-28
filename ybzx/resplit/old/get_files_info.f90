
! Description: check whether all the restart files have the same dimensions
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-20 10:49:00 BJT
! Last Change: 2015-04-30 10:49:56 BJT

program get_files_info

  use mod_type, only:    &
    struct_nc

  use mod_io,   only:     &
    mod_io_get_nc_info,   &
    mod_io_print_nc_info   

  Implicit none

  ! change these parameters for new cases if needed
  character (len = 80)::   rst_dir
  character (len = 80):: rst_style
  integer             ::      ncpu

  character (len = 200) :: ncname
  integer :: i, istat
  type (struct_nc), dimension(:), allocatable :: nc

  namelist /param/ rst_dir, rst_style, ncpu 

  open(10, file="namelist")
  read(10, param)
  close(10)

  allocate( nc(0:ncpu-1), stat = istat ); call alloc_check( istat )
  
  do i = 0, ncpu - 1
    write(ncname, "(A,I0.4,A)") trim(rst_dir)//trim(rst_style)//"_restart_",i,".nc"
    write(*,*) "reading: ", trim(ncname), " ~ ~ ~ "

    nc(i) = mod_io_get_nc_info(ncname)
  end do

  call print_domain_info(nc)


contains

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! print the information of an nc file
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine print_domain_info(nc)

  type (struct_nc), intent(in) :: nc(:)
  integer :: n, i

  n = size(nc)
  do i = 1, n
    write(*,"(A, I4, A, 4(A,I4,A,I4,A))") "cpu: ", nc(i) % cpu % val, "; ", &
    " pos_fst:(", nc(i) % pos_fst % val(1), ",", nc(i) % pos_fst % val(2), ");", &
    " pos_lst:(", nc(i) % pos_lst % val(1), ",", nc(i) % pos_lst % val(2), ");", &
     " ha_sta:(", nc(i) %  ha_sta % val(1), ",", nc(i) %  ha_sta % val(2), ");", &
     " ha_end:(", nc(i) %  ha_end % val(1), ",", nc(i) %  ha_end % val(2), ");"
  end do

end subroutine print_domain_info 

!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
! check allocate success or not
!ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
subroutine alloc_check( istat )

  integer, intent(in) :: istat

  if ( istat /= 0 ) then
    stop "Allocate array failed! Stop."
  end if

end subroutine alloc_check

end program get_files_info
