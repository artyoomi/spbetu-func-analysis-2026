# %%
# Load data

from selectors import BaseSelector
import pandas as pd
import numpy  as np


DATASET_FILENAME = 'dataset.csv'

# Read data
df = pd.read_csv(DATASET_FILENAME).set_index('Label')

# Preprocess data
for c in df.columns:
    df[c] = df[c].apply(
        lambda x: np.float64(eval(str(x)))
            if isinstance(x, str) and '/' in str(x)
            else np.float64(x)
    )
print(df)

# %%
# Split DataFrame to logical blocks

import seaborn as sns


# Use abs to move all points in positive quadrant
params_df = df.loc[['a', 'b']].abs()

# Add a+b to params DataFrame
a_plus_b_row = pd.DataFrame(index=['a+b'], data=[params_df.loc['a'] + params_df.loc['b']])
params_df = pd.concat([params_df, a_plus_b_row])

print(params_df)

# %%

QUADRANTS_MULTIPLIERS = {
    1: ( 1,  1,  1),
    # 2: (-1,  1,  1),
    # 3: (-1, -1,  1),
    # 4: ( 1, -1,  1),
    # 5: ( 1,  1, -1),
    # 6: (-1,  1, -1),
    # 7: (-1, -1, -1),
    # 8: ( 1, -1, -1)
}

initial_points_df = df.loc[['v1', 'v2', 'v3', 'v4', 'v5', 'v6']]

points_labels = []
points_data = []

point_number = 1
for quadrant_num, (sign_x, sign_y, sign_z) in QUADRANTS_MULTIPLIERS.items():
    for label in initial_points_df.index:
        x, y, z = initial_points_df.loc[label]

        points_labels.append(f"{point_number}")
        point_number += 1

        points_data.append((
            sign_x * x,
            sign_y * y,
            sign_z * z
        ))

points_df = pd.DataFrame(
    points_data,
    columns=initial_points_df.columns,
    index=points_labels
)

print(points_df.head())

# %%
# Get all surfaces of polyhedron

# Surface settings for each quadrant
SURFACES = {
    1: (1, 2, 3),
    2: (1, 2, 4),
    3: (1, 3, 5),
    4: (2, 3, 6)
}

def get_surface_equasion(p1, p2, p3):
    """Calculates coefficients of surface equasion by three points in R^3.

    :param p1: First surface point
    :param p2: Second surface point
    :param p3: Third surface point
    :return: Tuple with coefficients of surface equasion
    """

    x1, y1, z1 = p1
    x2, y2, z2 = p2
    x3, y3, z3 = p3

    v1 = [x2 - x1, y2 - y1, z2 - z1]
    v2 = [x3 - x1, y3 - y1, z3 - z1]

    n = np.cross(v1, v2)
    A, B, C = n

    D = -(A*x1 + B*y1 + C*z1)

    return A, B, C, D


surfaces_labels = []
surfaces_data = []

surface_number = 1
for i in range(0, len(points_df), len(initial_points_df)):

    for j, value in enumerate(SURFACES.values()):
        surfaces_labels.append(surface_number)
        surface_number += 1
        surfaces_data.append((
            str(i + value[0]),
            str(i + value[1]),
            str(i + value[2])
        ))

surfaces_df = pd.DataFrame(
    surfaces_data,
    columns=['p1', 'p2', 'p3'],
    index=surfaces_labels
)
surfaces_df.head(32)

# %%
# Get all unique points

unique_points_df = points_df.drop_duplicates()
unique_points_df.head()

# %%
# Plot polyhedron

import matplotlib.pyplot as plt

from mpl_toolkits.mplot3d import proj3d
from mpl_toolkits.mplot3d.art3d import Poly3DCollection


def get_visible_faces(ax, vertices_df, faces_df):
    visible_faces = []
    for idx, points in faces_df.iterrows():

        verts = np.array([
            vertices_df.loc[points['p1']],
            vertices_df.loc[points['p2']],
            vertices_df.loc[points['p3']]
        ])

        # project vertices to 2D screen space
        xs, ys, zs = proj3d.proj_transform(
            verts[:,0], verts[:,1], verts[:,2], ax.get_proj()
        )

        p1 = np.array([xs[0], ys[0]])
        p2 = np.array([xs[1], ys[1]])
        p3 = np.array([xs[2], ys[2]])

        # compute signed area in screen space
        v1 = p2 - p1
        v2 = p3 - p1

        cross = v1[0]*v2[1] - v1[1]*v2[0]

        if cross < 0:   # orientation depends on vertex ordering
            visible_faces.append(idx)

    return visible_faces


fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
ax.view_init(elev=20, azim=40)

surfaces_colors = sns.color_palette("Set1", len(SURFACES))


# Plot surfaces
for surface_name, row in surfaces_df.iterrows():

    vertices = np.array([
        points_df.loc[row['p1']],
        points_df.loc[row['p2']],
        points_df.loc[row['p3']],
    ])

    ax.add_collection3d(
        Poly3DCollection(
            [vertices],
            alpha=0.8,
            facecolor=surfaces_colors[int(surface_name) % len(surfaces_colors)],
            edgecolor='black',
        )
    )

# Plot each point with its label
ax.scatter(
    points_df['x'],
    points_df['y'],
    points_df['z'],
    marker='o',
    s=30,
    color='white',
    linewidths=1,
    edgecolors='black'
)

# <TODO> Plot surface labels only for visible ones
# print(len(get_visible_faces(ax, points_df, surfaces_df)))
# for surface_name in get_visible_faces(ax, points_df, surfaces_df):
for surface_name in surfaces_df.index:
    points = surfaces_df.loc[surface_name]
    centroid = np.mean([points_df.loc[p] for p in points], axis=0)

    points = [
        points_df.loc[p] for p in surfaces_df.loc[surface_name]
    ]
    centroid = np.mean(points, axis=0)
    ax.text(centroid[0], centroid[1], centroid[2],
        f'  {surface_name}  ',
        fontsize=8, fontweight='bold',
        ha='center', va='center',
        bbox=dict(
            boxstyle='square',
            facecolor='white',
            alpha=0.9,
            edgecolor='black',
            linewidth=1
        ),
        zorder=100
    )
    for point in points:
        ax.text(
            point['x'],
            point['y'],
            point['z'],
            point.name,
            fontsize=8,
            color='black',
            ha='center',
            bbox=dict(boxstyle='round', facecolor='white', alpha=0.9),
            zorder=100,
        )


ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
plt.tight_layout()
plt.show()

# %%
# Calculate surface equasion for each surface


def calculate_surface_sign(A, B, C, D, x, y, z):
    """Calculate surface function sign by its coefficients.

    :param A: First coefficient.
    :param B: Second coefficient.
    :param C: Third coefficient.
    :param D: Fourth coefficient.
    :param x: \
    :param y:  }  Point to calculate value in.
    :param z: /
    :return: Sign of function in point: -1, 0 or 1.
    """

    CMP_THRESHOLD = 1e-10

    value = A * x + B * y + C * z + D
    return 0 if abs(value) < CMP_THRESHOLD else (-1 if value < 0 else 1)


surface_equasions = []

for idx, row in surfaces_df.iterrows():
    A, B, C, D = get_surface_equasion(
        points_df.loc[row['p1']],
        points_df.loc[row['p2']],
        points_df.loc[row['p3']],
    )
    surface_equasions.append((A, B, C, D))

# Check that polyhedron is convex
for A, B, C, D in surface_equasions:
    sign = None
    for idx, point in points_df.iterrows():
        new_sign = calculate_surface_sign(
            A, B, C, D,
            point['x'],
            point['y'],
            point['z'],
        )
        print(A * point['x'] + B * point['y'] + C * point['z'] + D)

        if new_sign != 0:
            if sign is not None and new_sign != sign:
                print(f"Point {point} on different space half")
                break
            else:
                sign = new_sign
    else:
        print(f"All points are on same half of space for: ({A})x + ({B})y + ({C})z + ({D})")
        continue
    break

# %%
# Calculate orthonorm base for each face

from fractions import Fraction


def calculate_orthonorm_base(a1, a2, a3):
    B1 = np.cross(a2, a3)
    B2 = np.cross(a1, a3)
    B3 = np.cross(a1, a2)

    b1 = B1 / np.dot(B1, a1)
    b2 = B2 / np.dot(B2, a2)
    b3 = B3 / np.dot(B3, a3)
    return [b1, b2, b3]

bases = []
for idx, row in surfaces_df.iterrows():
    a1 = points_df.loc[row['p1']]
    a2 = points_df.loc[row['p2']]
    a3 = points_df.loc[row['p3']]

    base = calculate_orthonorm_base(a1, a2, a3)
    bases.append(base)

bases = pd.DataFrame(
    bases,
    columns=range(1, len(bases[0]) + 1),
    index=surfaces_df.index
)
print(bases.head())

# %%
# Pretty print calculated base to use it in report

from fractions import Fraction


for idx, base in bases.iterrows():
    pretty_base = []
    print(f"base for surface with idx={idx}:")
    for i, v in enumerate(base):
        print(
            [str(Fraction(x).limit_denominator()) for x in v]
        )

# %%
# Calculate coords in orthonorm bases

for base_idx, base in bases.iterrows():
    for param_idx, param in params_df.iterrows():
        new_coords = []
        for v in base:
            new_coord = np.dot(param, v)
            if (new_coord < 0):
                break
            new_coords.append(new_coord)
        else:
            # Print result and calculate norm
            print(f"calculate new coords for {param_idx} in surface {base_idx} base")
            print(f"new_coords={new_coords}")
            print(f"pretty_new_coords={[str(Fraction(x).limit_denominator()) for x in new_coords]}")
            print(f"norm={np.sum(new_coords)}")
            print(f"pretty_norm={Fraction(np.sum(new_coords)).limit_denominator()}")
            print()
