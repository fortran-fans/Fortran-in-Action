# 回调函数

回调函数是作为参数传递给另一个函数的函数。
创建此类回调函数的首选方法是提供*抽象接口*（abstract interface）声明回调函数的特征。
这样可以对传递的回调函数进行编译时检查。

```fortran
module integrals
  use types, only: dp
  implicit none
  private
  public :: simpson, integrable_function

  abstract interface
    function integrable_function(x) result(func)
      import :: dp
      real(dp), intent(in) :: x
      real(dp) :: func
    end function integrable_function
  end interface

contains

  function simpson(f, a, b) result(s)
    real(dp), intent(in) :: a, b
    procedure(integrable_function) :: f
    real(dp) :: s

    s = (b-a) / 6 * (f(a) + 4*f((a+b)/2) + f(b))
  end function simpson

end module integrals
```

然后，通过导入模块，该函数将作为回调函数使用，如下例所示，

```fortran
module demo_functions
  use types, only: dp
  implicit none
  private
  public :: test_integral

contains

  subroutine test_integral(a, k)
    real(dp), intent(in) :: a, k

    print *, simpson(f, 0._dp, pi)
    print *, simpson(f, 0._dp, 2*pi)
  contains

    function f(x) result(y)
      real(dp), intent(in) :: x
      real(dp) :: y
      y = a*sin(k*x)
    end function f
  end subroutine test_integral

end module demo_functions
```

如果导出抽象接口,可以创建具有正确特征的过程指针，
还可以进一步扩展回调函数，如下所示，

```fortran
module demo_integrals
  use types, only: dp
  use integrals, only: simpson, integrable_function
  implicit none
  private
  public :: simpson2, integrable_function

contains

  function simpson2(f, a, b) result(s)
    real(dp), intent(in) :: a, b
    procedure(integrable_function) :: f
    real(dp) :: s
    real(dp) :: mid
    mid = (a + b)/2
    s = simpson(f, a, mid) + simpson(f, mid, b)
  end function simpson2

end module demo_integrals
```
