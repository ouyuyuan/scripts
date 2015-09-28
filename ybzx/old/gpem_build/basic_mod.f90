
! Description: 
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2013-04-19 16:43:16 CST
! Last Change: 2013-05-14 07:15:16 CST

module basic_mod

    use math_extend_mod, only: operator(*), operator(/), operator(+)

    implicit none
    public

    interface mean
        module procedure mean_2d
        module procedure mean_1d
    end interface

    ! parameters  <<<1

    ! physical <<<2

    real, parameter :: pi  = 3.14159265  
    real, parameter :: g   = 9.8          ! acceleration of gravity
    real, parameter :: a   = 6.371e6      ! radius of the earth
    real, parameter :: omg = 7.292e-5     ! angular velocity of the earth

    ! grid <<<2

    real, parameter :: lon_min =   0 * pi/180
    real, parameter :: lon_max = 355 * pi/180
    real, parameter :: lat_min = -90 * pi/180
    real, parameter :: lat_max =  90 * pi/180

    ! resolution
    real, parameter :: dlon    =   5 * pi/180
    real, parameter :: dlat    =   5 * pi/180
    integer, parameter :: nx = 72
    integer, parameter :: ny = 37

    ! integration <<<2

    real, parameter :: dt = 300  ! time step (seconds)

    ! time length (in steps)
    integer, parameter :: nt_hour = (       1 *3600)/dt    ! one hour
    integer, parameter :: nt_day  = (      24 *3600)/dt    ! one day
    integer, parameter :: nt_end  = 300*nt_day

    ! output filed for how many time steps
    integer, parameter :: nt_output = nt_day

    ! variables <<<1

    ! grid  <<<2

    !    var. distribution in staggered C grid:
    !    z   u   z
    !    v   f   v
    !    z   u   z

    ! potential height of the free surface
    real, dimension(nx,ny) :: z, zb, zf

    ! eastward component of wind velocity
    real, dimension(nx,ny) :: u, ub, uf

    ! northward component of wind velocity
    real, dimension(nx,ny-1) :: v, vb, vf

    ! cosine(latitude) for whole/half grid
    real :: csw(ny)      
    real :: csh(ny-1)

    ! Coriolis parameter in half latitude
    real ::  f(ny-1)          
    
    ! ncep input potential height (one year)
    integer, parameter :: nrec_ncep = 365*4
    real :: z_ncep(nx, ny, nrec_ncep)

    ! statistical, field derived <<<2

    ! total mass, kinetic energy, potential energy, divergence, vorticity,
    ! enstrophy, potential vorticity, potential enstrophy
    type :: total_scalar
        real :: mass, ek, ep, div, vor, ens, pvor, pens
    end type total_scalar
    type(total_scalar) :: total

    ! fields in A grid:
    ! kinetic energy, divergence, voricity, enstrophy, potential vor., pot. ens.
    real, dimension(nx,ny), target :: ek, div, vor, ens, pvor, pens

contains

    ! gradient, mean <<<1

    ! attr: x/y-directin, whole/half grid in that direction: 
    ! xw, xh, yw, yh

    subroutine grad_mean(fin, attr, fout, k, dx, dy)

        real, intent(in) :: fin(:,:), dx, dy
        character(len=*), intent(in) :: attr
        integer, intent(in) :: k

        real, allocatable, intent(out) :: fout(:,:)
        real, allocatable :: ta(:,:)

        integer :: dim1, dim2, i, j

        dim1 = size(fin,1)
        dim2 = size(fin,2)

        ! zonal <<<2

        ! note that the grid wrap around zonally
        ! (:,j) = (:,j) - (:,j-1)

        if ( (attr == 'xw') .or. (attr == 'xh') ) then
            allocate( ta(dim1, dim2) )
            allocate( fout(dim1, dim2) )

            do i = 1, dim1 - 1
                ta(i,:) = ( fin(i+1,:) + k*fin(i,:) ) / dx
            end do
            ta(dim1,:) = ( fin(1,:) + k*fin(dim1,:) ) / dx

            if ( attr == 'xw' ) then
                fout = ta
            else
                ! cshift(xx,-1,2) if dim1 is latitude
                fout = cshift(ta,-1,1)  
            end if

        ! longitudinal <<<2

        else if ( (attr == 'yw') .or. (attr == 'yh') ) then
            allocate( ta(dim1, dim2-1) )

            do j = 1, dim2 - 1
                ta(:,j) = ( fin(:,j+1) + k*fin(:,j) ) / dy
            end do

            if (attr == 'yw') then
                allocate( fout(dim1, dim2-1) )
                fout = ta
            else
                allocate( fout(dim1, dim2+1) )
                fout(:, 2:dim2) = ta
                fout(:, (/1,dim2+1/)) = 0
            end if

        else
            stop  "wrong attribute in gradient or mean calculation"
        end if

    end subroutine grad_mean

    ! gradient  <<<2

    function grad(fin, attr1, attr2)

        real, intent(in) :: fin(:,:)
        character(len=*), intent(in) :: attr1
        character(len=*), intent(in), optional :: attr2
        real, allocatable :: grad(:,:), ta(:,:)

        if ( present(attr2) ) then
            call grad_mean(fin, attr1, ta, -1, dlon, dlat)
            call grad_mean(ta, attr1, grad, -1, dlon, dlat)

        else
            call grad_mean(fin, attr1, grad, -1, dlon, dlat)
        end if

    end function grad

    ! mean <<<2

    function mean_2d(fin, attr1, attr2)

        real, intent(in) :: fin(:,:)
        character(len=*), intent(in) :: attr1
        character(len=*), intent(in), optional :: attr2
        real, allocatable :: mean_2d(:,:), ta(:,:)

        ! interpolate to diagonal
        if ( present(attr2) ) then
            call grad_mean(fin, attr1, ta, 1, 2.0, 2.0)
            call grad_mean(ta, attr2, mean_2d, 1, 2.0, 2.0)

        ! interpolate to midpoint
        else
            call grad_mean(fin, attr1, mean_2d, 1, 2.0, 2.0)
        end if

    end function mean_2d

    function mean_1d(fin)

        real, intent(in) :: fin(:)
        real, allocatable :: mean_1d(:)
        integer :: d, i

        d = size(fin)

        if ( d == ny ) then
            allocate(mean_1d(d-1))
        else if ( d == ny -1 ) then
            allocate(mean_1d(0:d))
            mean_1d((/0,d/)) = 0
        else
            stop "unrecognized dimension in mean 1d calculation."
        end if

        do i = 1, d - 1
            mean_1d(i) = 0.5 * ( fin(i) + fin(i+1) )
        end do

    end function mean_1d

end module basic_mod
