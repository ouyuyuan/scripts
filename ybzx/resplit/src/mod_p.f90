
! Description: common procedures
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2015-03-06 10:38:13 BJT
! Last Change: 2015-06-02 15:20:26 BJT

module mod_p

  use mod_type, only: struct_nc
  implicit none
  public

contains !{{{1
!-------------------------------------------------------{{{1
subroutine p_check_alloc( istat ) !{{{2
!-----------------------------------------------------------
! check allocate success or not
!-----------------------------------------------------------

  integer, intent(in) :: istat

  if ( istat /= 0 ) then
    stop 'Allocate array failed! Stop.'
  end if

end subroutine p_check_alloc

subroutine p_print_domain_info(nc) !{{{2
!-----------------------------------------------------------
! print the information of an nc file
!   assume the index starting a 0
!-----------------------------------------------------------
  type (struct_nc), intent(in) :: nc(:)
  integer :: nfile, i

  nfile = size(nc)

  do i = 1, nfile
    write(*,'(A, I4, A, 4(A,I4,A,I4,A))') 'cpu: ', nc(i) % cpu % val, '; ', &
    ' pos_fst:(', nc(i) % pos_fst % val(1), ',', nc(i) % pos_fst % val(2), ');', &
    ' pos_lst:(', nc(i) % pos_lst % val(1), ',', nc(i) % pos_lst % val(2), ');', &
     ' ha_sta:(', nc(i) %  ha_sta % val(1), ',', nc(i) %  ha_sta % val(2), ');', &
     ' ha_end:(', nc(i) %  ha_end % val(1), ',', nc(i) %  ha_end % val(2), ');'
  end do
end subroutine p_print_domain_info 

end module mod_p !{{{1
!-------------------------------------------------------{{{1
! vim:fdm=marker:fdl=0:
! vim:foldtext=getline(v\:foldstart).'...'.(v\:foldend-v\:foldstart):
