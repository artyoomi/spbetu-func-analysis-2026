/*
Template according to: https://se.moevm.info/doku.php/courses:reportrules

Latex reference from one cool guy:
https://github.com/JAkutenshi/eltechLaTeXTemplates/blob/master/LabReports/tex/title.tex
*/


// Page setup
#set page(
  width: 210mm,
  height: 297mm,
  margin: (top: 20mm, bottom: 20mm, left: 30mm, right: 15mm)
)

// General text setup
#set text(
  size: 14pt,
  lang: "ru"
)

// Paragraph setup
#set par(
  leading: 1.5em,
  first-line-indent: 1.25cm,
  justify: true
)

// To provide numeration like 1, 1.1, 1.1.1 and so on
#set enum(full: true)

// Setup level 1 header
#show heading.where(level: 1): it => [
  #set text(size: 14pt, weight: "bold")
  #set par(first-line-indent: 0pt, leading: 1.5em)
  #set align(center)
  #upper(it.body)
]

// Setup level 2 header
#show heading.where(level: 2): it => [
  #set text(size: 14pt, weight: "bold")
  #set par(first-line-indent: 1.25cm, leading: 1.5em, justify: true)
  #it.body
]

// Setup level 3 header
#show heading.where(level: 3): it => [
  #set text(size: 13pt, weight: "bold")
  #set par(first-line-indent: 1.25cm, leading: 1.5em, justify: true)
  #it.body
]

// Setup table captions
#show figure.where(kind: table): fig => {
  align(left)[
    #fig.caption
    #fig.body
  ]
}

// Long "-" between numering and caption in all figures
#show figure: set figure.caption(separator: [ ---])

// Allow all figures containing tables to break across pages
#show figure.where(kind: table): set block(breakable: true)

// Force all raw blocks to have 1em indent between lines
#show raw.where(block: true): set par(leading: 1em)
// Force all raw blocks to have left alignment
// #show raw.where(block: true): set align(left)

// Enable formula numbering
#set math.equation(numbering: "(1)")

// First page setup
#align(center)[
  #set text(weight: "semibold")

  #set par(leading: 1em)

  МИНОБРНАУКИ РОССИИ \
  САНКТ-ПЕТЕРБУРГСКИЙ ГОСУДАРСТВЕННЫЙ \
  ЭЛЕКТРОТЕХНИЧЕСКИЙ УНИВЕРСИТЕТ \
  «ЛЭТИ» ИМ. В.И. УЛЬЯНОВА (ЛЕНИНА) \
  Кафедра МО ЭВМ

  #v(54mm)

  ОТЧЕТ \
  по домашней работе №1 \
  по дисциплине "Элементы функционального анализа" \


  #v(54mm)

  #table(
    columns: (33%, 33%, 33%),
    inset: 10pt,
    align: horizon,
    stroke: none,
    "Студент гр. 3381",
    "",
    table.hline(start: 1 , end: 2),
    "Иванов А. А.",
    "Преподаватель",
    "",
    table.hline(start: 1 , end: 2),
    "Коточигов А. М."
  )

  #set align(bottom)
  Санкт-Петербург \
  #datetime.today().year()
]
#pagebreak()

// Start numbering here to skip first page numering
#set page(
  numbering: "1"
)

// To make indent before first header

\
== Задание
#underline[Вариант 6]

+ Построить по набору точек из первой квадранты кусок многогранника;
+ Построить остальные части многогранника, считая, что остальные части симметричны относительно соответствующих координат;
+ Для каждой грани многогранника в положительном квадранте построить уравнение плоскости и проверить, что полученный многогранник является выпуклым;
+ Перевести точки $a$, $b$ и $a + b$ в точки с такой же нормой в положительном квадранте и вычислить их нормы.

\
== Выполнение работы

Для визуализации данных и вычислений используется язык программирования Python и его библиотеки для визуализации данных и вычислений: NumPy, Pandas, seaborn, matplotlib.

=== Отображение точек на остальные квадранты

При переходе между квадрантами знаки координат точек меняются по определённому закону. Соответствующие множители представлены в @quadrants.

#figure(
  caption: [
    Множители при переменных в каждой квадранте
  ],
  ```python
  quadrants = {
    1: ( 1,  1,  1),
    2: (-1,  1,  1),
    3: (-1, -1,  1),
    4: ( 1, -1,  1),
    5: ( 1,  1, -1),
    6: (-1,  1, -1),
    7: (-1, -1, -1),
    8: ( 1, -1, -1)
  }
  ```
) <quadrants>

После отображения точек из первой квадранты в остальные квадранты получены точки, представленны в @all_points.

#let all_points = csv("csv/all_points.csv")
#figure(
  caption: [
    Все вершины многогранника с дубликатами.
  ],
  table(
    align: center,
    columns: (25%, 25%, 25%, 25%),
    ..all_points.flatten()
  ),
) <all_points>

=== Удаление дубликатов из множества точек

Точки после удаления дубликатов представлены на @deduplicated_points.

#let deduplicated_points = csv("csv/deduplicated_points.csv")
#figure(
  caption: [
    Все вершины многогранника без дубликатов.
  ],
  table(
    align: center,
    columns: (25%, 25%, 25%, 25%),
    ..deduplicated_points.flatten()
  ),
) <deduplicated_points>

== Построение граней многогранника

После этого были построены грани многогранника в первой квадранте, а затем отображены на остальные квадранты относительно соответствующих осей.

В @surfaces приведены построенные грани.

#let surfaces = csv("csv/surfaces.csv")
#figure(
  caption: [
    Грани многогранника.
  ],
  table(
    align: center,
    columns: (25%, 25%, 25%, 25%),
    ..surfaces.flatten()
  ),
) <surfaces>

Ниже на @polyhedron_quadrant1 приведена часть многогранника на первой квадранте (остальные части не приведены, так как иначе изображение становится слишком громоздким).

#figure(
  caption: [
    Изображение многогранника в первой квадранте. $s_i$ обозначены грани, а $v_j$ -- точки многогранника.
  ],
  image("images/polyhedron_quadrant1.png"),
) <polyhedron_quadrant1>

=== Проверка многогранника на выпуклость

Пусть $arrow(p_1)$, $arrow(p_2)$, $arrow(p_3)$ -- точки в $RR^3$, для которых строится поверхность. Для получения уравнений поверхностей использовалось свойство нормы к поверхности, которое гласит, что норма $arrow(n) = [(arrow(p_2) - arrow(p_1)) times (arrow(p_3) - arrow(p_1))]$ равна вектору $(A, B, C)$, где $A$, $B$, $C$ --- соответствующие коэффициенты плоскости. $D$ вычисляется из уравнения $A x + B y + C z + D = 0$ подстановкой точки $arrow(p_1)$.

Вычисленные уравнения поверхностей для полученных граней и значения в соответствующих точках положительной квадранты представлены в @surface_equasions.

#figure(
  caption: [
    Уравнения плоскостей $s_1$, $s_2$, $s_3$, $s_4$ и значения этих уравнений при подстановке в них точек положительной квадранты.
  ],
  table(
    align: center,
    inset: 8pt,
    columns: (10%, 42%, 8%, 8%, 8%, 8%, 8%, 8%),
    //columns: 8,
    [$s_i$], [f(x, y, z) = $A x + B y + C z + D$],
    [$f(v_1)$], [$f(v_2)$], [$f(v_3)$], [$f(v_4)$], [$f(v_5)$], [$f(v_6)$],
    
    $s_1$, $-16 x - 16 y - 24 z + 176$,
    $0$, $0$, $0$, $24$, $48$, $40$,
    
    $s_2$, $-6 x - 3 y - 4.5 z + 57$,
    $0$, $0$, $24$, $0$, $33$, $31.5$,
    
    $s_3$, $-20 x - 32 y - 24 z + 256$,
    $0$, $48$, $0$, $66$, $0$, $120$,
    
    $s_4$, $-55/3 x - 40/3 y - 40 z + 680/3$,
    $40$, $0$, $0$, $52.5$, $120$, $0$
  )
) <surface_equasions>

В силу вышеописанного и симметрии плоскостей в разных квадрантах относительно соответствующих осей, многогранник является выпуклым.

=== Вычисление норм для точек $a$, $b$ и $a + b$

Норма для точек трёхмерного пространства задана с помощью невырожденного симметричного многогранника, содержащего 0. Пусть $W$ -- множество точек этого многогранника. Тогда норма, заданная таким образом вычисляется как

$ ||x|| = inf{lambda: x/lambda in W, lambda > 0}, forall x in W $

Чтобы понять, какой треугольник пересекает луч из начала координат к точке, для которой происходит поиск нормы, необходимо выразить эту точку через новый базис. К примеру, если нужно проверить, пересекает ли луч из начала в точку $a$ треугольник $(v_1, v_2, v_3)$, необходимо взять вектора $v_1, v_2, v_3$ в качестве базиса.

Однако вычислять таким образом координаты дорого, потому что для этого необходимо считать обратную матрицу. Вместо этого можно построить биортогональный базис для базиса $v_1$, $v_2$, $v_3$ и вычислять координаты через него.

Для вычисления биортогонального базиса $(arrow(b_1), arrow(b_2), arrow(b_3))$ для косого базиса $(arrow(a_1), arrow(a_2), arrow(a_3))$ используется векторное произведение векторов исходного базиса

$
&arrow(B_1) = arrow(a_2) times arrow(a_3),\ 
&arrow(B_2) = arrow(a_1) times arrow(a_3),\
&arrow(B_3) = arrow(a_1) times arrow(a_2),\
$

Для нормировки используется деление на скалярное произведение
$
&arrow(b_k) = arrow(B_k)/((arrow(B_k), arrow(a_k))), k = 1 : 3
$

Полученные после вычислений биортогональный базисы представлены на @biorth_bases
#figure(
$
s_1: lr({&(5/88, 2/11, -5/22), &(3/44, -2/11, 5/22), &(-3/88, 1/11, 3/22)}) \
s_2: lr({&(0, 1/3, 0), &(0, 0, 1/2), &(2/19, -16/57, -8/19)}) \
s_3: lr({&(1/8, 0, 0), &(0, 0, 1/4), &(-3/64, 1/8, -5/32)}) \
s_4: lr({&(1/8, 0, 0), &(0, 1/5, 0), &(-3/68, -12/85, 3/17)})
$,
caption: [
  Биортогональные базисы для каждой грани.
]
) <biorth_bases>

Далее координаты каждой из требуемых точек были вычислены через полученные базисы. Результаты представлены в @coords_in_biorth_base

#figure(
  caption: [
    Координаты точек $a$, $b$ и $a+b$ в биортогональных базисах.
  ],
  table(
    align: center,
    inset: 10pt,
    columns: (20%, 20%, 20%, 20%, 20%),
    table.cell(rowspan: 2, [*Точка*]),
    table.cell(colspan: 4, [*Точка в биортогональном базисе для*]),
    [$s_1$], [$s_2$], [$s_3$], [$s_4$],
    $a$,   $(-1/8, 3/4, 15/8)$,      $(3, 9/2, -110/19)$,
           $(5/8, 9/4, -33/64)$,     $(5/8, 9/5, 33/340)$,
    $b$,   $(-7/88, 31/44, 145/88)$, $(8/3, 4, -290/57)$,
           $(5/8, 2, -31/64)$,       $(5/8, 8/5, 21/340)$,
    $a+b$, $(-9/44, 16/11, 155/44)$, $(17/3, 17/2, -620/57)$,
           $(5/4, 17/4, -1)$,        $(5/4, 17/5, 27/170)$,
  ),
) <coords_in_biorth_base>

Как видно из таблицы, луч в каждую из искомых точек попадает в грань номер 4. Тогда искомые нормы равны

$
||a|| = 343/136& approx 2.5220588235294112 \
||b|| = 311/136& approx 2.2867647058823524 \
||a+b|| = 327/68& approx 4.8088235294117645&
$

#pagebreak()
= Приложение А \ ИСХОДНЫЙ КОД

#show link: underline
Ссылка: #link("https://github.com/artyoomi/etu-func-analysis-2026")

