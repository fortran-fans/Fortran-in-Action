# 模块和程序

模块（`module`）是创建现代Fortran库和应用程序的首选方法。
按照惯例，一个源文件应始终只包含一个模块，而模块名称应与文件路径匹配，以便在较大的项目中可以轻松浏览。
此外还建议在模块名前加上库名，以避免在其他项目中作为依赖项使用时发生名称冲突。
这里给出了一个模块文件的示例，

``` fortran
!> Interface to TOML processing library.
!>
!> ...
module fpm_toml
  use fpm_error, only : error_t, fatal_error, file_not_found_error
  use fpm_strings, only : string_t
  use tomlf, only : toml_table, toml_array, toml_key, toml_stat, get_value, &
    & set_value, toml_parse, toml_error, new_table, add_table, add_array, &
    & toml_serializer, len
  implicit none
  private

  public :: read_package_file
  public :: toml_table, toml_array, toml_key, toml_stat, get_value, set_value
  public :: new_table, add_table, add_array, len
  public :: toml_error, toml_serializer, toml_parse

contains

  !> Process the configuration file to a TOML data structure
  subroutine read_package_file(table, manifest, error)
    !> TOML data structure
    type(toml_table), allocatable, intent(out) :: table
    !> Name of the package configuration file
    character(len=*), intent(in) :: manifest
    !> Error status of the operation
    type(error_t), allocatable, intent(out) :: error
    ! ...
  end subroutine read_package_file

end module fpm_toml
```

本示例模块中有几点需要强调。
首先，每个模块都以注释开始，记录模块的目的和内容。
类似的，每个过程都以一条注释开始，简要描述其目的和虚参的意义。
无论使用何种语言，文档都是创建长期软件的最重要部分之一。

其次，显式地导入`use`和导出`public`，通过浏览模块的源代码来检查已经使用的和可用的过程、常量和派生类型。
导入通常应限于模块范围，而不是在每个过程或接口范围中重新导入。
类似的，通过在一行上添加`private`语句并在`public`语句中显式列出所有导出符号，可以显式地进行导出。

最后，`implicit none`语句在整个模块生效，不需要在每个过程中重复使用它。


模块中的变量是静态的（*默认save属性*）。
强烈建议将模块变量的使用限制为常量表达式，比如只使用常数或枚举对象，或者将它们导出设置为`protected`而不是`public`。

在Fortran程序中，子模块（`submodule`）可以用来打破长依赖链，缩短重新编译的时间。
它们使得我们在不使用预处理器的情况下，提供专用化和经过优化的程序实现。

如下示例是Fortran标准库[stdlib](https://github.com/fortran-lang/stdlib)中的积分模块，
此处只定义了模块过程的接口，而没有实现。

```fortran
!> Numerical integration
!>
!> ...
module stdlib_quadrature
  use stdlib_kinds, only: sp, dp, qp
  implicit none
  private

  public :: trapz
  ! ...

  !> Integrates sampled values using trapezoidal rule
  interface trapz
    pure module function trapz_dx_dp(y, dx) result(integral)
      real(dp), intent(in) :: y(:)
      real(dp), intent(in) :: dx
      real(dp) :: integral
    end function trapz_dx_dp
    module function trapz_x_dp(y, x) result(integral)
      real(dp), intent(in) :: y(:)
      real(dp), intent(in) :: x(:)
      real(dp) :: integral
    end function trapz_x_dp
  end interface trapz

  ! ...
end module stdlib_quadrature
```

具体实现是在单独的子模块中提供的，比如这里给出的梯形积分规则。

```fortran
!> Actual implementation of the trapezoidal integration rule
!>
!> ...
submodule (stdlib_quadrature) stdlib_quadrature_trapz
  use stdlib_error, only: check
  implicit none

contains

  pure module function trapz_dx_dp(y, dx) result(integral)
    real(dp), intent(in) :: y(:)
    real(dp), intent(in) :: dx
    real(dp) :: integral
    integer :: n

    n = size(y)
    select case (n)
    case (0:1)
      integral = 0.0_dp
    case (2)
      integral = 0.5_dp*dx*(y(1) + y(2))
    case default
      integral = dx*(sum(y(2:n-1)) + 0.5_dp*(y(1) + y(n)))
    end select
  end function trapz_dx_dp

  ! ...
end submodule stdlib_quadrature_trapz
```

请注意，模块过程不必在同一个子模块中实现，可以使用多个子模块来减少大型模块的编译负载。

最后，在构建程序时，推荐尽可能少地在程序主体内留下最终的实现。而通过从模块中复用代码实现，能使你写出可被复用的代码，并专注于将用户输入传递到库函数和库对象的程序单元。
