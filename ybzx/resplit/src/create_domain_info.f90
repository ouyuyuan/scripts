
! Description: create domain info for a specific number of CPUs
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-07-01 08:23:58 BJT

program create_domain_info

  use mod_param, only: rst_dir, rst_prefix, ncpu, &
    nx_glo, ny_glo, nx, ny, nz
  use mod_p, only: p_check_alloc, p_print_domain_info
  use mod_type, only: struct_nc, ncvar_int1d
  use mod_io,   only: io_get_nc_info, io_output_domain, &
    io_print_nc_info, io_is_similar


  implicit none

  type (struct_nc), dimension(:), allocatable :: rsts
  character (len = 200) :: ncname, infofname
  integer :: istat

  namelist /param/ rst_dir, rst_prefix, ncpu 

  open(10, file='namelist_create_domain_info')
  read(10, param)
  close(10)

  allocate( rsts(ncpu), stat = istat )
  call p_check_alloc( istat )

  call get_files_info( rsts )

  nx_glo = rsts(1) % size_glo % val(1)
  ny_glo = rsts(1) % size_glo % val(2)
  nx = rsts(1) % nx
  ny = rsts(1) % ny
  nz = rsts(1) % nz

  call check_files( rsts )

  call p_print_domain_info( rsts )

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call output_domain_info( trim(infofname) )

contains !{{{1
!-------------------------------------------------------{{{1

subroutine output_domain_info( infofname ) !{{{2
!-----------------------------------------------------------
!   output subdomains of MPI to a netcdf file
!-----------------------------------------------------------

  character (len=*), intent(in) :: infofname
  type (ncvar_int1d) :: vars(14)
  type (struct_nc) :: rst
  integer, dimension(ncpu), target :: &
    ia  , ja  , ib  , jb  , &
    iai , jai , ibi , jbi , &
    iah , jah , ibh , jbh , &
    ic  , jc
  integer :: i

!---define output variables-----------------------------{{{3
  vars = (/& 
    ncvar_int1d('ia', 'starting i-index of subdomains', ia), &
    ncvar_int1d('ja', 'starting j-index of subdomains', ja), &
    ncvar_int1d('ib', 'ending i-index of subdomains',   ib), &
    ncvar_int1d('jb', 'ending j-index of subdomains',   jb), &
    ncvar_int1d('iai', 'starting i-index of inner area', iai), &
    ncvar_int1d('jai', 'starting j-index of inner area', jai), &
    ncvar_int1d('ibi', 'ending i-index of inner area',   ibi), &
    ncvar_int1d('jbi', 'ending j-index of inner area',   jbi), &
    ncvar_int1d('iah', 'starting halo rows in i-direction', iah), &
    ncvar_int1d('jah', 'starting halo rows in j-direction', jah), &
    ncvar_int1d('ibh', 'ending halo rows in i-direction',   ibh), &
    ncvar_int1d('jbh', 'ending halo rows in j-direction',   jbh), &
    ncvar_int1d('ic', 'center i-index of subdomains', ic), &
    ncvar_int1d('jc', 'center j-index of subdomains', jc)  /)

!---comput variables------------------------------------{{{3
  do i = 1, ncpu
    rst    = rsts(i)

    ia(i) = rst % pos_fst % val(1)
    ja(i) = rst % pos_fst % val(2)
    ib(i) = rst % pos_lst % val(1)
    jb(i) = rst % pos_lst % val(2)

    iah(i) = rst % ha_sta % val(1)
    jah(i) = rst % ha_sta % val(2)
    ibh(i) = rst % ha_end % val(1)
    jbh(i) = rst % ha_end % val(2)

    iai(i) = ia(i) + iah(i)
    jai(i) = ja(i) + jah(i)
    ibi(i) = ib(i) - ibh(i)
    jbi(i) = jb(i) - jbh(i)

    ic(i) = ( ia(i) + ib(i) ) / 2
    jc(i) = ( ja(i) + jb(i) ) / 2
  end do

!---output variables------------------------------------{{{3
  call io_output_domain( infofname, vars )

end subroutine output_domain_info

subroutine check_files( nc ) !{{{2
!-----------------------------------------------------------
! check whether all the restart files have the same dimensions and similar 
!   global attributes
!-----------------------------------------------------------
  type (struct_nc), intent(in) :: nc(:)
  integer :: i

  call io_print_nc_info(nc(1))

  if (nc(1)% cpus % val /= ncpu) then
    write(*,*) 'WARNING: number of cpus in '//trim(nc(1) % fname)// &
      ' is not equal to the value defined in the namelist.'
  end if

  do i = 2, ncpu
    write(*,*) 'checking: '//trim(nc(i) % fname)//' ~ ~ ~ '
    if ( .not. io_is_similar(nc(i), nc(1)) ) then
      write(*,*) trim(nc(i) % fname)//' is not the similar type of '//trim(nc(1) % fname)
      stop
    end if
  end do
  write(*,*) 'All files are similar in size and global attributes.'
end subroutine check_files 

subroutine get_files_info( nc ) !{{{2
!-----------------------------------------------------------
! get the dimensions and global attributes of every restart files
!   to a struct array
!-----------------------------------------------------------

  type (struct_nc) :: nc(:)
  integer :: i, nfile
  logical :: hasinfo

  nfile = size(nc)
  do i = 1, nfile
    write(ncname, '(A,I0.4,A)') &
      trim(rst_dir)//trim(rst_prefix),i-1,'.nc'
    write(*,*) 'reading: '//trim(ncname)//' ~ ~ ~ '

    nc(i) = io_get_nc_info(ncname)
  end do

end subroutine get_files_info

end program create_domain_info!{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
