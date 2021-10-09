# 高维数组

多维数组按列优先存储，这意味着最左边（最里面）的索引是连续的。
从实际使用角度来看，这意味着数组切片`V(:,1)`是连续的，
而切片`V(1,:)`中的元素之间的间隔是数组列的大小。
当将数组片段传递给希望处理连续数据的过程时，这一点非常重要。

根据应用程序的不同，考虑内存的位置是很重要的，
通常在多维度上执行操作时，顺序访问总是应该以大小为1的长度增加。

在下面的例子中，计算两组点之间距离的倒数。

记这些点是连续存储在数组`xyz1`/`xyz2` 中，
而最内部的循环是矩阵`a`的最左边的索引增加。

```fortran
subroutine coulomb_matrix(xyz1, xyz2, a)
  real(dp), intent(in) :: xyz1(:, :)
  real(dp), intent(in) :: xyz2(:, :)
  real(dp), intent(out) :: a(:, :)
  integer :: i, j
  do i = 1, size(a, 2)
    do j = 1, size(a, 1)
      a(j, i) = 1.0_dp/norm2(xyz1(:, j) - xyz2(:, i))
    end do
  end do
end subroutine coulomb_matrix
```

另一个例子是三维数组的第三维缩并，

```fortran
do i = 1, size(amat, 3)
  do j = 1, size(amat, 2)
    do k = 1, size(amat, 1)
      cmat(k, j) = cmat(k, j) + amat(k, j, i) * bvec(i)
    end do
  end do
end do
```

可以在数组绑定中重映射，以使用连续数组切片。
允许将高维数组用作低维数组，而不需要重新格式化数组，
这样避免了有可能创建临时数组。

例如，可以使用矩阵向量操作来缩并三维数组的第三维:

```fortran
subroutine matmul312(amat, bvec, cmat)
  real(dp), contiguous, intent(in), target :: amat(:, :, :)
  real(dp), intent(in) :: bvec(:)
  real(dp), contiguous, intent(out), target :: cmat(:, :)
  real(dp), pointer :: aptr(:, :)
  real(dp), pointer :: cptr(:)

  aptr(1:size(amat, 1)*size(amat, 2), 1:size(amat, 3)) => amat
  cptr(1:size(cmat)) => cmat

  cptr = matmul(aptr, bvec)
end subroutine matmul312
```
