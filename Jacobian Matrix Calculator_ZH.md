# Jacobian 矩阵计算器 — 函数文档

### 概述

`Jacobi_solve` 是一个 MATLAB 函数，用于计算方程组的**符号 Jacobian 矩阵**，并支持在指定点处进行数值求解。函数自动提取符号变量，完成符号微分，并可选择性地代入特定点返回数值结果。

------

### 文件结构

该 `.m` 文件包含三个函数：

| 函数名         | 功能                                               |
| -------------- | -------------------------------------------------- |
| `Jacobi_solve` | 主函数 —— 计算符号 Jacobian 矩阵，可选数值求值     |
| `fx`           | 辅助函数 —— 将字符串表达式转换为符号函数句柄       |
| `Jx`           | 辅助函数 —— 将指定点代入 Jacobian 矩阵进行数值计算 |

------

### 函数：`Jacobi_solve`

#### 调用语法

```matlab
[J, Jf, var] = Jacobi_solve(f, varargin)
```

#### 功能说明

计算输入方程组 `f` 的符号 Jacobian 矩阵。输出矩阵的每一列对应关于一个符号变量的偏导数。

#### 输入参数

| 参数       | 类型                        | 说明                                      |
| ---------- | --------------------------- | ----------------------------------------- |
| `f`        | 字符串元胞数组或 `sym` 类型 | 方程组，例如 `{'sin(x)', 'x*y'}`          |
| `varargin` | 数值向量（可选）            | 要代入 Jacobian 进行数值计算的坐标点 `x0` |

#### 输出参数

| 参数          | 类型           | 说明                                     |
| ------------- | -------------- | ---------------------------------------- |
| `J`           | `sym` 矩阵     | 符号 Jacobian 矩阵                       |
| `Jf`          | 函数句柄       | Jacobian 矩阵的 MATLAB 函数句柄形式      |
| `var`         | 字符串元胞数组 | 符号变量名称列表                         |
| `varargin{4}` | 数值矩阵       | （可选）在 `x0` 处数值化的 Jacobian 矩阵 |

------

### 函数：`fx`

#### 调用语法

```matlab
[x, f] = fx(f)
```

#### 功能说明

将以字符串形式书写的方程组转换为符号表达式，并提取其中所有符号变量。该函数为内部辅助函数，由 `Jacobi_solve` 自动调用。

#### 输入参数

| 参数 | 类型                        | 说明   |
| ---- | --------------------------- | ------ |
| `f`  | 字符串元胞数组或 `sym` 类型 | 方程组 |

#### 输出参数

| 参数 | 类型       | 说明                    |
| ---- | ---------- | ----------------------- |
| `x`  | `sym` 向量 | 从 `f` 中提取的符号变量 |
| `f`  | 函数句柄   | 方程组的函数句柄形式    |

------

### 函数：`Jx`

#### 调用语法

```matlab
Jk = Jx(J, x, x0)
```

#### 功能说明

将数值点 `x0` 代入符号 Jacobian 矩阵 `J`，以 `double` 类型数值矩阵的形式返回结果。通过变量名称匹配确保代入顺序的正确性，不受变量排列顺序影响。

#### 输入参数

| 参数 | 类型           | 说明                                |
| ---- | -------------- | ----------------------------------- |
| `J`  | `sym` 矩阵     | 符号 Jacobian 矩阵                  |
| `x`  | 字符串元胞数组 | 变量名称列表（来自 `Jacobi_solve`） |
| `x0` | 数值向量       | 要代入的点坐标                      |

#### 输出参数

| 参数 | 类型          | 说明                             |
| ---- | ------------- | -------------------------------- |
| `Jk` | `double` 矩阵 | 在 `x0` 处数值化的 Jacobian 矩阵 |

------

### 使用示例

脚本以如下含 4 个方程的方程组为例演示完整工作流：

```matlab
f = {'tanh(x)', 'y^z*cos(x)', 'x^z*sin(y)', 'x^(y^z)'};
varargin = [pi, 1, 2];
[J, Jf, var] = Jacobi_solve(f, varargin);
J                          % 显示符号 Jacobian 矩阵
result = Jx(J, var, varargin);
result                     % 显示在点 (pi, 1, 2) 处的数值结果
```

**提取到的符号变量：** `x`、`y`、`z`

**Jacobian 矩阵结构**（4 个方程 × 3 个变量）：
$$
J = \begin{bmatrix} \frac{\partial f_1}{\partial x} & \frac{\partial f_1}{\partial y} & \frac{\partial f_1}{\partial z}\\ \frac{\partial f_2}{\partial x} & \frac{\partial f_2}{\partial y} & \frac{\partial f_2}{\partial z} \\ \frac{\partial f_3}{\partial x} & \frac{\partial f_3}{\partial y} & \frac{\partial f_3}{\partial z} \\ \frac{\partial f_4}{\partial x} & \frac{\partial f_4}{\partial y} & \frac{\partial f_4}{\partial z} \end{bmatrix}
$$


------

### 注意事项

- 本函数依赖 MATLAB **符号数学工具箱**（Symbolic Math Toolbox），使用了 `str2sym`、`symvar`、`diff`、`subs`、`matlabFunction` 等函数。
- 变量排列顺序遵循 `symvar` 的字母序约定。
- 若代入数值后 Jacobian 中不含符号变量，则直接调用 `double(J)` 返回结果。
- 行/列方向处理：若输入 `f` 为行向量，将自动转置为列向量符号表达式。

------

### 运行环境要求

- MATLAB R2016b 及以上版本（推荐）
- Symbolic Math Toolbox（符号数学工具箱）