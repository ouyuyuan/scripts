
! Description: output the distribution of CPUs on the global grid
!              boundary has "sum up", and also seperated output
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-06-05 15:18:21 BJT

program output_cpu_distribution

  use mod_param, only: out_dir, ncpu, missing_int
  use mod_type,  only: struct_nc
  use mod_io,    only: io_read, io_output


  implicit none

  type (struct_nc), dimension(:), allocatable :: rsts
  character (len = 200) :: infofname

  namelist /param/ out_dir, ncpu 

  open(10, file='namelist_output_cpu_distribution')
  read(10, param)
  close(10)

  call pre_check()

  allocate( rsts(ncpu), stat = istat )
  call p_check_alloc( istat )

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call io_read( trim(infofname), rsts )

  nx_glo = rsts(1) % size_glo % val(1)
  ny_glo = rsts(1) % size_glo % val(2)

  call output()

contains !{{{1

subroutine pre_check() !{{{1
  logical :: hasfile, hasdir, needstop

  needstop = .false.

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

subroutine output() !{{{1

  integer, dimension(nx_glo, ny_glo), target :: cpus, dbnd
  integer, dimension(ncpu) :: ic, jc
  integer, pointer :: p(:,:)
  integer :: i, ia, ib, ja, jb

!compute variables
  cpus = missing_int
  dbnd = missing_int

  do i = 1, ncpu
    ia = rsts(i) % pos_fst % val(1)
    ja = rsts(i) % pos_fst % val(2)
    ib = rsts(i) % pos_lst % val(1)
    jb = rsts(i) % pos_lst % val(2)

    ic(i) = ( ia + ib ) / 2
    jc(i) = ( ja + jb ) / 2

    p=>cpus(ia:ib,ja:jb)
    where(p == missing_int) p = 0
    p = p + i  
    p=>null()

    p=>dbnd(ia:ib,ja:jb)
    where(p == 0) p = 1
    where(p == missing_int) p = 0
    p=>null()
  end do

!output variables
! for transport problem, we create multiple files
  call io_output_cpus( trim(out_dir)//'cpus.nc', cpus, ic, jc )

  call io_output( trim(out_dir)//'dbnd.nc', 'dbnd', &
    'boudary of each subdomains', dbnd )

end subroutine output

end program output_cpu_distribution !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
