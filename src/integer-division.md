# 整数除法

Fortran区分浮点运算和整数运算。需要注意的是，整数除法总是使用整数算术。
此外，虽然Fortran使用标准的运算顺序（例如，在没有括号的情况下，乘除法优先级高于加减法），
但相同优先级的运算是从左到右计算的。
如下，考虑一个奇数做整数除法的例子。

```fortran
integer :: n
n = 3
print *, n / 2  ! prints 1
print *, n*(n + 1)/2  ! prints 6
print *, n/2*(n + 1)  ! prints 4 (left-to-right evaluation order)
n = -3
print *, n / 2  ! prints -1
```

在实际情况中，请注意你是否真的需要使用整数算术。
如果要改用浮点算术，请确保在使用除法运算符之前强制转换为实数，或通过乘以`1.0_dp`来分隔整数。

```fortran
integer :: n
n = 3
print *, real(n, dp) / 2  ! prints 1.5
print *, n * 1.0_dp / 2  ! prints 1.5
n = -3
print *, real(n, dp) / 2  ! prints -1.5
print *, n * 1.0_dp / 2  ! prints -1.5
```
