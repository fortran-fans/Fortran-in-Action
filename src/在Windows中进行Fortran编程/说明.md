# 在Windows系统下进行Fortran编程

该篇章将着重讲述我们在Windows下编程进行Fortran编程。

## GFortran篇

在Windows系统下，我们推荐MSYS2-GFortran，原因是MSYS2基于pacman包管理滚动更新，拥有丰富的开发工具集且使用简单，这往往适用于极客、爱好者。<br>
如果你对编程环境的稳定性需求很高，你可以前往[equation.com](http://www.equation.com/)或者[winlibs.com](https://winlibs.com/)（一些国外网站可能无法访问）下载固定版本号的Mingw-w64-GCC编程套件，
或者使用[Intel OneAPI](https://software.intel.com/content/www/us/en/develop/tools/oneapi/all-toolkits.html)套件。<br>
如果你对原生编程工具集有需求，或者Mingw环境出现了BUG，你可以试着安装[WSL2](https://docs.microsoft.com/zh-cn/windows/wsl/setup/environment)。

## Intel OneAPI篇

Intel出品的OneAPI套件，性能强劲，且已经被免费提供了。适合对高性能、稳定性有需求的用户。