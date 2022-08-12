# Fortran语言服务程序

`fortran-language-server`是一个开源的Fortran语言服务程序，它可以帮助开发者快速开发Fortran程序。
它为编辑器，如`visual studio code`，`atom`，`vim`等提供了一个强大的语言服务。

现在有两个版本的`fortls`:
- [fortls](https://github.com/gnikit/fortls): 新开发者接手维护的开箱即用的`fortls`；
- [fortran-language-server](https://github.com/hansec/fortran-language-server):
原版本`fortls`，有一段时间没有得到更新。

这里我推荐新的`fortls`，它的现在维护者是[gnikit](https://github.com/gnikit)，
他正在积极维护这个程序和`vs code`的[`Modern Fortran`](https://github.com/krvajal/vscode-fortran-support)插件💖。

## 安装和使用

详细的README文档还是得看源代码库的[README](https://github.com/gnikit/fortls#fortls---the-fortran-language-server)。
安装命令（事先得安装`python`和`pip`）是：
```sh
pip install -U fortls # 更新到最新的`fortls`
```

值得关注得是，它与`vs code`的`Modern Fortran`是很好的搭配，如今 `Modern Fortran` 已经更新至 3.2.0 版本，特点是开箱即用。
