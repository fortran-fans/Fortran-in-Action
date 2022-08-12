!> author: 左志华
!> date: 2022-08-12
module m_attr_demo

    use, intrinsic :: iso_fortran_env, only: output_unit
    use m_attr, only: attr
    implicit none
    private

    public :: error

contains

    !> Get string with error style <br>
    !> 获取带错误样式的字符串
    function error(msg) result(ans)
        character(*), intent(in) :: msg     !! error message <br>
                                            !! 错误信息
        character(:), allocatable :: ans

        if (is_a_tty(output_unit)) then
            ans = attr("<r>"//msg//"</r>")
        else
            ans = msg
        end if

    end function error

    !> Is a tty <br>
    !> 是否是 tty
    logical function is_a_tty(unit) result(atty)
#if defined __INTEL_COMPILER
        use ifport, only: isatty
#endif
        integer, intent(in) :: unit     !! Unit to check <br>
                                        !! 待检查的单元

        atty = .false.
#if defined __GFORTRAN__ || defined __INTEL_COMPILER
        atty = isatty(unit)
#endif
    end function is_a_tty

end module m_attr_demo

program main

    use m_attr_demo, only: error
    implicit none

    print *, error("Hello, World!")
    print *, "Hello, World!"

end program main
