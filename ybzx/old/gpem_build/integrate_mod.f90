
! Description: 
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2013-04-19 16:33:23 CST
! Last Change: 2013-05-14 10:54:22 CST

module integrate_mod

    use basic_mod, only: pi, omg, a, g, &
        lat_min, lon_min, dlat, dlon, dt, nx, ny, csw, csh, f, &
        z, u, v, zf, uf, vf, zb, ub, vb, &
        grad, mean

    implicit none
    private

    public init_var, cal_statistic, eulerback, leapfrog_average, rh_wave
    public init_ncep

    public zt, ut, vt

    ! vars. <<<1

    ! field of tend
    real :: zt(nx,ny)
    real :: ut(nx,ny)
    real :: vt(nx,ny-1)

    ! for Discret Fourier Transport calculation 
    real, dimension(0:nx-1,0:nx-1) :: cn, sn

contains

    ! initialize <<<1

    subroutine init_var

        use basic_mod, only: zb, zf, ub, uf, vb, vf

        integer :: i, j

        csw = (/ ( cos(lat_min + (j-1.0)*dlat), j=1,ny   ) /)
        csh = (/ ( cos(lat_min + (j-0.5)*dlat), j=1,ny-1 ) /)

        f  = (/ ( 2*omg*sin(lat_min + (j-0.5)*dlat), j=1,ny-1 ) /)

        cn = reshape((/ ((cos(2.0*pi*i*j/nx), i=0,nx-1), j=0,nx-1) /), (/nx,nx/))
        sn = reshape((/ ((sin(2.0*pi*i*j/nx), i=0,nx-1), j=0,nx-1) /), (/nx,nx/))

        zb = 0; ub = 0; vb = 0
        zf = 0; uf = 0; vf = 0

    endsubroutine init_var

    ! RH wave <<<1
    
    ! ref. [Phillips1959]
    subroutine rh_wave

        ! value from P.47 of [Wang2005book]
        real, parameter :: lomg  = 3.924e-6
        real, parameter :: k     = 3.924e-6
        real, parameter :: r     = 4
        real, parameter :: z0    = 8000.0 * g

        real :: stream(nx,ny-1), c
        real :: c1(ny-1), c2(1,ny-1), c3(nx,1)

        real :: a1(2:ny-1)
        real, dimension(1,2:ny-1) :: a2, a3
        real, dimension(nx,1) :: b1, b2

        integer :: i, j

        ! steam function
        c1 = (/ (sin(lat_min + (j-0.5)*dlat), j=1,ny-1) /)
        c2 = reshape((/ (cos(lat_min + (j-0.5)*dlat)**r, j=1,ny-1) /), (/1,ny-1/))
        c3 = reshape((/ (cos(r*(lon_min + (i-0.5)*dlon)), i=1,nx) /), (/nx,1/))
        stream = a*a*c1*( k*matmul(c3,c2) - lomg )

        ! wind
        u = -grad(stream,'yh')/a
        v =  grad(stream,'xh')/(a*csh)

        ! potential height

        ! exclude poles
        do j = 2, ny-1
            c       = cos(lat_min+(real(j)-1.0)*dlat)
            a1(j)   = 0.5*lomg*(2*omg+lomg)*c*c + &
                0.25*k*k*(c**(2*r)) * ((r+1)*c*c + (2*r*r-r-2)-2*r*r/(c*c))
            a2(1,j) = 2*(omg+lomg)*k*(c**r) * (r*r+2*r+2-(r+1)*(r+1)*c*c) / &
                ((r+1)*(r+2))
            a3(1,j) = 0.25*k*k*(c**(2*r)) * ((r+1)*c*c-r-2)
        end do

        b1 = reshape((/ (cos(  r*(lon_min + (i-1.0)*dlon)), i=1,nx) /), (/nx,1/))
        b2 = reshape((/ (cos(2*r*(lon_min + (i-1.0)*dlon)), i=1,nx) /), (/nx,1/))

        z(:,2:ny-1) = z0 + a*a*( a1 + matmul(b1,a2) + matmul(b2,a3) )

        ! poles
        z(:,(/1,ny/)) = z0

    end subroutine rh_wave

    ! init ncep <<<1

    ! statisic ref P. 66 of [Yu2010]
    subroutine init_ncep(rec)

        use basic_mod, only: z_ncep

        ! ref. P.223 [Shen2003]
        real, parameter :: lat_c = 10*pi/180
        real :: lat, f_v(ny-1), f_u(ny), ta(nx, ny), tb(nx, ny-1)
        integer :: j, rec

        z = z_ncep(:,:,rec)

        do j = 1, ny-1
            lat = lat_min + (j-0.5)*dlat

            if ( abs(lat)<lat_c ) then
                lat = lat_c
                if (lat < 0) lat = -lat
            end if

            f_v(j) = 2*omg*sin(lat)
        end do

        do j = 1, ny
            lat = lat_min + (j-1.0)*dlat

            if ( abs(lat)<lat_c ) then
                lat = lat_c
                if (lat < 0) lat = -lat
            end if

            f_u(j) = 2*omg*sin(lat)
        end do

        tb = mean(z, 'xw', 'yw')

!        f_u = (/ ( 2*omg*sin(lat_min + (j-1.0)*dlat), j=1,ny ) /)
        u = -grad(tb, 'yh')/(a*f_u)

        v =  grad(tb, 'xh')/(a*csh*f_v)

    end subroutine init_ncep

    ! Euler back <<<1

    subroutine eulerback

        call tend(z,u,v)

        zf = z + dt*zt
        uf = u + dt*ut
        vf = v + dt*vt

        call tend(zf,uf,vf)

        zf = z + dt*zt
        uf = u + dt*ut
        vf = v + dt*vt

        zb = z
        ub = u
        vb = v

        z  = zf
        u  = uf
        v  = vf
    
    end subroutine eulerback

    ! leapfrog <<<1

    subroutine leapfrog_average

        call tend(z,u,v)

        zf = zb + 2.0*dt*zt
        uf = ub + 2.0*dt*ut
        vf = vb + 2.0*dt*vt

        zb = (zb + z)/2.0
        ub = (ub + u)/2.0
        vb = (vb + v)/2.0

        z = (z + zf)/2.0
        u = (u + uf)/2.0
        v = (v + vf)/2.0
        
        call tend(z,u,v)

        zf = zb + 2.0*dt*zt
        uf = ub + 2.0*dt*ut
        vf = vb + 2.0*dt*vt

        zb = (zb + z)/2.0
        ub = (ub + u)/2.0
        vb = (vb + v)/2.0

        z = (z + zf)/2.0
        u = (u + uf)/2.0
        v = (v + vf)/2.0

    end subroutine leapfrog_average

    ! tend field <<<1

    ! Sadourny: conservation of mass and potential vorticity

    subroutine tend(z0,u0,v0)

        real, dimension(nx,ny) :: z0, u0, flux_u, tend_ek, tend_e
        real, dimension(nx,ny-1) :: v0, flux_v, tend_vor, q

        ! cal. derive <<<2

        flux_u = mean(z0, 'xw')*u0
        flux_u(:, (/1,ny/)) = 0

        flux_v = mean(z0, 'yw')*v0

!        tend_ek = 0.5 * ( mean(u0*u0,'xh') + mean(v0*v0*csh,'yh')/csw )
        tend_ek = 0.5 * ( mean(u0*u0*csw,'xh') + mean(v0*v0*csh,'yh')/csw )
        tend_ek(:, 1) = sum(v0(:,1)*v0(:,1)) / nx
        tend_ek(:,ny) = sum(v0(:,ny-1)*v0(:,ny-1)) / nx

        tend_e = z0 + tend_ek

        tend_vor = f + ( grad(v0,'xw') - grad(u0*csw,'yw') ) / (a*mean(csw))

        q = mean(csw)*tend_vor / mean(z0*csw,'xw','yw')

        ! px/pt <<<2

        ut = -grad(tend_e,'xw')/(a*csw) + & 
            mean(q,'yh')*mean(flux_v*csh,'xw','yh')/csw
        ut(:,(/1,ny/)) = 0

        vt = -grad(tend_e, 'yw')/a - & 
            mean(q, 'xh')*mean(flux_u, 'xh', 'yw')

        zt = (grad(flux_u,'xh') + grad(flux_v*csh,'yh')) / (-a*csw)
        zt(:,1)  = -4.0*sum(flux_v(:,1   ))/(nx*a*dlat)
        zt(:,ny) =  4.0*sum(flux_v(:,ny-1))/(nx*a*dlat)

        call filter

    end subroutine tend

    ! filter <<<1

    subroutine filter

        real, parameter :: hi_lat = 70 * pi/180.0
        real :: lat
        integer :: j

        do j = 2, ny-1
            lat = lat_min + (j-1.0)*dlat
            if ( abs(lat) > hi_lat ) then
                call arakawa_dft(zt(:,j),lat)
                call arakawa_dft(ut(:,j),lat)
            end if
        end do

        do j = 1, ny-1
            lat = lat_min + (j-0.5)*dlat
            if ( abs(lat)  > hi_lat ) then
                call arakawa_dft(vt(:,j),lat)
            end if
        end do

    contains

        ! Arakawa filter
        subroutine arakawa_dft(xx, lat)

            real, dimension(0:nx-1) :: xx, fx, ak, bk
            real :: lat, mean, s
            integer :: i, k

            mean = sum(xx)/nx
            fx = xx - mean

            ! dft
            ak(0) = sum(fx)/float(nx)
            bk(0) = 0

            do k = 1, nx/2
                ak(k) = sum(xx*cn(:,k))*2.0/nx
                ak(nx-k) =  ak(k)

                bk(k) = sum(xx*sn(:,k))*2.0/nx
                bk(nx-k) = -bk(k)
            end do

            ! Arakawa factor
            do i = 1, nx/2
                s = dlon*cos(lat) / (dlat*sin(dlon*i/2.0))
                if ( abs(s) >= 1 ) cycle

                ak(i)    = ak(i)*s
                bk(i)    = bk(i)*s

                ak(nx-i) = ak(nx-i)*s
                bk(nx-i) = bk(nx-i)*s
            end do
            
            ! inverse dft
            do i = 0, nx-1
                fx(i) = sum(ak*cn(:,i) + bk*sn(:,i)) / 2.0
            end do

            xx = fx + mean

        end subroutine arakawa_dft

    end subroutine filter

    ! calculate statistics <<<1

    subroutine cal_statistic

        use basic_mod, only: total, ek, div, vor, ens, pens, pvor

        real :: ta1(nx,ny),ta2(nx,ny)
        real :: tb1(nx,ny-1),tb2(nx,ny-1)
        integer :: j

        ! total mass, ep
        total%mass = a*a*sum(csw*z)
        total%ep   = 0.5*a*a*sum(csw*z*z)

        ! kinetic energy
        ek = 0.5 * ( mean(u,'xh')*mean(u,'xh') + mean(v,'yh')*mean(v,'yh') )
        total%ek = a*a*sum(csw*ek*z)

        ! divergence
        div = ( grad(u, 'xh') + grad(v*csh, 'yh') ) / (a*csw)
        div(:,(/1, ny/)) = 0
        total%div = a*a*sum(csw*div*z)

        ! vorticity
        tb2 = f + ( grad(v, 'xw') - grad(u*csw, 'yw') ) / (a*csh)
        vor = mean(tb2, 'xh', 'yh')
        vor(:,1) = -2.0*omg
        vor(:,ny)=  2.0*omg

        ! ens, pvor, pens
        ens  = 0.5 * vor * vor
        pvor = vor/z
        pens = 0.5 * pvor * pvor

        total%vor  = a*a*sum(csw*z*vor)
        total%ens  = a*a*sum(csw*z*ens)
        total%pvor = a*a*sum(csw*z*pvor)
        total%pens = a*a*sum(csw*z*pens)

    end subroutine

end module integrate_mod
