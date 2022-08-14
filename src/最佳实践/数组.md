# 数组

数组是Fortran的核心对象。动态大小数组的创建在[可分配数组](./allocatable-arrays.md)中讨论.
将数组传递到过程有四种方式
1. *假定形状数组（assumed-shape arrays）* 
2. *假定维度数组（assumed-rank arrays）*
3. *显式形状数组（explicit-shape arrays）*
4. *假定大小数组（assumed-size arrays）*

将数组传递给过程的首选方法是*假定形状*数组。

```fortran
subroutine f(r)
  real(dp), intent(out) :: r(:)
  integer :: n, i
  n = size(r)
  do i = 1, n
    r(i) = 1.0_dp / i**2
  end do
end subroutine f
```

高维数组也可以以类似的方式传递。

```fortran
subroutine g(A)
  real(dp), intent(in) :: A(:, :)
  ...
end subroutine g
```

数组通过如下方式被简单地传入，

```fortran
real(dp) :: r(5)
call f(r)
```

在这种情况下没有进行数组复制。这样做的好处是数组的形状和大小信息在编译时会自动传递和检查，在运行时可以可选的检查。
类似地，数组片段传递也可以不需要使用临时数组:

```fortran
real(dp) :: r(10)
call f(r(1:10:2))
call f(r(2:10:2))
```

这应该是你在子例程中传递数组的默认方式。

避免将数组作为整片传递，因为这会模糊代码的实际意图:

```fortran
real(dp) :: r(10)
call f(r(:))
```

如果要更加通用的将数组传递给过程，可以使用Fortran 2018标准中引入的*假定维度*功能

```fortran
subroutine h(r)
  real(dp), intent(in) :: r(..)
  select rank(r)
  rank(1)
  ! ...
  rank(2)
  ! ...
  end select
end subroutine h
```

实际维度可以在运行时使用`select rank`结构来查询。 这可以很容易地创建更多的泛型函数来处理不同维度的数组。

*显式形状*数组可以用于从函数返回数据，它们的大部分功能可以由*假定形状*和*假定维数*数组完成。
但由于它经常用于与C或遗留Fortran程序的接口，因此在这里简要讨论。

要使用*显示形状*数组，数组大小必须显式地作为虚参传递，如下例所示，

``` fortran
subroutine f(n, r)
  integer, intent(in) :: n
  real(dp), intent(out) :: r(n)
  integer :: i
  do i = 1, n
    r(i) = 1.0_dp / i**2
  end do
end subroutine f
```

对于高维数组，必须传递额外的索引。

``` fortran
subroutine g(m, n, A)
  integer, intent(in) :: m, n
  real(dp), intent(in) :: A(m, n)
  ...
end subroutine g
```

可以如下方式调用，

``` fortran
real(dp) :: r(5), s(3, 4)
call f(size(r), r)
call g(size(s, 1), size(s, 2), s)
```

注意，此处没有检查形状，因此以下是可能产生错误结果的合法代码:


```fortran
real(dp) :: s(3, 4)
call g(size(s), 1, s)  ! s(12, 1) in g
call g(size(s, 2), size(s, 1), s)  ! s(4, 3) in g
```
在这种情况下，保留了内存布局，但数组的形状改变了。
此外，*显式形状*数组需要连续的内存，并且在通过非连续数组切片访问时,需要创建临时数组。

使用函数返回*显式形状*数组，

``` fortran
function f(n) result(r)
  integer, intent(in) :: n
  real(dp) :: r(n)
  integer :: i
  do i = 1, n
    r(i) = 1.0_dp / i**2
  end do
end function f
```

最后，还有*假定大小的*数组，它提供最少的编译时和运行时检查，经常可以在遗留代码中找到。
它应该避免和*假定形状*或*假定维度*数组一起使用。
一个*假定大小*数组的虚参被星号标识为最后一个维度，这将禁止许多数组内置函数的使用，如`size`或`shape`。

要检查*假定形状*数组的大小和形状是否正确，`size`和`shape`内部函数可用于查询这些属性，

```fortran
if (size(r) /= 4) error stop "Incorrect size of 'r'"
if (any(shape(r) /= [2, 2])) error stop "Incorrect shape of 'r'"
```

注意，`size`返回所有维度的总大小,要获得特定维度的形状，请将第二个参数`dim`添加到函数中。

可以使用数组构造器初始化数组

```fortran
integer :: r(5)
r = [1, 2, 3, 4, 5]
```
隐式do循环也可以在数组构造器中使用，

```fortran
integer :: i
real(dp) :: r(5)
r = [(real(i**2, dp), i = 1, size(r))]
```
数组构造器要求数组的类型是相同的,可以在开头加上类型的名称来规定
``` fortran
real(8)::a(4)
complex(8)::b(4)
!a=[1.2d0,2,3,4]!错误
a=[real(8)::1.2d0,2,3,4]!正确
b=[complex(8)::1,2,(1.d0,2.d0),1.1d0]!正确
```

要使数组不以索引1开始，请执行以下操作：

```fortran
subroutine print_eigenvalues(kappa_min, lam)
  integer, intent(in) :: kappa_min
  real(dp), intent(in) :: lam(kappa_min:)

  integer :: kappa
  do kappa = kappa_min, ubound(lam, 1)
    print *, kappa, lam(kappa)
  end do
end subroutine print_eigenvalues
```
