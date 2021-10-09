# 在Windows系统下使用GFortran

由微软公司开发的Windows系统在图形用户界面🎨上的优势，使得它成为了个人用户友好型的操作系统，被广泛使用。<br>
GCC Fortran编译器，对Fortran新标准的支持非常及时，是一款免费🍻的开源软件。

## 使用MSYS2-GFortran

> MSYS2（MinimalSYStem2）是一个MSYS的独立改写版本，主要用于shell命令行开发环境。同时它也是一个在Cygwin（POSIX兼容性层）和MinGW-w64（从"MinGW-生成"）基础上产生的，追求更好的互操作性的Windows软件。（[百度百科, MSYS2](https://baike.baidu.com/item/MSYS2/17190550)）

### 安装MSYS2软件

前往[MSYS2项目官方网站](https://www.msys2.org/)📡，点击图示箭头指向的链接，下载MSYS2软件，阅读网页提供的安装教程进行安装和使用。

<img src="images/MSYS2-Main-Page.png" alt="MSYS2主页截图" style="zoom:50%;" />

尝试阅读[MSYS2项目官方提供的文档](https://www.msys2.org/wiki/Home/)📜，将使我们在长期的编程过程中受益。<br>
当我们在使用MSYS2软件的过程中遇到困难或者软件漏洞时，我们可以向[MSYS2项目的GitHub仓库的议题](https://github.com/msys2/msys2.github.io/issues)🎯寻求帮助。

### 安装MSYS2-GFortran软件

首先，我们熟悉一下MSYS2软件的命令行基础操作🕹，这在MSYS2项目官方提供的文档中能找到：

```sh
pacman -Syu                  # 升级msys2内部组件和仓库信息
pacman -Ss <package_name>    # 搜索软件
pacman -S  <package_name>    # 安装软件
pacman -Qs <package_name>    # 查询本地安装的特定软件
pacman -Rs <package_name>    # 卸载软件
pacman -R --help             # 查询命令的帮助文档
...
```

请务必灵活🏓使用MSYS2软件，该软件在运行前有一些个性化的配置文件可以设置，当然保持默认也是不错的。<br>现在我们知道，可以通过下面的方式在MSYS2软件中安装GFortran：

```sh
pacman -Ss fortran           # 查询名字中含“Fortran”字符的包
pacman -S  ucrt64/mingw-w64-ucrt-x86_64-gcc-fortran    # 安装ucrt64版本的gfortran
```

当然，我们还可以使用MSYS2软件，下载`GNU Make/CMake/openBLAS/Python/Golang/...`等丰富的软件或者链接库。GCC WIKI为我们提供了[一些GFortran的信息文档](https://gcc.gnu.org/wiki/GFortran)，其中就有[GFortran最新的帮助文档](https://gcc.gnu.org/onlinedocs/gfortran.pdf)。

```sh
gfortran <name>.f90          # 编译fortran源代码文件
gfortran -c help             # 查询gfortran命令行参数的帮助文档
...
```

如果我们没有更改MSYS2软件的安装路径，则安装的GFortran软件应该是在`C:\msys64`路径下的特定环境的子文件下，我们最好将它引入到Windows软件的的环境路径🔗中，以方便我们使用它（gfortran.exe）。

> 🔰 这里默认我们现在大多数使用的硬件是64位的，且使用较新的MSYS2环境（UCRT），有个性化需求可以进行自定义。

## 使用Visul Studio Code编辑器进行编码

[Visual Studio Code（简称，VS Code或code）](https://code.visualstudio.com/)是一款由微软公司主导的免费、开源的代码编辑器软件。<br>如果我们是第一次使用VS Code编辑器，可以尝试阅读[VS Code帮助文档](https://code.visualstudio.com/docs)。

### 推荐的VS Code插件

针对Fortran编程，我们有一些可以方便特定编程需求的插件🛠，被列出来仅供参考：

```markdown
+ 中文软件包插件
+ Modern Fortran
+ Fortran IntelliSense
+ GDB Debugger - Beyond

---

+ VSCode Great Icons
+ Better TOML
```

### 推荐的编程样式

为了提高代码的可读性💡，可以使用以下的单元编程样式：

```fortran
!> 相加
subroutine add(x, y, z)
    
    real, intent(in)  :: x, y
    real, intent(out) :: z     !! 返回值
    
    !> 加法
    z = x + y
    
end subroutine add
```

在区块代码前使用`!>`注释标头使得VS Code的Fortran插件能解析注释；在单行注释时，有品位地使用`!>`或`!!`可以提高代码的可读性。

> `!>`注释标头被[Fortran-Lang组织](https://github.com/fortran-lang)与[社区](https://fortran-lang.discourse.group/)广泛使用。

### 使用FPM构建Fortran代码

[Fortran Package Manager（FPM）](https://github.com/fortran-lang/fpm)是Fortran-Lang组织主导、为Fortran语言专门定制开发的免费、开源的包管理器和构建系统。

我们可以选择使用MSYS2软件来安装FPM，也可以前往[Fortran Package Manager (fpm) (github.com)](https://github.com/fortran-lang/fpm)仓库手动编译出可执行程序FPM，届时务必阅读仓库提供的帮助文档`README.md`。我们最好将它引入到Windows软件的的环境路径🔗中，以方便我们使用它（fpm.exe）。

```sh
pacman -Ss fpm              # 查询名字中含“fpm”字符的包
pacman -S ucrt64/mingw-w64-ucrt-x86_64-fpm  # 安装fpm软件
```

我们来演示一个FPM项目的初始化、编写、构建、运行：

我们可以使用命令行工具（pwsh、bash）使用FPM，也可以使用VS Code打开hello_world文件夹，**此后我们就可以专心编写代码了**💻。

```sh
fpm new hello_world && cd hello_world       # 新建FPM项目并切换到文件夹下: hello_world
fpm build                   # 编译FPM项目
fpm run                     # 运行主程序🚀
fpm test --help             # 获取特定命令行参数的帮助文档
code .                      # 使用VS Code打开当前文件夹
...
```

<img src="images/hello_world-in-code.png" alt="使用VS Code编辑hello_world项目" style="zoom:75%;" />

更多关于FPM软件的使用说明，请参考[Fortran Package Manager (fpm) (github.com)](https://github.com/fortran-lang/fpm)仓库。<br>作为用户，我们可以阅读🔍[`Packaging with fpm`](https://fpm.fortran-lang.org/page/Packaging.html)和[`Manifest reference`](https://fpm.fortran-lang.org/page/Manifest.html)；如果我们想成为FPM的贡献者和开发者，阅读[FPM开发者文档](https://fpm.fortran-lang.org/index.html#fortran-package-manager-developer-documentation)将是有帮助的。

### 使用CMake构建代码

CMake是一款免费、开源、优秀的代码构建系统，它具有很强的跨平台、多编译器支持特性，功能强大同时具有一定难度。<br>我们可以通过MSYS2软件来安装CMake，我们最好将它引入到Windows软件的的环境路径🔗中，以方便我们使用它（cmake.exe）。<br>我们可以前往[CMake官方网站](https://cmake.org/)阅读[帮助文档](https://cmake.org/documentation/)。

```sh
pacman -Ss cmake            # 查询名字中含“cmake”字符的包
pacman -S  ucrt64/mingw-w64-ucrt-x86_64-cmake   # 安装CMake软件
cmake  --help               # 获取cmake命令行参数的帮助文档
```

#### 单个源文件代码

CMake使用配置文件来构建我们的代码，如`CMakelists.txt`。假设我们想构建一个“Hello Fortran”代码，在`hello_fortran.f90`同一文件夹下，我们创建一个`CMakelists.txt`：

```cmake
cmake_minimum_required(VERSION 3.0)                     # 设置要使用CMake的最小版本，此处取为3.0

project(fortran_basics LANGUAGES Fortran)               # 设置工程的名字为fortran_basics，和编译工程的编程语言为Fortran

set(CMAKE_Fortran_MODULE_DIRECTORY
    ${CMAKE_BINARY_DIR}/modules)
file(MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY})  # 设置编译器编译代码生成的*.mod文件被储存在目标构建文件夹下

add_compile_options(-Wall -Wextra)                      # 设置额外的编译器选项（命令行参数），此处为`-Wall -Wextra`

add_executable(hello_fortran.exe hello_fortran.f90)     # 设置具体的编译内容，此处设置将hello_fortran.f90编译成hello_fortran.exe
```

当我们编译代码时，CMake会生成很多具体的配置文件，所以我们最好将它们生成在一个叫做`build`的文件夹下，保持整齐的文件夹内容。

```sh
mkdir build && cd build     # 新建一个文件夹`build`，并切换到该文件夹
cmake -G "MSYS Makefiles" ..    # CMake根据命令行参数`-G "MSYS Makefiles" ..`和CMakelists.txt的信息生成makefiles
make                        # 现在我们可以使用make来编译代码了
./hello_fortran.exe         # 编译成功，我们可以运行代码了
```

<img src="images/CMake-hello_fortran.png" alt="在VS Code中使用CMake" style="zoom:75%;" />

#### 多个源代码文件

```cmake
add_executable(hello_fortran.exe 
    hello_fortran.f90
    print_stars.f90)        # 我们需要更新CMakelists.txt中具体的编译内容，增加print_stars.f90编译到hello_fortran.exe
```

<img src="images/CMake-hello_fortran2.png" alt="在VS Code中使用CMake" style="zoom:75%;" />

更多的CMake使用细节，我们需要查阅[CMake官方网站](https://cmake.org/)提供的[帮助文档](https://cmake.org/documentation/)🎯。
