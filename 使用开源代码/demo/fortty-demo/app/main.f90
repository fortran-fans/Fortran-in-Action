!> author: 左志华
!> date: 2022-08-12
module m_attr_demo

    use fortty_escape, only: red, reset, operator(//)
    use fortty_util, only: is_stdout_a_tty
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

        if (is_stdout_a_tty()) then
            ans = red//msg//reset
        else
            ans = msg
        end if

    end function error

end module m_attr_demo

program main

    use fortty_util, only: is_stdout_a_tty
    use m_attr_demo, only: error
    implicit none

    print *, error("Hello, World!")
    print *, "Hello, World!"

end program main
