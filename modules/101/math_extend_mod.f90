
! Description: math extention, operator overload, matrix fuctions, etc
!
!      Author: OU Yuyuan <ouyuyuan@lasg.iap.ac.cn>
!     Created: 2013-03-14 09:54:02 CST
! Last Change: 2013-04-23 14:36:40 CST

module math_extend_mod

    implicit none
    private

    public operator(*), operator(/), operator(+), operator(-)

    interface operator(*)
        module procedure vec_mul_mat
        module procedure mat_mul_vec
    end interface

    interface operator(/)
        module procedure vec_div_mat
        module procedure mat_div_vec
    end interface

    interface operator(+)
        module procedure vec_add_mat
        module procedure mat_add_vec
    end interface

    interface operator(-)
        module procedure vec_sub_mat
        module procedure mat_sub_vec
    end interface

contains

    ! vector meets matrix <<<1

    subroutine vector_meet_matrix(vec, mat, oper, answer)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        character(len=*), intent(in) :: oper
        real, allocatable :: answer(:,:)
        integer :: dim1, dim2, dim_vec, i, j

        dim1 = size(mat,1)
        dim2 = size(mat,2)
        dim_vec = size(vec)

        if ( dim1 == dim2 ) & 
            stop "Unable to continue when vector meets matrix: square matrix."
        if ( (dim_vec /= dim1) .and. (dim_vec /= dim2) ) &
            stop "Unable to continue when vector meets matrix: unmatched dimension."

        allocate( answer(dim1, dim2) )

        if ( oper == '*' ) then
            if ( dim_vec == dim1 ) then
                do i = 1, dim1 
                    answer(i,:) = vec(i) * mat(i,:)
                end do
            else
                do j = 1, dim2 
                    answer(:,j) = vec(j) * mat(:,j)
                end do
            end if

        else if ( oper == '+' ) then
            if ( dim_vec == dim1 ) then
                do i = 1, dim1 
                    answer(i,:) = vec(i) + mat(i,:)
                end do
            else
                do j = 1, dim2 
                    answer(:,j) = vec(j) + mat(:,j)
                end do
            end if

        else
            stop "Unkown operator when vector meets matrix."
        end if

    end subroutine vector_meet_matrix

    ! vector * matrix <<<1

    function vec_mul_mat(vec, mat)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: vec_mul_mat(:,:)

        call vector_meet_matrix(vec, mat, '*', vec_mul_mat)

    end function vec_mul_mat

    ! matrix * vector <<<1

    function mat_mul_vec(mat, vec)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: mat_mul_vec(:,:)

        call vector_meet_matrix(vec, mat, '*', mat_mul_vec)

    end function mat_mul_vec

    ! vecotr + matrix <<<1

    function vec_add_mat(vec, mat)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: vec_add_mat(:,:)
        integer :: dim1, dim2, i, j

        call vector_meet_matrix(vec, mat, '+', vec_add_mat)

    end function vec_add_mat

    ! matrix + vector <<<1

    function mat_add_vec(mat, vec)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: mat_add_vec(:,:)
        integer :: dim1, dim2

        call vector_meet_matrix(vec, mat, '+', mat_add_vec)

    end function mat_add_vec

    ! vector / matrix <<<1

    function vec_div_mat(vec, mat)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: vec_div_mat(:,:)

        call vector_meet_matrix(vec, 1/mat, '*', vec_div_mat)

    end function vec_div_mat

    ! matrix / vector <<<1

    function mat_div_vec(mat, vec)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: mat_div_vec(:,:)

        call vector_meet_matrix(1/vec, mat, '*', mat_div_vec)

    end function mat_div_vec

    ! vecotr - matrix <<<1

    function vec_sub_mat(vec, mat)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: vec_sub_mat(:,:)
        integer :: dim1, dim2, i, j

        call vector_meet_matrix(vec, -mat, '+', vec_sub_mat)

    end function vec_sub_mat

    ! matrix - vector <<<1

    function mat_sub_vec(mat, vec)

        real, intent(in) :: vec(:)
        real, intent(in) :: mat(:,:)
        real, allocatable :: mat_sub_vec(:,:)
        integer :: dim1, dim2

        call vector_meet_matrix(-vec, mat, '+', mat_sub_vec)

    end function mat_sub_vec

end module math_extend_mod
