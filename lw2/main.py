# %%
# Task conditions and print helpers

import numpy as np
from fractions import Fraction

def pretty_float(f):
    return str(Fraction(f).limit_denominator())

def mat_pprint(A):
    # Convert 1D array to 2D if necessary
    if isinstance(A, np.ndarray) and A.ndim == 1:
        A = A.reshape(1, -1)
    elif isinstance(A, list) and A and not isinstance(A[0], (list, np.ndarray)):
        A = [A]

    # Rest of your original code...
    frac_matrix = []
    for row in A:
        frac_row = []
        if not isinstance(row, (list, np.ndarray)):
            frac_matrix.append(pretty_float(row))
        else:
            for elem in row:
                frac = pretty_float(elem)
                frac_row.append(frac)
            frac_matrix.append(frac_row)

    # ... rest unchanged
    str_matrix = []
    for row in frac_matrix:
        if isinstance(row, list):
            str_row = [str(elem) for elem in row]
            str_matrix.append(str_row)
        else:
            str_matrix.append([[str(row)]])

    if not str_matrix:
        return

    num_cols = len(str_matrix[0])
    col_widths = []
    for col in range(num_cols):
        max_width = max(len(str_matrix[row][col]) for row in range(len(str_matrix)))
        col_widths.append(max_width)

    for row in str_matrix:
        formatted_row = "  ".join(
            f"{elem:>{col_widths[i]}}" for i, elem in enumerate(row)
        )
        print(formatted_row)

A = np.array([
    [735/19, 144/19, 132/19, -540/19],
    [24/19, 279/19, 42/19, 108/19],
    [1284/19, 648/19, 537/19, -720/19],
    [-750/19, -126/19, -30/19, 729/19]
])

b = np.array([1, 2, 3, 4])
db = np.array([1/10, 1/10, 1/10, 1/10])

mat_pprint(A)

# %%
# Calculate inverse A

A_inv = np.linalg.inv(A)
mat_pprint(A_inv)

# %%
# Operator norms

def l1_norm(matrix):
    return np.linalg.norm(matrix, ord=1)

def linfty_norm(matrix):
    return np.linalg.norm(matrix, ord=np.inf)

def l2_norm(matrix):
    return np.linalg.norm(matrix, ord=2)

# %%
# l1 norm

print(l1_norm(A))

# %%
# l^infinity norm

mat_pprint(A @ np.array([1, 1, 1, -1]))
print(pretty_float(linfty_norm(A)))

# %%
# l^2 norm

print(l2_norm(A))

# %%
# Condition number in l1

print(pretty_float(l1_norm(A) * l1_norm(A_inv)))

# %%
# Solve Ax = b and find delta x

x = np.linalg.solve(A, b)
mat_pprint(x)
xt = np.linalg.solve(A, b + db)
mat_pprint(xt)

dx = xt - x
mat_pprint(dx)

# %%
# Relational change for given b

print("l^1:", end=' ')
print(pretty_float(
    (l1_norm(dx) / l1_norm(x)) / (l1_norm(b) / l1_norm(db))
))

print("l^infty:", end=' ')
print(pretty_float(
    (linfty_norm(dx) / linfty_norm(x)) / (linfty_norm(b) / linfty_norm(db))
))

print("l^2:", end=' ')
print(
    (l2_norm(dx) / l2_norm(x)) / (l2_norm(b) / l2_norm(db))
)

# %%

print(pretty_float(linfty_norm(A @ np.array([1, 1, 1, -1]))))
# %%
# Condition number in l^infinity

print(pretty_float(linfty_norm(A) * linfty_norm(A_inv)))

# %%
# Find A^T * A

ATA = A.T @ A
mat_pprint(ATA)

# %%
# Find max eigen value and appropriate eigen vector

vals, vecs = np.linalg.eig(ATA)
if np.iscomplexobj(vals):
    max_idx = np.argmax(np.abs(vals))
else:
    max_idx = np.argmax(vals)

eigval = vals[max_idx]
eigvec = vecs[:, max_idx]
print(f"Max eigen value: {eigval}")
print(f"Max eigen value sqrt: {np.sqrt(eigval)}")
print(f"Max eigen vector: {eigvec}")

print(l2_norm(eigvec))

print("A * x =", end=' ')
print(A @ eigvec)
print(l2_norm(A @ eigvec))
print(l2_norm(A))
# %%
# Condition number in l^2

print(l2_norm(A) * l2_norm(A_inv))
