
! Description: basic NetCDF input/output interface
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-03-06 10:38:13 BJT
! Last Change: 2015-06-28 09:38:19 BJT

module mod_io !{{{1 
!-------------------------------------------------------{{{1
!external variables-------------------------------------{{{2
  use netcdf
  use mod_param, only: ncpu, sp, dp, missing_int, &
    nx_glo, ny_glo, nx, ny, nz, &
    rst_dir, out_dir, rst_prefix
  use mod_type, only: struct_nc, &
    ncvar_int1d, ncvar_float2d, &
    dict_str, dict_int, dict_int2

  implicit none
  private

!public subroutines-------------------------------------{{{2

  public &
    io_create_rst,    &
    io_create_rst_ice,&
    io_is_similar,    &
    io_get_nc_info,   &
    io_print_nc_info, &
    io_output_cpus,   &
    io_output_domain, &
    io_output,        &
    io_read

!internal variables-------------------------------------{{{2

  integer :: ncid, varid, ndim1, ndim2

!interfaces---------------------------------------------{{{2
!-----------------------------------------------------------
  interface io_output
    module procedure output_scalar
    module procedure output_int2d
    module procedure output_int1d
    module procedure output_float2d
    module procedure output_float1d
    module procedure output_double2d
    module procedure output_double3d
  end interface

  interface io_read
    module procedure read_double3d
    module procedure read_double2d
    module procedure read_scalar
    module procedure read_float2d
    module procedure read_float1d
    module procedure read_int1d
    module procedure read_infofile
  end interface

  interface get_att_val
    module procedure get_att_val_str
    module procedure get_att_val_int
    module procedure get_att_val_int2
  end interface

  interface print_att
    module procedure print_att_str
    module procedure print_att_int
    module procedure print_att_int2
  end interface

  interface operator(==)
    module procedure dict_equal_str
    module procedure dict_equal_int
    module procedure dict_equal_int2
  end interface

contains !{{{1
!-------------------------------------------------------{{{1

subroutine io_create_rst_ice(rst) !{{{2

  type(struct_nc),  intent(in) :: rst

  integer :: dimid1, dimid2, dimid3, dimid4, i

  call check( nf90_create(trim(out_dir)//trim(rst % fname), &
    NF90_CLOBBER, ncid)  )

  !def dim. {{{3
  call check( nf90_def_dim(ncid, 'x', rst % nx, dimid1) )
  call check( nf90_def_dim(ncid, 'y', rst % ny, dimid2) )
  call check( nf90_def_dim(ncid, 'z', rst % nz, dimid3) )
  call check( nf90_def_dim(ncid, "t", NF90_UNLIMITED, dimid4) )

  !def global attr. {{{3
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % cpus % key), rst % cpus % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % cpu % key), rst % cpu % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % dim_ids % key), rst % dim_ids % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % size_glo % key), rst % size_glo % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % size_loc % key), rst % size_loc % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % pos_fst % key), rst % pos_fst % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % pos_lst % key), rst % pos_lst % val) )
  
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % ha_sta % key), rst % ha_sta % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % ha_end % key), rst % ha_end % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % dm_type % key), rst % dm_type % val) )

  !def vars {{{3
  call check( nf90_def_var(ncid, "nav_lon", nf90_float, &
    (/dimid1, dimid2/), varid) )
  call check( nf90_def_var(ncid, "nav_lat", nf90_float, &
    (/dimid1, dimid2/), varid) )
  call check( nf90_def_var(ncid, "nav_lev", nf90_float, &
    (/dimid3/), varid) )

  call check( nf90_def_var(ncid, "time_counter", nf90_double, &
    (/dimid4/), varid) )

  call check( nf90_def_var(ncid, 'kt_ice', nf90_double, varid) )

  call check( nf90_def_var(ncid, 'hicif', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'hsnif', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'frld', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sist', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'tbif1', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'tbif2', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'tbif3', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'u_ice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'v_ice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'qstoif', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'fsbbq', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'stress1_i', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'stress2_i', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'stress12_i', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syyice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxyice', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxsn', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sysn', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxsn', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syysn', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxysn', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxa', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sya', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxa', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syya', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxya', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxc0', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syc0', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxc0', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syyc0', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxyc0', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxc1', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syc1', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxc1', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syyc1', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxyc1', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxc2', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syc2', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxc2', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syyc2', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxyc2', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sxst', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syst', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxxst', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'syyst', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )
  call check( nf90_def_var(ncid, 'sxyst', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  !end def {{{3
  call check( nf90_enddef(ncid) )

  call check( nf90_close(ncid) )

end subroutine io_create_rst_ice

subroutine io_create_rst(rst) !{{{2

  type(struct_nc),  intent(in) :: rst

  integer :: dimid1, dimid2, dimid3, dimid4, i

  call check( nf90_create(trim(out_dir)//trim(rst % fname), &
    NF90_CLOBBER, ncid)  )

  !def dim. {{{3
  call check( nf90_def_dim(ncid, 'x', rst % nx, dimid1) )
  call check( nf90_def_dim(ncid, 'y', rst % ny, dimid2) )
  call check( nf90_def_dim(ncid, 'z', rst % nz, dimid3) )
  call check( nf90_def_dim(ncid, "t", NF90_UNLIMITED, dimid4) )

  !def global attr. {{{3
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % cpus % key), rst % cpus % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % cpu % key), rst % cpu % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % dim_ids % key), rst % dim_ids % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % size_glo % key), rst % size_glo % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % size_loc % key), rst % size_loc % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % pos_fst % key), rst % pos_fst % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % pos_lst % key), rst % pos_lst % val) )
  
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % ha_sta % key), rst % ha_sta % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % ha_end % key), rst % ha_end % val) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    trim(rst % dm_type % key), rst % dm_type % val) )

  !def vars {{{3
  call check( nf90_def_var(ncid, "nav_lon", nf90_float, &
    (/dimid1, dimid2/), varid) )
  call check( nf90_def_var(ncid, "nav_lat", nf90_float, &
    (/dimid1, dimid2/), varid) )
  call check( nf90_def_var(ncid, "nav_lev", nf90_float, &
    (/dimid3/), varid) )

  call check( nf90_def_var(ncid, "time_counter", nf90_double, &
    (/dimid4/), varid) )

  call check( nf90_def_var(ncid, 'kt', nf90_double, varid) )
  call check( nf90_def_var(ncid, 'ndastp', nf90_double, varid) )
  call check( nf90_def_var(ncid, 'adatrj', nf90_double, varid) )

  call check( nf90_def_var(ncid, 'ssh_ibb', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'nn_fsbc', nf90_double, varid) )

  call check( nf90_def_var(ncid, 'ssu_m', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'ssv_m', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sst_m', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sss_m', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'ssh_m', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rnf_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rnf_hc_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rnf_sc_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'utau_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'vtau_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'qns_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'emp_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'emps_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'en', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'avt', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'avm', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'avmu', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'avmv', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'dissl', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sbc_hc_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sbc_sc_b', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'gcx', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'gcxb', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rdt', nf90_double, varid ) )
  call check( nf90_def_var(ncid, 'rdttra1', nf90_double, varid ) )

  call check( nf90_def_var(ncid, 'ub', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'vb', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'tb', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sb', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rotb', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'hdivb', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sshb', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'un', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'vn', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'tn', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sn', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rotn', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'hdivn', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'sshn', nf90_double, &
    (/dimid1, dimid2, dimid4/), varid) )

  call check( nf90_def_var(ncid, 'rhop', nf90_double, &
    (/dimid1, dimid2, dimid3, dimid4/), varid) )

  !end def {{{3
  call check( nf90_enddef(ncid) )

  call check( nf90_close(ncid) )

end subroutine io_create_rst

subroutine output_int2d(ncname, varname, longname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  character (len = *), intent(in), optional :: longname
  integer, intent(in) :: var(:,:)
  integer :: dimid1, dimid2

  call check( nf90_create(ncname, NF90_CLOBBER, ncid)  )

  ! def dim.
  call check( nf90_def_dim(ncid, 'x', size(var, 1), dimid1) )
  call check( nf90_def_dim(ncid, 'y', size(var, 2), dimid2) )

  ! def vars
  call check( nf90_def_var(ncid, varname, nf90_int, &
    (/dimid1, dimid2/), varid) )
  if (present(longname)) &
    call check( nf90_put_att(ncid, varid, 'long_name', longname) )
  call check( nf90_put_att(ncid, varid, '_FillValue', &
    missing_int) )
  call check( nf90_enddef(ncid) )

  ! output var
  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

!  write(*,*) '*** SUCCESS output '//varname//' to file: '//ncname

end subroutine output_int2d

subroutine output_float2d(ncname, varname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  real (kind=sp), intent(in) :: var(:,:)

  call check( nf90_open(ncname, nf90_write, ncid)  )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

!  write(*,*) '*** SUCCESS output '//varname//' to file: '//ncname

end subroutine output_float2d

subroutine output_float1d(ncname, varname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  real (kind=sp), intent(in) :: var(:)

  call check( nf90_open(ncname, nf90_write, ncid)  )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

!  write(*,*) '*** SUCCESS output '//varname//' to file: '//ncname

end subroutine output_float1d

subroutine output_scalar(ncname, varname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  real (kind=dp), intent(in) :: var

  call check( nf90_open(ncname, nf90_write, ncid)  )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

!  write(*,*) '*** SUCCESS output '//varname//' to file: '//ncname

end subroutine output_scalar

subroutine output_double3d(ncname, varname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  real (kind=dp), intent(in) :: var(:,:,:)

  call check( nf90_open(ncname, nf90_write, ncid)  )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

!  write(*,*) '*** SUCCESS output '//varname//' to file: '//ncname

end subroutine output_double3d

subroutine output_double2d(ncname, varname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  real (kind=dp), intent(in) :: var(:,:)

  call check( nf90_open(ncname, nf90_write, ncid)  )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

!  write(*,*) '*** SUCCESS output '//varname//' to file: '//ncname

end subroutine output_double2d

subroutine output_int1d(ncname, varname, var) !{{{2

  character (len = *), intent(in) :: ncname, varname
  integer, intent(in) :: var(:)
  integer :: i

  call check( nf90_open(ncname, NF90_WRITE, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_put_var(ncid, varid, var) )

  call check( nf90_close(ncid) )

end subroutine output_int1d

subroutine io_output_domain( ncname, vars ) !{{{2

  character (len = *), intent(in) :: ncname
  type (ncvar_int1d), intent(in) :: vars(:)

  integer :: cpudim(ncpu)
  integer :: dimid, cpuid, i

  call check( nf90_create(ncname, NF90_CLOBBER, ncid)  )

  ! def dim. {{{3
  call check( nf90_def_dim(ncid, 'cpu', ncpu, dimid) )

  ! def global attr. !{{{3
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'nx_ny_nz_nt', (/nx, ny, nz, 1/)) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_number_total', ncpu) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_dimensions_ids', (/1,2/)) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_size_global', (/nx_glo, ny_glo/)) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_size_local', (/nx, ny/)) )

  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_type', 'BOX') )

  ! def vars !{{{3
  call check( nf90_def_var(ncid, 'cpu', nf90_int, dimid, cpuid) )
  call check( nf90_put_att(ncid, cpuid, 'long_name', &
    'MPI CPU index') )

  do i = 1, size(vars)
    call check( nf90_def_var(ncid, trim(vars(i)%varname), &
      nf90_int, dimid, varid) )
    call check( nf90_put_att(ncid, varid, 'long_name', &
      trim(vars(i)%longname)) )
  end do

  call check( nf90_enddef(ncid) )

  ! write data !{{{3
  forall ( i=1:ncpu )
    cpudim(i) = i - 1
  end forall
  call check( nf90_put_var(ncid, cpuid, cpudim) )

  do i = 1, size(vars)
    call check( nf90_inq_varid(ncid, trim(vars(i)%varname), &
      varid) )
    call check( nf90_put_var(ncid, varid, vars(i) % p) )
  end do

  ! close file !{{{3
  call check( nf90_close(ncid) )

  write(*,*) '*** SUCCESS output MPI domain infos to file: '&
    //ncname

end subroutine io_output_domain

subroutine io_output_cpus( ncname, cpus, ic, jc ) !{{{2

  character (len = *), intent(in) :: ncname
  integer, intent(in) :: cpus(:,:), ic(:), jc(:)

  integer :: dimids(3), cpudim(ncpu), stt(3), cnt(3)
  integer :: nrec, i, &
             dimid1, dimid2, dimid3, cpuid, time_dimid, &
             cpusid, icid, jcid

  ndim1 = size(cpus, 1)
  ndim2 = size(cpus, 2)

  nrec = 1
  stt  = (/1, 1, nrec/)
  cnt  = (/ndim1, ndim2, 1/)

  call check( nf90_create(ncname, NF90_CLOBBER, ncid)  )

  ! def dim. {{{3
  call check( nf90_def_dim(ncid, 'x', ndim1, dimid1) )
  call check( nf90_def_dim(ncid, 'y', ndim2, dimid2) )
  call check( nf90_def_dim(ncid, 'cpu', ncpu, dimid3) )
  call check( nf90_def_dim(ncid, 'time', NF90_UNLIMITED, &
    time_dimid) )

  ! def global attr. !{{{3
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_number_total', ncpu) )
  call check( nf90_put_att(ncid, NF90_GLOBAL, & 
    'DOMAIN_size_global', (/ndim1, ndim2/)) )

  ! def vars !{{{3
  dimids =  (/ dimid1, dimid2, time_dimid /)
  call check( nf90_def_var(ncid, 'cpu', nf90_int, dimid3, cpuid) )

  call check( nf90_def_var(ncid, 'cpus', nf90_int, dimids, &
    cpusid) )
  call check( nf90_put_att(ncid, cpusid, 'long_name', &
    'cpu index per grid') )
  call check( nf90_put_att(ncid, cpusid, '_FillValue', &
    missing_int) )

  call check( nf90_def_var(ncid, 'ic', nf90_int, dimid3, icid) )
  call check( nf90_put_att(ncid, icid, 'long_name', &
    'center i index per cpu') )

  call check( nf90_def_var(ncid, 'jc', nf90_int, dimid3, jcid) )
  call check( nf90_put_att(ncid, jcid, 'long_name', &
    'center j index per cpu') )

  call check( nf90_enddef(ncid) )

  ! write data !{{{3
  forall ( i=1:ncpu )
    cpudim(i) = i - 1
  end forall
  call check( nf90_put_var(ncid, cpuid, cpudim) )

  call check( nf90_put_var(ncid, icid, ic) )
  call check( nf90_put_var(ncid, jcid, jc) )

  call check( nf90_put_var(ncid, cpusid, cpus, &
    start = stt, count = cnt) )

  ! close file !{{{3
  call check( nf90_close(ncid) )

  write(*,*) '*** SUCCESS output CPU-infos to file: '//ncname

end subroutine io_output_cpus

subroutine read_infofile(ncname, var) !{{{2
!-----------------------------------------------------------
! read domain infomations from an info file
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname
  type (struct_nc) :: var(:)
  integer, dimension(:,:), allocatable :: mask_glo
  integer, dimension(:), allocatable :: ia, ja, ib, jb, &
    iah, jah, ibh, jbh, ic, jc
  integer :: xyzt(4), lsize(2), gsize(2), ndim
  character (len = 200) :: rstname
  integer :: i, istat, icw, ice, jcn, jcs

  call check( nf90_open(ncname, NF90_NOWRITE, ncid) )

!---get variables---------------------------------------{{{3

  ndim = get_dim_len( ncid, 'cpu' ) 
  if ( ndim /= size(var) ) stop &
    'read_infofile: cpu numbers not match between the program and the domain info file! Stop!'

  allocate( ia(ndim), stat = istat ); call check( istat )
  allocate( ja(ndim), stat = istat ); call check( istat )
  allocate( ib(ndim), stat = istat ); call check( istat )
  allocate( jb(ndim), stat = istat ); call check( istat )

  allocate( iah(ndim), stat = istat ); call check( istat )
  allocate( jah(ndim), stat = istat ); call check( istat )
  allocate( ibh(ndim), stat = istat ); call check( istat )
  allocate( jbh(ndim), stat = istat ); call check( istat )

  allocate( ic(ndim), stat = istat ); call check( istat )
  allocate( jc(ndim), stat = istat ); call check( istat )

  call check( nf90_get_att(ncid, nf90_global, &
    'nx_ny_nz_nt', xyzt) )
  call check( nf90_get_att(ncid, nf90_global, &
    'DOMAIN_size_global', gsize) )
  call check( nf90_get_att(ncid, nf90_global, &
    'DOMAIN_size_local', lsize) )

  call check( nf90_inq_varid(ncid, 'ia', varid) )
  call check( nf90_get_var(ncid, varid, ia) )

  call check( nf90_inq_varid(ncid, 'ja', varid) )
  call check( nf90_get_var(ncid, varid, ja) )

  call check( nf90_inq_varid(ncid, 'ib', varid) )
  call check( nf90_get_var(ncid, varid, ib) )

  call check( nf90_inq_varid(ncid, 'jb', varid) )
  call check( nf90_get_var(ncid, varid, jb) )

  call check( nf90_inq_varid(ncid, 'iah', varid) )
  call check( nf90_get_var(ncid, varid, iah) )

  call check( nf90_inq_varid(ncid, 'jah', varid) )
  call check( nf90_get_var(ncid, varid, jah) )

  call check( nf90_inq_varid(ncid, 'ibh', varid) )
  call check( nf90_get_var(ncid, varid, ibh) )

  call check( nf90_inq_varid(ncid, 'jbh', varid) )
  call check( nf90_get_var(ncid, varid, jbh) )

  call check( nf90_close(ncid) )

  allocate( mask_glo(gsize(1), gsize(2)), stat = istat )
  call check( istat )
  mask_glo = 0

!---set variables---------------------------------------{{{3

  ic = ( ia + ib ) / 2
  jc = ( ja + jb ) / 2

  do i = 1, ndim
!    write(rstname, '(A,I0.4,A)') &
!      trim(rst_dir)//trim(rst_prefix), i-1, '.nc'
    write(rstname, '(A,I0.4,A)') trim(rst_prefix), i-1, '.nc'

    var(i) % fname = rstname

    var(i) % nx = xyzt(1)
    var(i) % ny = xyzt(2)
    var(i) % nz = xyzt(3)
    var(i) % nt = xyzt(4)

    var(i) % cpus     = dict_int('DOMAIN_number_total', ndim)
    var(i) % cpu      = dict_int('DOMAIN_number', i-1)
    var(i) % dim_ids  = dict_int2('DOMAIN_dimensions_ids', (/1,2/))
    var(i) % size_glo = dict_int2('DOMAIN_size_global', gsize)
    var(i) % size_loc = dict_int2('DOMAIN_size_local',  lsize)

    var(i) % pos_fst  = &
      dict_int2('DOMAIN_position_first', (/ia(i),ja(i)/))
    var(i) % pos_lst  = &
      dict_int2('DOMAIN_position_last', (/ib(i),jb(i)/))
    var(i) % ha_sta   = &
      dict_int2('DOMAIN_halo_size_start', (/iah(i),jah(i)/))
    var(i) % ha_end   = &
      dict_int2('DOMAIN_halo_size_end', (/ibh(i),jbh(i)/))

    var(i) % dm_type  = dict_str('DOMAIN_type', 'BOX')
    var(i) % vac_west = .false.
    var(i) % vac_east = .false.
    var(i) % vac_north = .false.
    var(i) % vac_south = .false.

    ! just for sub-domain check, so boundary is not important
    mask_glo(ia(i)-1:ib(i)-1,ja(i)-1:jb(i)-1) = 1
  end do

! determine vacant masks {{{3

  do i = 1, ndim
    ! west
    icw = ic(i) - xyzt(1)
    if ( icw>0 .and. mask_glo(icw, jc(i))==0) &
      var(i) % vac_west = .true.
    ! east
    ice = ic(i) + xyzt(1)
    if ( ice<gsize(1) .and. mask_glo(ice, jc(i))==0) &
      var(i) % vac_east = .true.
    ! north
    jcn = jc(i) + xyzt(2)
    if ( jcn<gsize(2) .and. mask_glo(ic(i), jcn)==0) &
      var(i) % vac_north = .true.
    ! south
    jcs = jc(i) - xyzt(2)
    if ( jcs>0 .and. mask_glo(ic(i), jcs)==0) &
      var(i) % vac_south = .true.
  end do

end subroutine read_infofile

subroutine read_int1d(ncname, varname, var) !{{{2
!-----------------------------------------------------------
! read variable and return, int 2d
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname, varname
  integer :: var

  call check( nf90_open(ncname, NF90_NOWRITE, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_get_var(ncid, varid, var) )

  call check( nf90_close(ncid) )
end subroutine read_int1d

subroutine read_double3d(ncname, varname, var) !{{{2
!-----------------------------------------------------------
! read variable and return, double, (t, z, y, x), t=1
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname, varname
  real (kind=dp) :: var(:,:,:)

  call check( nf90_open(ncname, nf90_nowrite, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_get_var(ncid, varid, var) )

  call check( nf90_close(ncid) )
end subroutine read_double3d

subroutine read_double2d(ncname, varname, var) !{{{2
!-----------------------------------------------------------
! read variable and return, float 1d, (z)
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname, varname
  real (kind=dp) :: var(:,:)

  call check( nf90_open(ncname, nf90_nowrite, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_get_var(ncid, varid, var) )

  call check( nf90_close(ncid) )
end subroutine read_double2d

subroutine read_scalar(ncname, varname, var) !{{{2
!-----------------------------------------------------------
! read variable and return, scalar (and (t) variable)
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname, varname
  real (kind=dp) :: var

  call check( nf90_open(ncname, NF90_NOWRITE, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_get_var(ncid, varid, var) )

  call check( nf90_close(ncid) )
end subroutine read_scalar

subroutine read_float2d(ncname, varname, var) !{{{2
!-----------------------------------------------------------
! read variable and return, float 2d, (y,x)
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname, varname
  real (kind=sp) :: var(:,:)

  call check( nf90_open(ncname, NF90_NOWRITE, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_get_var(ncid, varid, var) )

  call check( nf90_close(ncid) )
end subroutine read_float2d 

subroutine read_float1d(ncname, varname, var) !{{{2
!-----------------------------------------------------------
! read variable and return, float 1d, (z)
!-----------------------------------------------------------
  character (len=*), intent(in) :: ncname, varname
  real (kind=sp) :: var(:)

  call check( nf90_open(ncname, NF90_NOWRITE, ncid) )

  call check( nf90_inq_varid(ncid, varname, varid) )

  call check( nf90_get_var(ncid, varid, var) )

  call check( nf90_close(ncid) )
end subroutine read_float1d 

subroutine io_print_nc_info(nc) !{{{2
!-----------------------------------------------------------
! print the information of an nc file
!-----------------------------------------------------------
  type (struct_nc), intent(in) :: nc

  write(*,*) 'information of  '//trim(nc % fname)//': '

  call print_dims(nc)

  print *, ''

  call print_att(nc % cpus)
  call print_att(nc % cpu)
  call print_att(nc % dim_ids)
  call print_att(nc % size_glo)
  call print_att(nc % size_loc)
  call print_att(nc % pos_fst)
  call print_att(nc % pos_lst)
  call print_att(nc % ha_sta)
  call print_att(nc % ha_end)
  call print_att(nc % dm_type)
end subroutine io_print_nc_info 

logical function io_is_similar(nc1, nc2) !{{{2
!-----------------------------------------------------------
! check whether two files is similar (have the same dimensions and some 
!   global attributes
!-----------------------------------------------------------
  type (struct_nc), intent(in) :: nc1, nc2

  if ( nc1 % fname == nc2 % fname ) then
    write(*,*) 'WARNING: the two files have the same ncname.'
  end if

  io_is_similar = .true.
  if ( .not. (nc1 % nx == nc2 % nx .and. &
              nc1 % ny == nc2 % ny .and. &
              nc1 % nz == nc2 % nz .and. &
              nc1 % nt == nc2 % nt) ) then
    write(*,*) 'WARNING: the dimensions of this two files are not the same:'
    io_is_similar = .false.
  else if ( .not. nc1 % cpus == nc2 % cpus ) then
    write(*,*) 'WARNING: '//trim(nc1 % cpus % key)//' of this two files are not the same:'
    io_is_similar = .false.
  else if ( .not. nc1 % dim_ids == nc2 % dim_ids ) then
    write(*,*) 'WARNING: '//trim(nc1 % dim_ids % key)//' of this two files are not the same:'
    io_is_similar = .false.
  else if ( .not. nc1 % size_glo == nc2 % size_glo ) then
    write(*,*) 'WARNING: '//trim(nc1 % size_glo % key)//' of this two files are not the same:'
    io_is_similar = .false.
  else if ( .not. nc1 % size_loc == nc2 % size_loc ) then
    write(*,*) 'WARNING: '//trim(nc1 % size_loc % key)//' of this two files are not the same:'
    io_is_similar = .false.
  else if ( .not. nc1 % dm_type == nc2 % dm_type ) then
    write(*,*) 'WARNING: '//trim(nc1 % dm_type % key)//' of this two files are not the same:'
    io_is_similar = .false.
  end if

  if (.not. io_is_similar) then
    write(*,*) nc1 % fname
    write(*,*) nc2 % fname
  end if

  return
end function io_is_similar

logical function dict_equal_str(d1, d2) !{{{2
!-----------------------------------------------------------
! equal operator for global attribute of type string
!-----------------------------------------------------------
  type (dict_str), intent(in) :: d1, d2

  if ((d1 % key == d2 % key) .and. (d1 % val == d2 % val)) then
    dict_equal_str = .true.
  else
    dict_equal_str = .false.
  end if

  return
end function dict_equal_str

logical function dict_equal_int(d1, d2) !{{{2
!-----------------------------------------------------------
! equal operator for global attribute of type integer
!-----------------------------------------------------------
  type (dict_int), intent(in) :: d1, d2

  if ((d1 % key == d2 % key) .and. (d1 % val == d2 % val)) then
    dict_equal_int = .true.
  else
    dict_equal_int = .false.
  end if

  return
end function dict_equal_int

logical function dict_equal_int2(d1, d2) !{{{2
!-----------------------------------------------------------
! equal operator for global attribute of type integer, 2 elements array
!-----------------------------------------------------------
  type (dict_int2), intent(in) :: d1, d2

  if ( (d1 % key == d2 % key) .and. (d1 % val(1) == d2 % val(1)) &
       .and. (d1 % val(2) == d2 % val(2)) ) then
    dict_equal_int2 = .true.
  else
    dict_equal_int2 = .false.
  end if

  return
end function dict_equal_int2

subroutine print_dims(nc) !{{{2
!-----------------------------------------------------------
! print the dimension infomation of a file
!-----------------------------------------------------------

  type (struct_nc), intent(in) :: nc

  write(*,'(A, A, I4, A, I4, A, I4, A, I4)') 'Dimensions: ', 'nx = ', nc % nx, &
        ',  ny = ', nc % ny, ',  nz = ', nc % nz, ',  nt = ', nc % nt

end subroutine print_dims

subroutine print_att_str(dict) !{{{2
!-----------------------------------------------------------
! print the global attribute of string type
!-----------------------------------------------------------

  type (dict_str), intent(in) :: dict

  write(*,'(5A)') ':', trim(dict % key), ' = ''', trim(dict % val), ''''

end subroutine print_att_str

subroutine print_att_int(dict) !{{{2
!-----------------------------------------------------------
! print the global attribute of integer type
!-----------------------------------------------------------

  type (dict_int), intent(in) :: dict

  write(*,'(3A,I4)') ':', trim(dict % key), ' = ', dict % val

end subroutine print_att_int

subroutine print_att_int2(dict) !{{{2
!-----------------------------------------------------------
! print the global attribute of integer type, 2 elements array
!-----------------------------------------------------------
  
  type (dict_int2), intent(in) :: dict

  write(*,'(3A,I4,A,I4)') ':', trim(dict % key), ' = ', dict % val(1), ', ', dict % val(2)
  
end subroutine print_att_int2

function io_get_nc_info(ncname) !{{{2
!-----------------------------------------------------------
! get the information of the .nc files
!-----------------------------------------------------------
  character (len = *), intent(in) :: ncname
  type (struct_nc) :: nc, io_get_nc_info

  nc % cpus     % key = 'DOMAIN_number_total'
  nc % cpu      % key = 'DOMAIN_number'
  nc % dim_ids  % key = 'DOMAIN_dimensions_ids'
  nc % size_glo % key = 'DOMAIN_size_global'
  nc % size_loc % key = 'DOMAIN_size_local'
  nc % pos_fst  % key = 'DOMAIN_position_first'
  nc % pos_lst  % key = 'DOMAIN_position_last'
  nc % ha_sta   % key = 'DOMAIN_halo_size_start'
  nc % ha_end   % key = 'DOMAIN_halo_size_end'
  nc % dm_type  % key = 'DOMAIN_type'

  nc % fname = ncname

  call check( nf90_open(ncname, nf90_nowrite, ncid) )

  nc % nx = get_dim_len(ncid, 'x')
  nc % ny = get_dim_len(ncid, 'y')
  nc % nz = get_dim_len(ncid, 'z')
  nc % nt = get_dim_len(ncid, 't')

  call get_att_val(ncid, nc % dm_type)
  call get_att_val(ncid, nc % cpus)
  call get_att_val(ncid, nc % cpu)
  call get_att_val(ncid, nc % dim_ids)
  call get_att_val(ncid, nc % size_glo)
  call get_att_val(ncid, nc % size_loc)
  call get_att_val(ncid, nc % pos_fst)
  call get_att_val(ncid, nc % pos_lst)
  call get_att_val(ncid, nc % ha_sta)
  call get_att_val(ncid, nc % ha_end)

  call check( nf90_close(ncid) )

  io_get_nc_info = nc
end function io_get_nc_info

subroutine get_att_val_str(ncid, dict) !{{{2
!-----------------------------------------------------------
! get the value of a global attribute (string type) by name
!-----------------------------------------------------------
  integer, intent(in) :: ncid
  type(dict_str) :: dict

  call check( nf90_get_att(ncid, nf90_global, dict % key, dict % val) )
end subroutine get_att_val_str

subroutine get_att_val_int(ncid, dict) !{{{2
!-----------------------------------------------------------
! get the value of a global attribute (integer type) by name
!-----------------------------------------------------------
  integer, intent(in) :: ncid
  type(dict_int) :: dict

  call check( nf90_get_att(ncid, nf90_global, dict % key, dict % val) )
end subroutine get_att_val_int

subroutine get_att_val_int2(ncid, dict) !{{{2
!-----------------------------------------------------------
! get the value of a global attribute (integer type, 1d array, 2 elements) by name
!-----------------------------------------------------------
  integer, intent(in) :: ncid
  type(dict_int2) :: dict

  call check( nf90_get_att(ncid, nf90_global, dict % key, dict % val) )
end subroutine get_att_val_int2

function get_dim_len(ncid, dimname) !{{{2
!-----------------------------------------------------------
! get length of a specific dimension
! get the length of a dimension with 'dimname' from a NetCDF file with
! 'ncname'
!-----------------------------------------------------------
  integer, intent(in) :: ncid
  character (len = *), intent(in) :: dimname
  integer :: get_dim_len
  integer :: dimid, nlen

  call check( nf90_inq_dimid(ncid, dimname, dimid) )

  call check( nf90_inquire_dimension(ncid, dimid, len = nlen) )

  get_dim_len = nlen
  
  return
end function get_dim_len

subroutine check(status) !{{{2
!-----------------------------------------------------------
! check netcdf call
!-----------------------------------------------------------
  integer, intent (in) :: status

  if(status /= nf90_noerr) then 
    print *, trim(nf90_strerror(status))
    stop
  end if
end subroutine check  

end module mod_io !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
