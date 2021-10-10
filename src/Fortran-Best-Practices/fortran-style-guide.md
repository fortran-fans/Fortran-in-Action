# Fortran风格指导
## 命名规则
虽然如何命名取决于个人偏好，但是我们在这里给出一份我们喜欢的，并且在很多科学计算代码（以及Fortran standard library）中流行的风格。欢迎你也使用这一风格。
1. 在所有Fortran结构中使用小写字母（`do`、`subroutine`、`module`……）
2. 对于数学变量/函数使用简短的数学上的记号（`Ylm`、`Gamma`、`gamma`、`Enl`、`Rnl`……）
3. 其他的名字全部都用小写字母：尽量让名字为一到两个音节；如果需要更多音节，则用下划线使其看着清晰（`sortpair`、`whitechar`、`meshexp`、`numstrings`、`linspace`、`meshgrid`、`argsort`、`spline`、`spline_interp`、`spline_interpolate`、`stoperr`、`stop_error`、`meshexp_der`）

