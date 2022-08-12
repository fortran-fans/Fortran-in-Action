# Fortran 程序中的陷阱

翻译原文网址 https://www.cs.rpi.edu/~szymansk/OOF90/bugs.html

多年来，我们在Fortran 90中犯了很多有趣的错误，想和大家分享。欢迎您的贡献和经验，以便能够分享您的痛苦。
这些“陷阱”令人讨厌，因为它们在某些机器上不会失败，而在其他机器上可能会失败（考虑到编译器和机器平台的各种组合）。

## 可选参数的陷阱

在本例中，用一个可选参数来确定是否打印标题。

``` Fortran
subroutine print_char(this,header)
    character(len=*), intent (in) :: this
    logical, optional, intent (in) :: header
    ! THIS IS THE WRONG WAY
    if (present(header) .and. header) then
        print *, 'This is the header '
    endif
    print *, this
end subroutine print_char

subroutine print_char2(this,header)
    character(len=*), intent (in) :: this
    logical, optional, intent (in) :: header
    ! THIS IS THE RIGHT WAY
    if (present(header)) then
        if (header) print *, 'This is the header '
    endif
    print *, this
end subroutine print_char2
```

**解释**

第一种方法不安全，因为编译器可以在计算`present`函数之前计算`header`参数。如果`header`参数实际上不存在，可能会发生越界内存引用(`Segmentation fault - invalid memory reference.`)。


## Intent(out)的陷阱

``` fortran
program intent_gotcha
    type mytype
        integer :: x
        real,allocatable:: y
    end type mytype
    type (mytype) :: a
    a%x = 1 ; a%y = 2.
    call assign(a)
    ! a%y COULD BE UNDEFINED HERE
    print *, a%x , a%y
contains

    subroutine assign(this)
        type (mytype), intent (out) :: this
        ! THIS IS THE WRONG WAY
        this%x = 2
    end subroutine assign

    subroutine assign2(this)
        type (mytype), intent (out) :: this
        ! THIS IS THE RIGHT WAY
        this%x = 2 ; this%y = 2.
    end subroutine assign2

    subroutine assign3(this)
        type (mytype), intent (inout) :: this
        ! THIS IS THE RIGHT WAY
        this%x = 2 
    end subroutine assign3
end program intent_gotcha
```

**解释**

问题是，当`intent(out)`与派生类型一起使用时，过程中未分配的任何成员都可能在退出时变得未定义。例如，即使在进入该例程时定义了`%y`，但在退出时它可能会变得未定义，因为它从未在例程中分配过。教训是，当使用`intent(out)`时，派生类型的所有成员都应该在一个过程中指定。`Intent(out)`的行为类似于函数中的结果变量：必须分配所有成员。
或者，**使用**`intent(inout)`。

## 初始化局部变量的陷阱

``` fortran
real function kinetic_energy(v)
    real, dimension(:), intent(in) :: v
    integer i
    ! THIS IS THE WRONG WAY
    real :: ke = 0.0
    do i = 1, size(v)
        ke = ke + v(i)**2
    enddo
    kinetic_energy = .5*ke
end function kinetic_energy

real function kinetic_energy2(v)
    real, dimension(:), intent(in) :: v
    integer i
    ! THIS IS THE RIGHT WAY
    real :: ke
    ke = 0.
    do i = 1, size(v)
        ke = ke + v(i)**2
    enddo
    kinetic_energy2 = .5*ke
end function kinetic_energy2
```
**解释**

声明时初始化的局部变量具有隐式`save`属性。`ke`仅在**第一次**调用函数时初始化。在后续调用中，保留旧的`ke`值。
为了避免混淆，最好将`save`属性显式地添加到这些本地初始化的变量中，即使看起来是多余的。

## 调用Fortran 90 风格的子程序
``` fortran
program main
    real, dimension(5) :: x

    x = 0.
    ! THIS IS WRONG
    call incb(x)
    print *, x

end program main

subroutine incb(a)
    ! this is a fortran90 style subroutine
    real, dimension(:) :: a
    a = a + 1.
end subroutine incb
```

**解释**

子例程`incb`使用`Fortran 90`中的假定形状数组(包含维度(:))。此类例程必须位于模块`module`中，或者在使用它们的任何地方都有一个显式接口。

调用此类过程的一个正确方法是使用显式接口，如下所示：

``` fortran
program main
    real, dimension(5) :: x

    ! THIS IS THE RIGHT WAY
    interface
        subroutine incb(a)
        real, dimension(:) :: a
        end subroutine incb
    end interface

    x = 0.
    call incb(x)
    print *, x

end program main

subroutine incb(a)
    ! this is a fortran90 style subroutine
    real, dimension(:) :: a
    a = a + 1.
end subroutine incb
```

如果例程位于模块中，则会自动生成接口，无需显式编写。   

``` fortran
! THIS IS ANOTHER RIGHT WAY
module inc
contains
    subroutine incb(a)
        ! this is a fortran90 style subroutine
        real, dimension(:) :: a
        a = a + 1.
    end subroutine incb
end module inc

program main
    use inc
    real, dimension(5) :: x

    x = 0.
    call incb(x)
    print *, x

end program main
```
如果使用接口，接口必须与实际的函数匹配。

## Fortran77 风格的接口
``` fortran
      program main
      real, dimension(5) :: x

! interface to Fortran 77 style routine
      interface
         subroutine inca(a,n)
         integer :: n
! THIS IS THE WRONG WAY
         real, dimension(:) :: a
! THIS IS THE RIGHT WAY
         real, dimension(n) :: a
         end subroutine inca
      end interface

      x = 0.
      call inca(x,5)
      print *, x

      end program main

      subroutine inca(a,n)
! this is a fortran77 style subroutine
      dimension a(n)
      do 10 j = 1, n
      a(j) = a(j) + 1.
   10 continue
      return
      end
```

**解释**

接口声明必须始终与实际的子例程声明相匹配。在本例中，接口语句引用Fortran 90样式的假定形状数组。实际的子例程引用Fortran 77显式形状数组。这里的教训是：Fortran 77风格例程的接口必须只使用Fortran 77风格的构造。
在本例中，允许完全省略接口，因为没有接口的例程在默认情况下被视为Fortran77样式的例程。但是，如果忽略了接口，编译器将**不再检查调用过程的参数是否与接口中列出的参数一致**。

## 函数重载

Fortran 90允许对不同的函数使用相同的函数名，只要函数的参数不同。人们会认为下面的函数`first_sub`和`second_sub`是不同的，因为在`first_sub`中，第一个参数是实数，第二个参数是整数，而在`second_sub`中，参数是相反的。实际上并不是这样。
``` fortran
interface first_or_second
    module procedure first_sub, second_sub
end interface

subroutine first_sub(a,i)
    real :: a
    integer :: i
    ...
end subroutine first_sub
!
subroutine second_sub(i,a)
    integer :: i
    real :: a
    ...
end subroutine second_sub
```

**解释**

原因是Fortran 90允许按名称（关键字）参数调用过程。
``` fortran
real :: b
integer :: n
call first_or_second(i=n,a=b)
```
该方法将不起作用，因为当按关键字调用时，`first_sub`和`second_sub`无法区分，
``` fortran
call first_sub(i=n,a=b)
call second_sub(i=n,a=b)
```
因此不能定义通用函数。通用函数必须能够按类型和名称区分其参数。
解决方案是不要在两个过程中使用相同的虚参名称。例如，以下方法可行：
``` fortran
subroutine second_sub(i,aa)
    integer :: i
    real :: aa
    ...
end subroutine second_sub
```

## 可分配数组自动分配

Fortran 2003之后的标准允许对可分配数组自动分配，这个特性可能为开发者带来方便，同时也带来一些隐藏的bug

``` fortran
program alloc
    implicit none
    integer,allocatable::a(:)
    integer::b(4)
    a=[1,2]
    write(*,*)size(a)
    a=[a,3]
    write(*,*)size(a)
    a=b+1
    write(*,*)size(a)
end program alloc

```

**解释**

``` fortran
    a=[1,2]! 1,此时a数组自动分配，大小为2
    a=[a,3]! 2,此时数组自动追加元素，大小为3
    a=b+1  ! 3,此时由于b+1得到一个大小为4的数组，a会被重新分配，所以大小为4
```
在计算中，第3种情况由于重新分配数组可能带来一些bug，可以利用如下的办法解决
``` fortran
    a(:)=b+1 
```
此时，编译器会检查数组两边大小是否匹配，然后抛出错误。

## 浮点数精度的问题

Fortran中默认的类型是`real`单精度,因此对于一个常数，默认只具有单精度，即7位有效数字

``` fortran
    real(kind=8)::a
    a=1.3
    write(*,*)a
```

此时，虽然a是双精度，但是由于`1.3`只能保持单精度，所以赋值之后得到的结果为`1.29999995231628`而非`1.30000000000000`。
所以在程序中，**需要使用对应精度的常数**

``` fortran
    real(kind=8)::a
    a=1.3d0
    write(*,*)a
    a=1.3_8
    write(*,*)a
```

两者均可。

同理，在计算的时候也需要注意这一点
``` fortran
    real(kind=8)::a,b
    a=1.3d0
    b=a*1.4 !精度不足 
    write(*,*)b !1.81999996900558
    b=a*1.4d0
    write(*,*)b !1.82000000000000
```
