
! Description: Global Primitive Equation Model
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2013-04-19 13:51:55 CST
! Last Change: 2013-05-14 10:44:28 CST

program main

    use basic_mod, only: nt_day, nt_hour, nt_output, nt_end, nrec_ncep
    use io_mod, only: output_field
    use integrate_mod, only: eulerback, leapfrog_average, cal_statistic, &
        init_ncep

    implicit none

    integer :: step, end_step, rec

!    end_step = nt_end
    end_step = 5*nt_output

    call initialize

!    do rec = 1, nrec_ncep
    do rec = 1, 1
        
        <|_| init_ncep>call init_ncep(rec)

        call cal_statistic; call output_field

        do step = 1, end_step

            if ( step == 1 ) then
                call eulerback
            end if

            if ( step > 1 ) then
                call leapfrog_average
            end if

            if ( mod(step, nt_output) == 0 ) then
                write(*,*) rec, "records", step,"steps",step/nt_day,' days', &
                    mod(step/nt_hour,24),' hours'
                call cal_statistic; call output_field
            end if

            call check_var

        end do
    end do

contains

    subroutine initialize

        use io_mod, only: init_io, read_ncep
        use integrate_mod, only: init_var, rh_wave

        call init_var
        call init_io
        call <$initial_field$>

    end subroutine initialize

    subroutine check_var

        use integrate_mod, only: zt, ut, vt

!        write(*,*) zt(30,30)

        if ( isnan(zt(30,30)) .or. isnan(ut(30,30)) .or. isnan(vt(30,30)) ) then
            write(*,*) "has integrated ", step, " steps."
        endif
        if ( isnan(zt(30,30)) ) stop "zt field got invalid value"
        if ( isnan(ut(30,30)) ) stop "ut field got invalid value"
        if ( isnan(vt(30,30)) ) stop "vt field got invalid value"

    end subroutine check_var

end program main
