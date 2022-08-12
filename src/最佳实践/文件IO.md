# 文件io

在Fortran中，文件由`unit`单元标识符管理。
与文件系统的交互主要通过`open`和`inquire`内置过程进行。
通常，工作流是打开一个文件到一个单元标识符，读和（或）写，然后再关闭它。

```fortran
integer :: io
open(newunit=io, file="log.txt")
! ...
close(io)
```

默认情况下，如果文件还不存在，并且为同时具有读和写操作的文件，
那么将会创建该文件。
写入现有文件将从第一个记录（即第一行）开始，因此默认情况下会覆盖文件。

要对文件的进行只读访问，必须指定`status`和`action`，

```fortran
integer :: io
open(newunit=io, file="log.txt", status="old", action="read")
read(io, *) a, b
close(io)
```

如果文件不存在，则会发生运行时错误。
要在打开文件之前检查文件是否存在，可以使用 `inquire`函数。

```fortran
logical :: exists
inquire(file="log.txt", exist=exists)
if (exists) then
  ! ...
end if
```

或者，使用`open`过程可以返回一个可选的*iostat*和*iomsg*:

```fortran
integer :: io, stat
character(len=512) :: msg
open(newunit=io, file="log.txt", status="old", action="read", &
  iostat=stat, iomsg=msg)
if (stat /= 0) then
  print *, trim(msg)
end if
```
注意，*iomsg*需要一个固定长度的字符变量，它应当有足够的长度来保存错误信息。

类似地，使用*status*和*action*关键字创建一个写入文件。
如下创建一个新的写入文件，

```fortran
integer :: io
open(newunit=io, file="log.txt", status="new", action="write")
write(io, *) a, b
close(io)
```

`status="replace"`可以用于覆盖现有文件。
强烈建议在使用*status*之前，首先检查文件是否存在。

要追加到输出文件，可以显式指定*position*关键字，

```fortran
integer :: io
open(newunit=io, file="log.txt", position="append", &
  & status="old", action="write")
write(io, *) size(v)
write(io, *) v(:)
close(io)
```

要重置文件中的位置，可以使用内置过程`rewind`和`backspace`。
`rewind`将重置为第一个记录（行），而`backspace`将返回到前一个记录（行）。

最后，要删除文件，文件必须要打开，并可以在关闭后删除。

```fortran
logical :: exists
integer :: io, stat
inquire(file="log.txt", exist=exists)
if (exists) then
  open(file="log.txt", newunit=io, iostat=stat)
  if (stat == 0) close(io, status="delete", iostat=stat)
end if
```

一个有用的IO功能是暂存文件，它可以用`status="scratch"`打开。 
关闭单元标识符后，它将自动删除。


