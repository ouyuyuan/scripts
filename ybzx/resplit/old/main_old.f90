
! Description: create a domain info file for latter use
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-02-22 13:51:55 BJT
! Last Change: 2015-07-02 19:01:55 BJT

program main

  use mod_param, only: sp, dp, missing_int, &
    rst_dir, out_dir, rst_prefix, ncpu, new_ncpu, &
    nx_glo, ny_glo, nx, ny, nz
  use mod_p, only: p_check_alloc
  use mod_type, only: struct_nc, ncvar_int1d
  use mod_io,   only: io_get_nc_info, io_read, &
    io_output, io_output_cpus, io_output_domain, &
    io_create_rst, io_create_rst_ice

  implicit none

  type (struct_nc), dimension(:), allocatable :: rsts
  type (struct_nc), dimension(:), allocatable :: new_rsts
  type (struct_nc) :: rst
  character (len = 200) :: ncname, infofname, inpname, outname
  integer :: new_nx, new_ny, istat, i

!read in namelist---------------------------------------{{{1
  namelist /param/ rst_dir, out_dir, rst_prefix, ncpu, new_ncpu

  open(10, file='namelist_main')
  read(10, param)
  close(10)

  call pre_check()

!resplit restart files {{{1
!read in domain info------------------------------------{{{2
  allocate( rsts(ncpu), stat = istat )
  call p_check_alloc( istat )

  allocate( new_rsts(new_ncpu), stat = istat )
  call p_check_alloc( istat )

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call io_read( trim(infofname), rsts )

  write(infofname, '(A,I0.4,A)') 'domain_info/N', new_ncpu, '.nc'
  call io_read( trim(infofname), new_rsts )

!get dimension------------------------------------------{{{2
  nx_glo = rsts(1) % size_glo % val(1)
  ny_glo = rsts(1) % size_glo % val(2)
  nz = rsts(1) % nz

  nx = rsts(1) % nx
  ny = rsts(1) % ny

  new_nx = new_rsts(1) % nx
  new_ny = new_rsts(1) % ny

!create new restart files-------------------------------{{{2
  do i = 1, new_ncpu
    call io_create_rst( new_rsts(i) )
  end do
  write(*,'(A,I5,A)') "*** SUCCESS created ",new_ncpu," restart files in "//trim(out_dir)

!write to new files-------------------------------------{{{2
  call split_latlon( 'domain_info/mesh_mask.nc', 'nav_lon' )
  call split_latlon( 'domain_info/mesh_mask.nc', 'nav_lat' )
  call copy_float1d( 'nav_lev' )

  call copy_scalar( 'time_counter' )
  call copy_scalar( 'kt' )
  call copy_scalar( 'ndastp' )
  call copy_scalar( 'adatrj' )

  call resplit_double2d_rst( 'ssh_ibb' )
  call copy_scalar( 'nn_fsbc' )

  call resplit_double2d_rst( 'ssu_m' )
  call resplit_double2d_rst( 'ssv_m' )
  call resplit_double2d_rst( 'sst_m' )
  call resplit_double2d_rst( 'sss_m' )
  call resplit_double2d_rst( 'ssh_m' )

  call resplit_double2d_rst( 'rnf_b' )
  call resplit_double2d_rst( 'rnf_hc_b' )
  call resplit_double2d_rst( 'rnf_sc_b' )

  call resplit_double2d_rst( 'utau_b' )
  call resplit_double2d_rst( 'vtau_b' )
  call resplit_double2d_rst( 'qns_b' )

  call resplit_double2d_rst( 'emp_b' )
  call resplit_double2d_rst( 'emps_b' )

  call resplit_double3d( 'en' )
  call resplit_double3d( 'avt' )
  call resplit_double3d( 'avm' )
  call resplit_double3d( 'avmu' )
  call resplit_double3d( 'avmv' )

  call resplit_double3d( 'dissl' )

  call resplit_double2d_rst( 'sbc_hc_b' )
  call resplit_double2d_rst( 'sbc_sc_b' )

  call resplit_double2d_rst( 'gcx' )
  call resplit_double2d_rst( 'gcxb' )

  call copy_scalar( 'rdt' )
  call copy_scalar( 'rdttra1' )

  call resplit_double3d( 'ub' )
  call resplit_double3d( 'vb' )
  call resplit_double3d( 'tb' )
  call resplit_double3d( 'sb' )

  call resplit_double3d( 'rotb' )
  call resplit_double3d( 'hdivb' )

  call resplit_double2d_rst( 'sshb' )

  call resplit_double3d( 'un' )
  call resplit_double3d( 'vn' )
  call resplit_double3d( 'tn' )
  call resplit_double3d( 'sn' )

  call resplit_double3d( 'rotn' )
  call resplit_double3d( 'hdivn' )

  call resplit_double2d_rst( 'sshn' )

  call resplit_double3d( 'rhop' )

!resplit restart ice files {{{1
!read in domain info------------------------------------{{{2
  ! info is the same as restart files, except filenames

  rst_prefix = trim(rst_prefix)//'ice_' 

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  call io_read( trim(infofname), rsts )

  write(infofname, '(A,I0.4,A)') 'domain_info/N', new_ncpu, '.nc'
  call io_read( trim(infofname), new_rsts )

!create new restart ice files---------------------------{{{2
  do i = 1, new_ncpu
    call io_create_rst_ice( new_rsts(i) )
  end do
  write(*,'(A,I5,A)') "*** SUCCESS created ",new_ncpu," restart ice files in "//trim(out_dir)

!write to new ice files---------------------------------{{{2
  call split_latlon( 'domain_info/mesh_mask.nc', 'nav_lon' )
  call split_latlon( 'domain_info/mesh_mask.nc', 'nav_lat' )
  call copy_float1d( 'nav_lev' )

  call copy_scalar( 'time_counter' )
  call copy_scalar( 'kt_ice' )

  call resplit_double2d_ice( 'hicif' )
  call resplit_double2d_ice( 'hsnif' )
  call resplit_double2d_ice( 'frld' )
  call resplit_double2d_ice( 'sist' )

  call resplit_double2d_ice( 'tbif1' )
  call resplit_double2d_ice( 'tbif2' )
  call resplit_double2d_ice( 'tbif3' )
  call resplit_double2d_ice( 'u_ice' )
  call resplit_double2d_ice( 'v_ice' )

  call resplit_double2d_ice( 'qstoif' )
  call resplit_double2d_ice( 'fsbbq' )

  call resplit_double2d_ice( 'stress1_i' )
  call resplit_double2d_ice( 'stress2_i' )
  call resplit_double2d_ice( 'stress12_i' )

  call resplit_double2d_ice( 'sxice' )
  call resplit_double2d_ice( 'syice' )
  call resplit_double2d_ice( 'sxxice' )
  call resplit_double2d_ice( 'syyice' )
  call resplit_double2d_ice( 'sxyice' )

  call resplit_double2d_ice( 'sxsn' )
  call resplit_double2d_ice( 'sysn' )
  call resplit_double2d_ice( 'sxxsn' )
  call resplit_double2d_ice( 'syysn' )
  call resplit_double2d_ice( 'sxysn' )

  call resplit_double2d_ice( 'sxa' )
  call resplit_double2d_ice( 'sya' )
  call resplit_double2d_ice( 'sxxa' )
  call resplit_double2d_ice( 'syya' )
  call resplit_double2d_ice( 'sxya' )

  call resplit_double2d_ice( 'sxc0' )
  call resplit_double2d_ice( 'syc0' )
  call resplit_double2d_ice( 'sxxc0' )
  call resplit_double2d_ice( 'syyc0' )
  call resplit_double2d_ice( 'sxyc0' )

  call resplit_double2d_ice( 'sxc1' )
  call resplit_double2d_ice( 'syc1' )
  call resplit_double2d_ice( 'sxxc1' )
  call resplit_double2d_ice( 'syyc1' )
  call resplit_double2d_ice( 'sxyc1' )

  call resplit_double2d_ice( 'sxc2' )
  call resplit_double2d_ice( 'syc2' )
  call resplit_double2d_ice( 'sxxc2' )
  call resplit_double2d_ice( 'syyc2' )
  call resplit_double2d_ice( 'sxyc2' )

  call resplit_double2d_ice( 'sxst' )
  call resplit_double2d_ice( 'syst' )
  call resplit_double2d_ice( 'sxxst' )
  call resplit_double2d_ice( 'syyst' )
  call resplit_double2d_ice( 'sxyst' )

contains !{{{1
!-------------------------------------------------------{{{1

subroutine split_latlon( meshname, varname ) !{{{1
!-----------------------------------------------------------
! merge a subdomain variable with varname to a global var
!-----------------------------------------------------------

  character (len=*), intent(in) :: varname, meshname
  real (kind=sp) :: var_glo(nx_glo, ny_glo)
  real (kind=sp) :: new_var(new_nx,new_ny)
  integer :: iai, ibi, jai, jbi, &
             iah, ibh, jah, jbh, &
             ia, ib, ja, jb, i


  write(*,*) "*** read variable '"//varname//"' from file "//meshname
  call io_read( meshname, varname, var_glo )

  do i = 1, new_ncpu
    ! the default value for exceed boundary halo row is 0 in NEMO
    new_var = 0 
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname

    ! halo area
    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    !total area
    ia = rst % pos_fst % val(1)
    ja = rst % pos_fst % val(2)
    ib = rst % pos_lst % val(1)
    jb = rst % pos_lst % val(2)

    ! internal area
    iai = ia + iah
    jai = ja + jah
    ibi = ib - ibh
    jbi = jb - jbh

    if ( ib <= nx_glo .and. jb <= ny_glo ) then
      new_var = var_glo(ia:ib,ja:jb)
    ! one more halo row to fill the subdomain
    else if ( ib <= nx_glo .and. jb == ny_glo + 1 ) then
      new_var(:,1:new_ny-1) = var_glo(ia:ib,ja:ny_glo)
      new_var(:,new_ny) = var_glo(ia:ib,ny_glo)
      if (rst % vac_west) then ! west is vacant mask
        new_var(1,new_ny) = new_var(2,new_ny)
      end if
      if (rst % vac_east) then
        new_var(new_nx,new_ny) = new_var(new_nx-1,new_ny)
      end if
    else if ( jb <= ny_glo .and. ib == nx_glo + 1 ) then
      new_var(1:new_nx-1,:) = var_glo(ia:nx_glo,ja:jb)
      new_var(new_nx,:) = var_glo(1,ja:jb)
      if (rst % vac_north) then ! north is vacant mask
        new_var(new_nx,new_ny) = new_var(new_nx,new_ny-1)
      end if
      if (rst % vac_south) then
        new_var(new_nx,1) = new_var(new_nx,2)
      end if
    else
      write(*,*) "subdomain range of: ", ib, jb, &
        "out of the global range of:", nx_glo, ny_glo, "stop."
      stop
    end if

    ! deal with 2 rows of halo
    if (ibh == 2) then
      new_var(new_nx,:) = new_var(new_nx-2,:)
      if (rst % vac_north) then ! north is vacant mask
        new_var(new_nx,new_ny) = new_var(new_nx,new_ny-1)
      end if
      if (rst % vac_south) then
        new_var(new_nx,1) = new_var(new_nx,2)
      end if
    end if
    if (jbh == 2) then
      new_var(:,new_ny) = new_var(:,new_ny-2)
      if (rst % vac_west) then ! west is vacant mask
        new_var(1,new_ny) = new_var(2,new_ny)
      end if
      if (rst % vac_east) then
        new_var(new_nx,new_ny) = new_var(new_nx-1,new_ny)
      end if
    end if

    call io_output( trim(ncname), varname, new_var )

  end do
  write(*,*) "*** SUCCESS split variable '"//varname//"' from "//meshname

end subroutine split_latlon

subroutine resplit_double3d( varname ) !{{{1

  character (len=*), intent(in) :: varname
  real (kind=dp) :: missing
  real (kind=dp) :: var_glo(nx_glo, ny_glo, nz)
  real (kind=dp) :: var(nx, ny, nz)
  real (kind=dp) :: new_var(new_nx, new_ny, nz)
  integer :: iai, ibi, jai, jbi, &
             iah, ibh, jah, jbh, &
             ia, ib, ja, jb, i


  missing = 0
  if (varname == 'dissl' ) &
    missing = 0.000000000001
  var_glo = missing
! merge {{{2
  write(*,*) "*** merging variable '"//varname//"'~ ~ ~ ~ ~ ~"
  do i = 1, ncpu
    var = missing
    rst    = rsts(i)
    ncname = trim(rst_dir)//rst%fname
    call io_read( trim(ncname), varname, var )

    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    iai = rst % pos_fst % val(1) + iah
    jai = rst % pos_fst % val(2) + jah
    ibi = rst % pos_lst % val(1) - ibh
    jbi = rst % pos_lst % val(2) - jbh

    ! exclude halo rows
    var_glo(iai:ibi,jai:jbi,:) = var(1+iah:nx-ibh,1+jah:ny-jbh,:) 
  end do

! resplit {{{2
  do i = 1, new_ncpu
    ! exceed boundary halo row is missing in NEMO
    new_var = missing
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname

    ! halo area
    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    !total area
    ia = rst % pos_fst % val(1)
    ja = rst % pos_fst % val(2)
    ib = rst % pos_lst % val(1)
    jb = rst % pos_lst % val(2)

    ! internal area
    iai = ia + iah
    jai = ja + jah
    ibi = ib - ibh
    jbi = jb - jbh

    if ( ib <= nx_glo .and. jb <= ny_glo ) then
      new_var = var_glo(ia:ib,ja:jb,:)
    ! one more halo row to fill the subdomain
    else if ( ib <= nx_glo .and. jb == ny_glo + 1 ) then
      new_var(:,1:new_ny-1,:) = var_glo(ia:ib,ja:ny_glo,:)
      new_var(:,new_ny,:) = missing ! halo not change with time
    else if ( jb <= ny_glo .and. ib == nx_glo + 1 ) then
      new_var(1:new_nx-1,:,:) = var_glo(ia:nx_glo,ja:jb,:)
      new_var(new_nx,:,:) = missing
    else
      write(*,*) "subdomain range of: ", ib, jb, &
        "out of the global range of:", nx_glo, ny_glo, "stop."
      stop
    end if

    ! deal with 2 rows of halo
    if (ibh == 2) then
      new_var(new_nx,:,:) = missing
      if (rst % vac_east) &
        new_var(new_nx-1,1+jah:new_ny-jbh,:) = missing
    end if
    if (jbh == 2) then
      new_var(:,new_ny,:) = missing
      if (rst % vac_north) new_var(:,new_ny-1,:) = missing
    end if

    if ( varname == 'dissl' ) then
      new_var(1:iah,:,:)              = missing
      new_var(new_nx-ibh+1:new_nx,:,:)= missing
      new_var(:,1:jah,:)              = missing
      if ( jbh == 1 ) new_var(:,new_ny,:) = missing
      if ( jbh == 2 .and. rst % vac_north) &
        new_var(:,new_ny-1,:) = new_var(:,new_ny-2,:)
    end if

    call io_output( trim(ncname), varname, new_var )

  end do

  write(*,*) "*** SUCCESS resplit variable '"//varname//"'"
end subroutine resplit_double3d

subroutine resplit_double2d_ice( varname ) !{{{1

  character (len=*), intent(in) :: varname
  real (kind=dp) :: missing
  real (kind=dp) :: var_glo(nx_glo, ny_glo)
  real (kind=dp) :: var(nx, ny)
  real (kind=dp) :: new_var(new_nx,new_ny)
  integer :: iai, ibi, jai, jbi, &
             iah, ibh, jah, jbh, &
             ia, ib, ja, jb, i, j


  missing = 0
  if (varname == 'sist'  .or. varname == 'tbif1' .or. &
      varname == 'tbif2' .or. varname == 'tbif3' ) &
      missing = 273.15
  var_glo = missing
! merge {{{2
  write(*,*) "*** merging variable '"//varname//"'~ ~ ~ ~ ~ ~"
  do i = 1, ncpu
    var = missing 
    rst    = rsts(i)
    ncname = trim(rst_dir)//rst%fname
    call io_read( trim(ncname), varname, var )

    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    iai = rst % pos_fst % val(1) + iah
    jai = rst % pos_fst % val(2) + jah
    ibi = rst % pos_lst % val(1) - ibh
    jbi = rst % pos_lst % val(2) - jbh

    ! exclude halo rows
    var_glo(iai:ibi,jai:jbi) = var(1+iah:nx-ibh, 1+jah:ny-jbh) 
  end do

  ! DEBUG
!  print *, var_glo(2018, 3059)

! resplit {{{2
  do i = 1, new_ncpu
    ! the default value for exceed boundary halo row is missing in NEMO
    new_var = missing 
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname

    ! halo area
    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    !total area
    ia = rst % pos_fst % val(1)
    ja = rst % pos_fst % val(2)
    ib = rst % pos_lst % val(1)
    jb = rst % pos_lst % val(2)

    ! internal area
    iai = ia + iah
    jai = ja + jah
    ibi = ib - ibh
    jbi = jb - jbh

    if ( ib <= nx_glo .and. jb <= ny_glo ) then
      new_var = var_glo(ia:ib,ja:jb)
    ! one more halo row to fill the subdomain
    else if ( ib <= nx_glo .and. jb == ny_glo + 1 ) then
      new_var(:,1:new_ny-1) = var_glo(ia:ib,ja:ny_glo)
      new_var(:,new_ny) = missing ! halo not change with time
    else if ( jb <= ny_glo .and. ib == nx_glo + 1 ) then
      new_var(1:new_nx-1,:) = var_glo(ia:nx_glo,ja:jb)
      new_var(new_nx,:) = missing
    else
      write(*,*) "subdomain range of: ", ib, jb, &
        "out of the global range of:", nx_glo, ny_glo, "stop."
      stop
    end if

    ! deal with 2 rows of halo
    if (ibh == 2) then
      new_var(new_nx,:) = missing 
      if (rst % vac_east) new_var(new_nx-1,1+jah:new_ny-jbh) = missing
    end if
    if (jbh == 2) then
      new_var(:,new_ny) = missing
      if (rst % vac_north) new_var(:,new_ny-1) = missing
    end if

    ! deal with neighbor is vacant mask
    if (iah == 1 .and. rst % vac_west) &
      new_var(1,1+jah:new_ny-jbh) = missing ! west is vacant
    if (ibh == 1 .and. rst % vac_east) &
      new_var(new_nx,1+jah:new_ny-jbh) = missing
    if (jah == 1 .and. rst % vac_south) &
      new_var(:,1) = missing
    if (jbh == 1 .and. rst % vac_north) &
      new_var(:,new_ny) = missing

    call io_output( trim(ncname), varname, new_var )

  end do
  write(*,*) "*** SUCCESS resplit variable '"//varname//"'"

end subroutine resplit_double2d_ice

subroutine resplit_double2d_rst( varname ) !{{{1

  character (len=*), intent(in) :: varname
  real (kind=dp) :: missing
  real (kind=dp) :: var_glo(nx_glo, ny_glo)
  real (kind=dp) :: var(nx, ny)
  real (kind=dp) :: new_var(new_nx,new_ny)
  integer :: iai, ibi, jai, jbi, &
             iah, ibh, jah, jbh, &
             ia, ib, ja, jb, i, j


  missing = 0
  if (varname == 'ssh_ibb' ) &
    missing = 10.93598839848667303442653064848855138
  if (varname == 'ssh_m' ) &
    missing = -32.80796519546002087963643134571611881
  var_glo = missing
! merge {{{2
  write(*,*) "*** merging variable '"//varname//"'~ ~ ~ ~ ~ ~"
  do i = 1, ncpu
    var = missing 
    rst    = rsts(i)
    ncname = trim(rst_dir)//rst%fname
    call io_read( trim(ncname), varname, var )

    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    iai = rst % pos_fst % val(1) + iah
    jai = rst % pos_fst % val(2) + jah
    ibi = rst % pos_lst % val(1) - ibh
    jbi = rst % pos_lst % val(2) - jbh

    ! exclude halo rows
    var_glo(iai:ibi,jai:jbi) = var(1+iah:nx-ibh, 1+jah:ny-jbh) 
  end do

! resplit {{{2
  do i = 1, new_ncpu
    new_var = missing 
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname

    ! halo area
    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    !total area
    ia = rst % pos_fst % val(1)
    ja = rst % pos_fst % val(2)
    ib = rst % pos_lst % val(1)
    jb = rst % pos_lst % val(2)

    ! internal area
    iai = ia + iah
    jai = ja + jah
    ibi = ib - ibh
    jbi = jb - jbh

    if ( ib <= nx_glo .and. jb <= ny_glo ) then
      new_var = var_glo(ia:ib,ja:jb)
    ! one more halo row to fill the subdomain
    else if ( ib <= nx_glo .and. jb == ny_glo + 1 ) then
      new_var(:,1:new_ny-1) = var_glo(ia:ib,ja:ny_glo)
      if (varname == 'ssh_ibb' .or. &
          varname == 'ssh_m'   .or. &
          varname == 'rnf_b' ) then
        new_var(:,new_ny) = new_var(:,new_ny-1)
      else
        new_var(:,new_ny) = missing
      end if
    else if ( jb <= ny_glo .and. ib == nx_glo + 1 ) then
      new_var(1:new_nx-1,:) = var_glo(ia:nx_glo,ja:jb)
      if (varname == 'ssh_ibb' .or. &
          varname == 'ssh_m'   .or. &
          varname == 'rnf_b' ) then
        new_var(new_nx,:) = new_var(new_nx-1,:)
      else
        new_var(new_nx,:) = missing
      end if
    else
      write(*,*) "subdomain range of: ", ib, jb, &
        "out of the global range of:", nx_glo, ny_glo, "stop."
      stop
    end if

    ! deal with 2 rows of halo
    if (ibh == 2) then
      if (varname == 'ssh_ibb' .or. &
          varname == 'ssh_m'   .or. &
          varname == 'rnf_b' ) then
        new_var(new_nx,:) = new_var(new_nx-2,:)
      else
        new_var(new_nx,:) = missing
      end if
      if (rst % vac_east) &
        new_var(new_nx-1,1+jah:new_ny-jbh) = missing
    end if
    if (jbh == 2) then
      if (varname == 'ssh_ibb' .or. &
          varname == 'ssh_m'   .or. &
          varname == 'rnf_b' ) then
        new_var(:,new_ny) = new_var(:,new_ny-2)
      else
        new_var(:,new_ny) = missing
      end if
      if (rst % vac_north) new_var(:,new_ny-1) = missing
    end if

    ! deal with neighbor is vacant mask
    if (iah == 1 .and. rst % vac_west) &
      new_var(1,1+jah:new_ny-jbh) = missing ! west is vacant
    if (ibh == 1 .and. rst % vac_east) &
      new_var(new_nx,1+jah:new_ny-jbh) = missing
    if (jah == 1 .and. rst % vac_south) &
      new_var(:,1) = missing
    if (jbh == 1 .and. rst % vac_north) &
      new_var(:,new_ny) = missing

    ! all halo are missing
    if ( varname == 'sbc_hc_b' .or. &
         varname == 'sbc_sc_b' ) then
      new_var(1:iah,:)               = missing
      new_var(new_nx-ibh+1:new_nx,:) = missing
      new_var(:,1:jah)               = missing
    end if

    if ( varname == 'gcxb' ) then
      new_var(1:iah,:)               = missing
      new_var(new_nx-ibh+1:new_nx,:) = missing
      new_var(:,1:jah)               = missing
      if ( jbh == 1 ) new_var(:,new_ny) = missing
    end if

    call io_output( trim(ncname), varname, new_var )

  end do
  write(*,*) "*** SUCCESS resplit variable '"//varname//"'"

end subroutine resplit_double2d_rst

subroutine resplit_float2d( varname ) !{{{1
!-----------------------------------------------------------
! merge a subdomain variable with varname to a global var
!-----------------------------------------------------------

  character (len=*), intent(in) :: varname
  real (kind=sp) :: var_glo(nx_glo, ny_glo)
  real (kind=sp) :: var(nx, ny)
  real (kind=sp) :: new_var(new_nx,new_ny)
  integer :: iai, ibi, jai, jbi, &
             iah, ibh, jah, jbh, &
             ia, ib, ja, jb, i


! merge {{{2
  write(*,*) "*** merging variable '"//varname//"'~ ~ ~ ~ ~ ~"
  do i = 1, ncpu
    var = 0
    rst    = rsts(i)
    ncname = trim(rst_dir)//rst%fname
    call io_read( trim(ncname), varname, var )

    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    iai = rst % pos_fst % val(1) + iah
    jai = rst % pos_fst % val(2) + jah
    ibi = rst % pos_lst % val(1) - ibh
    jbi = rst % pos_lst % val(2) - jbh

    ! exclude halo rows
    var_glo(iai:ibi,jai:jbi) = var(1+iah:nx-ibh, 1+jah:ny-jbh) 
  end do

! resplit {{{2
  do i = 1, new_ncpu
    ! the default value for exceed boundary halo row is 0 in NEMO
    new_var = 0 
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname

    ! halo area
    iah = rst % ha_sta % val(1)
    jah = rst % ha_sta % val(2)
    ibh = rst % ha_end % val(1)
    jbh = rst % ha_end % val(2)

    !total area
    ia = rst % pos_fst % val(1)
    ja = rst % pos_fst % val(2)
    ib = rst % pos_lst % val(1)
    jb = rst % pos_lst % val(2)

    ! internal area
    iai = ia + iah
    jai = ja + jah
    ibi = ib - ibh
    jbi = jb - jbh

    if ( ib <= nx_glo .and. jb <= ny_glo ) then
      new_var = var_glo(ia:ib,ja:jb)
    ! one more halo row to fill the subdomain
    else if ( ib <= nx_glo .and. jb == ny_glo + 1 ) then
      new_var(:,1:new_ny-1) = var_glo(ia:ib,ja:ny_glo)
      new_var(:,new_ny) = var_glo(ia:ib,ny_glo)
    else if ( jb <= ny_glo .and. ib == nx_glo + 1 ) then
      new_var(1:new_nx-1,:) = var_glo(ia:nx_glo,ja:jb)
      new_var(new_nx,:) = var_glo(1,ja:jb)
    else
      write(*,*) "subdomain range of: ", ib, jb, &
        "out of the global range of:", nx_glo, ny_glo, "stop."
      stop
    end if

    ! deal with 2 rows of halo
    if (ibh == 2) then
      new_var(new_nx,:) = new_var(new_nx-2,:)
    end if
    if (jbh == 2) then
      new_var(:,new_ny) = new_var(:,new_ny-2)
    end if

    call io_output( trim(ncname), varname, new_var )

  end do
  write(*,*) "*** SUCCESS resplit variable '"//varname//"'"

end subroutine resplit_float2d

subroutine copy_scalar( varname ) !{{{1
!-----------------------------------------------------------
! merge a subdomain variable with varname to a global var
!-----------------------------------------------------------

  character (len=*), intent(in) :: varname
  real (kind=dp) :: var
  integer :: i

  ncname = trim(rst_dir)//rsts(1)%fname
  call io_read( trim(ncname), varname, var )

  do i = 1, new_ncpu
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname
    call io_output( trim(ncname), varname, var )
  end do

  write(*,*) "*** SUCCESS copy scalar '"//varname//"'"
end subroutine copy_scalar

subroutine copy_float1d( varname ) !{{{1
!-----------------------------------------------------------
! merge a subdomain variable with varname to a global var
!-----------------------------------------------------------

  character (len=*), intent(in) :: varname
  real (kind=sp) :: var(nz)
  integer :: i

  ncname = trim(rst_dir)//rsts(1)%fname
  call io_read( trim(ncname), varname, var )

  do i = 1, new_ncpu
    rst    = new_rsts(i)
    ncname = trim(out_dir)//rst%fname
    call io_output( trim(ncname), varname, var )
  end do

  write(*,*) "*** SUCCESS copy depth '"//varname//"'"
end subroutine copy_float1d

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
!  inquire( directory = trim(out_dir), exist = hasdir )
!  if ( .not.hasdir ) then 
!    write(*,*)'Output directory "'//out_dir//&
!      '" not created yet.' 
!    needstop = .true.
!  end if

  write(infofname, '(A,I0.4,A)') 'domain_info/N', ncpu, '.nc'
  inquire( file = trim(infofname), exist = hasfile )
  if ( .not. hasfile ) then 
    write(*,*)'run create_domain_info to get '//infofname//&
      ' first.'
    needstop = .true.
  end if

  write(infofname, '(A,I0.4,A)') 'domain_info/N', new_ncpu, '.nc'
  inquire( file = trim(infofname), exist = hasfile )
  if ( .not. hasfile ) then 
    write(*,*)'run create_domain_info to get '//infofname//&
      ' first.'
    needstop = .true.
  end if

  if ( needstop ) stop

end subroutine pre_check

end program main !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
