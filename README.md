# Jacobian Matrix Calculator

### Overview

`Jacobi_solve` is a MATLAB function that computes the **symbolic Jacobian matrix** of a system of equations. It also supports numerical evaluation at a given point. The function automatically extracts symbolic variables, performs symbolic differentiation, and optionally substitutes a specific point to return a numerical result.

------

### File Structure

The `.m` file contains three functions:

| Function       | Role                                                         |
| -------------- | ------------------------------------------------------------ |
| `Jacobi_solve` | Main entry — computes the symbolic Jacobian and optionally evaluates it |
| `fx`           | Helper — converts string expressions to symbolic function handles |
| `Jx`           | Helper — substitutes a point into the Jacobian for numerical evaluation |

------

### Function: `Jacobi_solve`

#### Syntax

```matlab
[J, Jf, var] = Jacobi_solve(f, varargin)
```

#### Description

Computes the symbolic Jacobian matrix of the input function system `f`. Each column of the output corresponds to the partial derivatives with respect to one symbolic variable.

#### Inputs

| Parameter  | Type                             | Description                                                  |
| ---------- | -------------------------------- | ------------------------------------------------------------ |
| `f`        | `cell array` of strings or `sym` | The system of equations, e.g. `{'sin(x)', 'x*y'}`            |
| `varargin` | numeric vector (optional)        | Coordinate point `x0` at which to evaluate the Jacobian numerically |

#### Outputs

| Parameter     | Type                  | Description                                       |
| ------------- | --------------------- | ------------------------------------------------- |
| `J`           | `sym` matrix          | Symbolic Jacobian matrix                          |
| `Jf`          | function handle       | MATLAB function handle form of the Jacobian       |
| `var`         | cell array of strings | List of symbolic variable names                   |
| `varargin{4}` | numeric matrix        | (optional) Jacobian evaluated numerically at `x0` |

------

### Function: `fx`

#### Syntax

```matlab
[x, f] = fx(f)
```

#### Description

Converts a system of equations written as strings into symbolic expressions, then extracts all symbolic variables. This is an internal helper called automatically by `Jacobi_solve`.

#### Inputs

| Parameter | Type                           | Description         |
| --------- | ------------------------------ | ------------------- |
| `f`       | cell array of strings or `sym` | System of equations |

#### Outputs

| Parameter | Type            | Description                           |
| --------- | --------------- | ------------------------------------- |
| `x`       | `sym` vector    | Symbolic variables extracted from `f` |
| `f`       | function handle | Function handle form of the system    |

------

### Function: `Jx`

#### Syntax

```matlab
Jk = Jx(J, x, x0)
```

#### Description

Substitutes a numerical point `x0` into the symbolic Jacobian `J` and returns the result as a numeric double matrix. Handles variable matching by name to ensure correct substitution order regardless of variable ordering.

#### Inputs

| Parameter | Type                  | Description                              |
| --------- | --------------------- | ---------------------------------------- |
| `J`       | `sym` matrix          | Symbolic Jacobian matrix                 |
| `x`       | cell array of strings | Variable name list (from `Jacobi_solve`) |
| `x0`      | numeric vector        | Point at which to evaluate               |

#### Outputs

| Parameter | Type            | Description                            |
| --------- | --------------- | -------------------------------------- |
| `Jk`      | `double` matrix | Numerically evaluated Jacobian at `x0` |

------

### Example

The script demonstrates the full workflow with the following 4-equation system:

```matlab
f = {'tanh(x)', 'y^z*cos(x)', 'x^z*sin(y)', 'x^(y^z)'};
varargin = [pi, 1, 2];
[J, Jf, var] = Jacobi_solve(f, varargin);
J                          % Display symbolic Jacobian
result = Jx(J, var, varargin);
result                     % Display numerical result at (pi, 1, 2)
```

**Symbolic variables extracted:** `x`, `y`, `z`

**Jacobian structure** (4 equations × 3 variables):
$$
J = \begin{bmatrix} \frac{\partial f_1}{\partial x} & \frac{\partial f_1}{\partial y} & \frac{\partial f_1}{\partial z} \\ \frac{\partial f_2}{\partial x} & \frac{\partial f_2}{\partial y} & \frac{\partial f_2}{\partial z} \\ \frac{\partial f_3}{\partial x} & \frac{\partial f_3}{\partial y} & \frac{\partial f_3}{\partial z} \\ \frac{\partial f_4}{\partial x} & \frac{\partial f_4}{\partial y} & \frac{\partial f_4}{\partial z} \end{bmatrix}
$$


------

### Notes

- The function uses MATLAB's **Symbolic Math Toolbox** (`str2sym`, `symvar`, `diff`, `subs`, `matlabFunction`).
- Variable ordering follows `symvar`'s alphabetical convention.
- If the Jacobian has no symbolic variables remaining after substitution, `double(J)` is called directly.
- Row/column orientation: input `f` is automatically transposed if needed to ensure a column vector of symbolic expressions.

------

### Requirements

- MATLAB R2016b or later (recommended)
- Symbolic Math Toolbox