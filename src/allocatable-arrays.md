# 可分配数组

`allocatable`属性为内存处理提供了安全的方式，
与具有`pointer`属性的变量相比，其内存是自动管理的，
一旦变量超出作用域，内存就会自动释放。 
使用`allocatable`变量可以消除在应用程序中产生内存泄漏的可能性。

可分配数组可以在子例程中用于创建临时或工作数组，
，而自动数组可能会由于所需空间太大不能放在栈中。

```fortran
real(dp), allocatable :: temp(:)
allocate(temp(10))
```

分配状态可以使用`allocated`来检查，以避免未初始化的访问。

```fortran
subroutine show_arr(arr)
  integer, allocatable, intent(in) :: arr(:)

  if (allocated(arr)) then
    print *, arr
  end if
end subroutine show_arr
```

要在一个过程中传递使用可分配变量，虚参必须带有`allocatable`属性。
如果与`intent(out)`结合使用，那么数组会在进入这个过程之前释放。

```fortran
subroutine foo(lam)
  real(dp), allocatable, intent(out) :: lam(:)
  allocate(lam(5))
end subroutine foo
```

分配之后的数组可以像普通数组一样使用，

```fortran
real(dp), allocatable :: lam(:)
call foo(lam)
```

已经分配的数组在没有事先释放的情况下不能再次进行分配。
同样，只能对已分配的数组进行释放。 重新分配数组使用如下操作，

```fortran
if (allocated(lam)) deallocate(lam)
allocate(lam(10))
```

将已分配的数组传递给过程虚参不需要`allocatable`属性。

```fortran
subroutine show_arr(arr)
  integer, intent(in) :: arr(:)

  print *, arr
end subroutine show_arr

subroutine proc
  integer :: i
  integer, allocatable :: arr(:)

  allocate(arr(5))

  do i = 1, size(arr)
    arr(i) = 2*i + 1
  end do
  call show_arr(arr)
end subroutine proc
```

在程序中传递未分配的数组将导致无效的内存访问。
可分配数组可以传递给带`optional`属性的虚参----如果它们未被分配，
则此参数实际上将不存在。
`allocatable`属性不仅限于数组，还可以与标量关联，
它可以与带`optional`属性的虚参结合使用。

使用`move_alloc`内部子程序，可以在带有`allocatable`属性的数组之间移动分配属性。

```fortran
subroutine resize(var, n)
  real(wp), allocatable, intent(inout) :: var(:)
  integer, intent(in), optional :: n
  integer :: this_size, new_size
  integer, parameter :: inital_size = 16

  if (allocated(var)) then
    this_size = size(var, 1)
    call move_alloc(var, tmp)
  else
    this_size = initial_size
  end if

  if (present(n)) then
    new_size = n
  else
    new_size = this_size + this_size/2 + 1
  end if

  allocate(var(new_size))

  if (allocated(tmp)) then
    this_size = min(size(tmp, 1), size(var, 1))
    var(:this_size) = tmp(:this_size)
  end if
end subroutine resize
```

最后，分配不会不初始化数组的值。
未初始化数组的内容很可能只是之前在相应地址处的任何内容的字节。
分配时可以使用source进行初始化，

```fortran
real(dp), allocatable :: arr(:)
allocate(arr(10), source=0.0_dp)
```
`source`关键字支持标量，数组变量和常量。


