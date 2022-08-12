# Fortran语言实战

[![Fortran-in-Action](https://img.shields.io/badge/Modern--in--Action-v0.1.0-blueviolet)][1]
[![MIT](https://img.shields.io/github/license/fortran-fans/Fortran-in-Action?color=pink)](LICENSE)
[![Actions Status](https://github.com/fortran-fans/Fortran-in-Action/workflows/mdbook/badge.svg)](https://fortran-fans.github.io/Fortran-in-Action/)

《Fortran语言实战》是一份由Fortran爱好者（Fortran-Fans）社区驱动的Fortran语言编程实战教程。

**呼吁：**_我们需要你们的帮助，欢迎你们为我们贡献教程，促成国内 Fortran 最新教程、信息的繁荣。_

[1]: https://github.com/fortran-fans/Fortran-in-Action

## 开始

### 软件依赖

- Git
- [Rust](https://www.rust-lang.org/zh-CN/)（可选，用于构建 MDBook）
- [mdbook](https://github.com/rust-lang/mdBook)（可选，用于构建 MDBook）

### 获取代码

```sh
git clone https://github.com/fortran-fans/Fortran-in-Action.git
cd Fortran-in-Action
```

### 使用[mdbook](https://github.com/rust-lang/mdBook)构建文档

mdBook是一个从Markdown文件创建现代在线书籍的实用程序。<br>
你可以通过提供的`book.toml`文件来构建《Fortran语言实战》。

```
mdbook build
```

如果你安装了 [scoop][1] ，则可以通过以下命令安装 mdbook：

```sh
scoop bucket add main
scoop install mdbook
```

[1]: https://scoop.sh/

## 链接

- [Fortran Best Practices](https://fortran-lang.org/learn/best_practices)<br>
  《Fortran最佳实践》是Fortran-Lang官网的mini-book，等待Fortran-Lang官网的国际化进程推进，本教程该部分内容将回馈[Fortran-Lang官网](https://github.com/fortran-lang/fortran-lang.org)。
- [rust-lang/mdBook](https://github.com/rust-lang/mdBook)