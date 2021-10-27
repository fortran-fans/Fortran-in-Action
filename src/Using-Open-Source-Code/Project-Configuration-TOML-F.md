# 为程序设置配置文件：TOML

TOML官网：[https://toml.io/cn/](https://toml.io/cn/)<br>
TOML-F仓库（许可证：Apache License v2或者MIT License）：[https://github.com/toml-f/toml-f](https://github.com/toml-f/toml-f)

TOML（Tom的（语义）明显、（配置）最小化的语言）主要被设计为程序的配置文件，简单易用，典型地被fpm、cargo、julia作为代码包的配置文件。<br>
TOML也可被用作有限制性的、数据序列化的数据存储文件。

`toml-f`是Fortran语言的TOML解析实现，我们可以使用它作为Fortran程序的配置文件。

![toml-f](https://github.com/toml-f/toml-f/blob/main/assets/toml-f.png)

## 开始

### 软件依赖

- Git
- [fortran-lang/fpm](https://github.com/fortran-lang/fpm)

### 获取代码

可以前往`toml-f`仓库下载仓库压缩包，也可以使用Git克隆仓库。

```sh
git clone https://github.com/toml-f/toml-f.git
cd toml-f
```

### 使用[fortran-lang/fpm](https://github.com/fortran-lang/fpm)构建代码

Fortran包管理器（fpm）是Fortran-lang社区驱动、为Fortran生态设计的包管理器和代码构建器。<br>
你可以通过提供的`fpm.toml`构建代码：

```sh
fpm build
```

可以在你的fpm工程的`fpm.toml`文件中添加以下语句，以使用`toml-f`：

```toml
[dependencies]
toml-f = { git="https://github.com/toml-f/toml-f.git" }
```

## 使用`toml-f`

`toml-f`的API可以在[`https://toml-f.github.io/toml-f/`](https://toml-f.github.io/toml-f/)找到，也可以直接阅读源码，非常推荐阅读它的[单元测试源码](https://github.com/toml-f/toml-f/tree/main/test/tftest)，里面有着很全的API使用。

你可以模仿`fpm.toml`中toml的写法，或者去[TOML官网](https://toml.io/cn/)查阅toml语法。

```fortran
module tomlf
    public :: get_value, set_value
    public :: toml_parse
    public :: toml_error, toml_stat
    public :: toml_serializer
    public :: toml_table, toml_array, toml_key, is_array_of_tables, new_table, add_table, add_array, len
    public :: sort
    public :: tomlf_version_string, tomlf_version_compact, get_tomlf_version
end module tomlf
```

### 读取`toml`

在`toml-f`仓库的[README.md中](https://github.com/toml-f/toml-f#usage)提供了一个简单的示例。

#### `toml_parse`：解析`toml`

从字符串或者文件单元号读取toml信息，这是解析toml内容的第一步。

```fortran
call toml_parse(table, in [, error])
```

`table`：`toml_table`类型，`intent(out)`。
toml数组实例。

`in`：`integer`或者`character(:), allocatable`类型，`intent(in)`。
控制从文件单元号，或字符串中读取toml信息。

`error`：`toml_error`类型，`intent(out)`和`optional`。

#### `get_value`：读取变量

从toml数组中读取键的值。

```fortran
call get_value(table [, pos], ptr [, requested/default, stat])
```

`table`：`toml_table/toml_array/toml_keyval`类型，`intent(inout)`。
toml表格实例/数组指针/键值指针。

`pos`：`toml_array/toml_key/integer`类型，`intent(in)`。
toml表格中的位置。

`ptr`：`toml_table/toml_array/toml_keyval, pointer`或者`real/integer/logical/character(:), allocatable`类型，`intent(out)`。
变量的值，或者子表格的指针。

`requested`：`logical`类型，`intent(in)`和`optional`。
是否请求在toml表格中添加默认值。

`default`：`real/integer/logical/character(*)`类型，`intent(in)`。
读取toml信息时，信息不存在，预设的默认值。

`stat`：`integer`类型，`intent(out)`和`optional`。
返回`0`为成功。

#### `destory`：析构`toml`缓存

在读取完toml信息，我们**可选地**析构`toml_table`内的内容。

```fortran
call table%destory()
```

`table`：`toml_table`类型。

### 说明

我们常先学习如何使用`toml-f`解析读取toml信息，在此过程中，我们逐渐熟悉其API的使用，读者如果有输出toml的需求，很容易理解使用`toml-f`写入toml。

需要注意的有两点：

- `toml`与`json`的转换在[`toml-f`的单元测试](https://github.com/toml-f/toml-f/tree/main/test)中提供了代码。<br>
  `json-fortran`（许可证：类似BSD）：[https://github.com/jacobwilliams/json-fortran](https://github.com/jacobwilliams/json-fortran)
- 从toml文件中尝试解析不存在的键值对，`toml-f`不认为是错误，所以请读取变量的设置默认值。
- 在手动设置`.toml`内容时，注意整型和浮点型的区别，`x = 1`中`x`始终被认为是整型，`x = 1.0`中`x`才是浮点型，这点往往会被忽视。
