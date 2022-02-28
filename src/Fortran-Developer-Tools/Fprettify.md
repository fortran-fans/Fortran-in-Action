# 使用 Fprettify 格式化你的代码

## 简介

Fprettify 是专用于 Fortran 的代码格式化工具。使用它可以解放我们的思想，使得代码保持统一的编程风格，使我们专注于代码业务。

仓库：[https://github.com/pseewald/fprettify](https://github.com/pseewald/fprettify)

## 安装

首先我们需要先安装 Python 3 和 PIP，然后安装 Fprettify：
```sh
pip install --upgrade fprettify
```

## 使用 Fprettify

但我们写完 Fortran 代码后，我们可以通过命令行工具 Fprettify 来格式化代码：
```sh
fprettify -i 4 file.f90
```

一般很多特性都有合适的默认值，`-i`是用来指定缩进的空格数，这是我们比较个性化和常用的。

更多的命令行参数可以使用 `fprettify --help` 查看。
```sh
$ fprettify --help
usage: C:\msys64\ucrt64\bin\fprettify [-h] [-c CONFIG_FILE] [-i INDENT]
                                      [-l LINE_LENGTH] [-w {0,1,2,3,4}]
                                      [--whitespace-comma [WHITESPACE_COMMA]]
                                      [--whitespace-assignment [WHITESPACE_ASSIGNMENT]]
                                      [--whitespace-decl [WHITESPACE_DECL]]
                                      [--whitespace-relational [WHITESPACE_RELATIONAL]]
                                      [--whitespace-logical [WHITESPACE_LOGICAL]]
                                      [--whitespace-plusminus [WHITESPACE_PLUSMINUS]]
                                      [--whitespace-multdiv [WHITESPACE_MULTDIV]]
                                      [--whitespace-print [WHITESPACE_PRINT]]
                                      [--whitespace-type [WHITESPACE_TYPE]]
                                      [--whitespace-intrinsics [WHITESPACE_INTRINSICS]]
                                      [--strict-indent] [--enable-decl]
                                      [--disable-indent]
                                      [--disable-whitespace]
                                      [--enable-replacements] [--c-relations]
                                      [--case CASE CASE CASE CASE]
                                      [--strip-comments] [--disable-fypp]
                                      [--disable-indent-mod] [-d] [-s] [-S]
                                      [-r] [-e EXCLUDE] [-f FORTRAN]
                                      [--version]
                                      [path ...]

Auto-format modern Fortran source files. Config files ('.fprettify.rc') in the
home (~) directory and any such files located in parent directories of the
input file will be used. When the standard input is used, the search is
started from the current directory.

positional arguments:
  path                  Paths to files to be formatted inplace. If no paths
                        are given, stdin (-) is used by default. Path can be a
                        directory if --recursive is used. (default: ['-'])

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG_FILE, --config-file CONFIG_FILE
                        config file path (default: None)
  -i INDENT, --indent INDENT
                        relative indentation width (default: 3)
  -l LINE_LENGTH, --line-length LINE_LENGTH
                        column after which a line should end, viz. -ffree-
                        line-length-n for GCC (default: 132)
  -w {0,1,2,3,4}, --whitespace {0,1,2,3,4}
                        Presets for the amount of whitespace - 0: minimal
                        whitespace | 1: operators (except arithmetic),
                        print/read | 2: operators, print/read, plus/minus | 3:
                        operators, print/read, plus/minus, muliply/divide | 4:
                        operators, print/read, plus/minus, muliply/divide,
                        type component selector (default: 2)
  --whitespace-comma [WHITESPACE_COMMA]
                        boolean, en-/disable whitespace for comma/semicolons
                        (default: None)
  --whitespace-assignment [WHITESPACE_ASSIGNMENT]
                        boolean, en-/disable whitespace for assignments
                        (default: None)
  --whitespace-decl [WHITESPACE_DECL]
                        boolean, en-/disable whitespace for declarations
                        (requires '--enable-decl') (default: None)
  --whitespace-relational [WHITESPACE_RELATIONAL]
                        boolean, en-/disable whitespace for relational
                        operators (default: None)
  --whitespace-logical [WHITESPACE_LOGICAL]
                        boolean, en-/disable whitespace for logical operators
                        (default: None)
  --whitespace-plusminus [WHITESPACE_PLUSMINUS]
                        boolean, en-/disable whitespace for plus/minus
                        arithmetic (default: None)
  --whitespace-multdiv [WHITESPACE_MULTDIV]
                        boolean, en-/disable whitespace for multiply/divide
                        arithmetic (default: None)
  --whitespace-print [WHITESPACE_PRINT]
                        boolean, en-/disable whitespace for print/read
                        statements (default: None)
  --whitespace-type [WHITESPACE_TYPE]
                        boolean, en-/disable whitespace for select type
                        components (default: None)
  --whitespace-intrinsics [WHITESPACE_INTRINSICS]
                        boolean, en-/disable whitespace for intrinsics like
                        if/write/close (default: None)
  --strict-indent       strictly impose indentation even for nested loops
                        (default: False)
  --enable-decl         enable whitespace formatting of declarations ('::'
                        operator). (default: False)
  --disable-indent      don't impose indentation (default: False)
  --disable-whitespace  don't impose whitespace formatting (default: False)
  --enable-replacements
                        replace relational operators (e.g. '.lt.' <--> '<')
                        (default: False)
  --c-relations         C-style relational operators ('<', '<=', ...)
                        (default: False)
  --case CASE CASE CASE CASE
                        Enable letter case formatting of intrinsics by
                        specifying which of keywords, procedures/modules,
                        operators and constants (in this order) should be
                        lowercased or uppercased - 0: do nothing | 1:
                        lowercase | 2: uppercase (default: [0, 0, 0, 0])
  --strip-comments      strip whitespaces before comments (default: False)
  --disable-fypp        Disables the indentation of fypp preprocessor blocks.
                        (default: False)
  --disable-indent-mod  Disables the indentation after module / program.
                        (default: False)
  -d, --diff            Write file differences to stdout instead of formatting
                        inplace (default: False)
  -s, --stdout          Write to stdout instead of formatting inplace
                        (default: False)
  -S, --silent, --no-report-errors
                        Don't write any errors or warnings to stderr (default:
                        False)
  -r, --recursive       Recursively auto-format all Fortran files in
                        subdirectories of specified path; recognized filename
                        extensions: .f, .for, .ftn, .f90, .f95, .f03, .fpp,
                        .F, .FOR, .FTN, .F90, .F95, .F03, .FPP (default:
                        False)
  -e EXCLUDE, --exclude EXCLUDE
                        File or directory patterns to be excluded when
                        searching for Fortran files to format (default: [])
  -f FORTRAN, --fortran FORTRAN
                        Overrides default fortran extensions recognized by
                        --recursive. Repeat this option to specify more than
                        one extension. (default: [])
  --version             show program's version number and exit

Args that start with '--' (eg. -i) can also be set in a config file (specified
via -c). Config file syntax allows: key=value, flag=true, stuff=[a,b,c] (for
details, see syntax at https://goo.gl/R74nmi). If an arg is specified in more
than one place, then commandline values override config file values which
override defaults.
```

## `fprettify` / `findent`

`fprettify`的更新也不算频繁，它已经有1年没有版本更新了。
与此同时，[`findent`](https://github.com/wvermin/findent)也是Fortran代码格式化工具，它自称比`fprettify`成熟，但似乎`fprettify`更易于使用。
