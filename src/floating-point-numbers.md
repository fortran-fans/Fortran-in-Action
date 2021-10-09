# 浮点数

浮点数的默认表示形式是使用单精度（通常为32位/4字节）。对于大多数程序而言，需要更高的精度。
为此，可以自定义种类参数。定义种类参数的方法推荐使用，

```fortran
integer, parameter :: dp = selected_real_kind(15)
```

也可以直接如下面这样推断种类参数，

```fortran
integer, parameter :: dp = kind(0.0d0)
```

或将`iso_fortran_env`内置模块中导入的种类参数重命名，

```fortran
use, intrinsic :: iso_fortran_env, only : dp => real64
```

有关种类参数的一些深刻的见解，请看
<a href="https://web.archive.org/web/20200930090137/https://stevelionel.com/drfortran/2017/03/27/doctor-fortran-in-it-takes-all-kinds/">Doctor Fortran in it takes all KINDs</a>.

建议有一个核心模块来定义种类参数，并在必要时包括它们。
在此，给出此类模块的示例，

``` fortran
!> Numerical storage size parameters for real and integer values
module kind_parameter
   implicit none
   public

   !> Single precision real numbers, 6 digits, range 10⁻³⁷ to 10³⁷-1; 32 bits
   integer, parameter :: sp = selected_real_kind(6, 37)
   !> Double precision real numbers, 15 digits, range 10⁻³⁰⁷ to 10³⁰⁷-1; 64 bits
   integer, parameter :: dp = selected_real_kind(15, 307)
   !> Quadruple precision real numbers, 33 digits, range 10⁻⁴⁹³¹ to 10⁴⁹³¹-1; 128 bits
   integer, parameter :: qp = selected_real_kind(33, 4931)

   !> Char length for integers, range -2⁷ to 2⁷-1; 8 bits
   integer, parameter :: i1 = selected_int_kind(2)
   !> Short length for integers, range -2¹⁵ to 2¹⁵-1; 16 bits
   integer, parameter :: i2 = selected_int_kind(4)
   !> Length of default integers, range -2³¹ to 2³¹-1; 32 bits
   integer, parameter :: i4 = selected_int_kind(9)
   !> Long length for integers, range -2⁶³ to 2⁶³-1; 64 bits
   integer, parameter :: i8 = selected_int_kind(18)

end module kind_parameter
```

声明浮点常量，应始终包括种类参数后缀，

```fortran
real(dp) :: a, b, c
a = 1.0_dp
b = 3.5_dp
c = 1.34e8_dp
```

将整数赋值给浮点数(不超过有效数字限制的整数)是安全的，不会丢失精度。

```fortran
real(dp) :: a
a = 3
```

为了强制使用浮点除法，
（与整数除法`3/4==0`不同），
可以通过以下方式将整数转换为浮点数，

```fortran
real(dp) :: a
a = real(3, dp) / 4  ! 'a' is equal to 0.75_dp
```

或者简单的用乘以`1.0_dp`的乘法分隔整数除法。

要在不丢失精度的情况下打印浮点数，使用无格式描述符`"(g0)"`或指数表示法`"(es24.16e3)"`，会提供17位有效数字的打印输出。
