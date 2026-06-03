/*
Template according to: https://se.moevm.info/doku.php/courses:reportrules
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
  Кафедра АМ

  #v(54mm)

  ОТЧЕТ \
  по домашней работе №3 \
  по дисциплине "Элементы функционального анализа" \

  #v(54mm)

  #table(
    columns: (33%, 33%, 33%),
    inset: 10pt,
    align: horizon,
    stroke: none,
    "Студент гр. 3381",
    "",
    table.hline(start: 1, end: 2),
    "Иванов А. А.",
    "Преподаватель",
    "",
    table.hline(start: 1, end: 2),
    "Коточигов А. М."
  )

  #set align(bottom)
  Санкт-Петербург \
  #datetime.today().year()
]
#pagebreak()

// Start numbering here to skip first page numbering
#set page(
  numbering: "1"
)

// Common style of block
#let theorem-block(title, body) = block(
  inset: 12pt,
  radius: 4pt,
  // stroke: 0.7pt + gray,
  // fill: color,
  width: 100%,
)[
  #set par(first-line-indent: 0pt, leading: 1.5em)

  #text(weight: "bold")[#title]

  #v(4pt)

  #body
]

#let definition(name, body) = theorem-block(
  [Определение (#name)],
  body
)

#let theorem(name, body) = theorem-block(
  [Теорема (#name)],
  body
)

#let corollary(name, body) = theorem-block(
  [Следствие (#name)],
  body
)

\
== Условие

#underline[Вариант 6]

Дано пространство $X = RR^4$ (гильбертово со стандартным скалярным произведением). Подпространство $Y subset X$ задано уравнением
$
Y = {y in X : (k, y) = 0}, quad k = (1, 7, 1, 2).
$
На $Y$ определён линейный функционал
$
g in Y^* : g(y) = (g, y), quad g = (4, 9, 3, 1).
$

\
== Задание

Требуется построить линейный непрерывный функционал $f in X^*$, являющийся продолжением $g$ с сохранением нормы:
$
f|_Y = g, quad norm(f)_(X^*) = norm(g)_(Y^*).
$

Выполнение работы разбивается на следующие шаги:

1. Убедиться, что формальное продолжение $f_0(x) = (g, x)$ не сохраняет норму (вычислить $norm(g)_(X^*)$).
2. Построить ортонормированный базис ${a, b, c}$ подпространства $Y$ такой, что $g(a) = g(b) = 0$, $g(c) != 0$; вычислить $g(c)$ и норму $norm(g)_(Y^*)$.
3. Дополнить базис до ортонормированного базиса ${a, b, c, d}$ всего пространства $X$ и определить функционал-продолжение $f in X^*$, положив $f(d) = 0$. Объяснить, почему $norm(f)_(X^*) = norm(g)_(Y^*)$.
4. Вычислить значения $f(e_j)$ в стандартном базисе $e_1, e_2, e_3, e_4$ и найти норму $norm(f)_(X^*)$ через полученные координаты.

\
== Теория

#definition(
  [Норма линейного функционала],
  [
  Пусть $X$ --- нормированное пространство. Нормой линейного функционала $f : X -> RR$ называется
  $
  norm(f) = sup_(norm(x) <= 1) |f(x)|.
  $
  Совокупность всех непрерывных линейных функционалов на $X$ образует *сопряжённое пространство* $X^*$.
  ]
)

#theorem(
  [Рисса-Фишера],
  [
  Пусть $H$ --- гильбертово пространство. Для любого непрерывного линейного функционала $f in H^*$ существует единственный элемент $y_f in H$ такой, что
  $
  f(x) = (x, y_f) quad forall x in H,
  $
  причём $norm(f) = norm(y_f)$.

  В конечномерном случае это означает, что всякий линейный функционал задаётся скалярным произведением с фиксированным вектором.
]
)

#definition(
  [Продолжение функционала],
  [
  Пусть $X$ --- линейное пространство, $Y subset X$ --- подпространство, $g : Y -> RR$ --- линейный функционал. Линейный функционал $f : X -> RR$ называется *продолжением* $g$, если $f|_Y = g$.
  ]
)

#theorem("Хана–Банаха для гильбертова пространства")[
  Пусть $H$ --- гильбертово пространство, $Y subset H$ --- замкнутое подпространство, $g in Y^*$. Тогда существует продолжение $f in H^*$ такое, что $f|_Y = g$ и $norm(f) = norm(g)$.
]

#definition(
  [Ядро линейного функционала],
  [
  *Ядром* линейного функционала $f$ на линейном пространстве $X$ называется множество
  $
  ker f = {x in X | f(x) = 0}.
  $
  В гильбертовом пространстве ненулевой непрерывный линейный функционал полностью (с точностью до постоянного множителя) определяется своим ядром --- замкнутой гиперплоскостью.
  ]
)

\
== Выполнение работы

=== Формальное продолжение и его норма

Формальным продолжением функционала $g$ на всё $X$ является функционал
$
f_0(x) = (g, x), quad x in RR^4.
$
Вычислим норму функционала $f_0$ по определению:
$
norm(f_0)
=
sup_(norm(x)=1) |f_0(x)|
=
sup_(norm(x)=1) |(g,x)|.
$

По неравенству Коши--Буняковского
$
|(g,x)| <= norm(g) norm(x).
$

Так как $norm(x)=1$, получаем
$
|(g,x)| <= norm(g).
$

Следовательно,
$
norm(f_0) <= norm(g).
$

Равенство достигается при
$
x = frac(g, norm(g)),
$
поскольку тогда
$
f_0(x)
=
(g, frac(g, norm(g)))
=
frac((g,g), norm(g))
=
norm(g).
$

Поэтому
$
norm(f_0)
=
norm(g)
=
sqrt(4^2 + 9^2 + 3^2 + 1^2)
=
sqrt(107).
$


Найдём норму исходного функционала $g$ на подпространстве $Y$. Так как $Y = {k}^perp$, ортогональный проектор на $Y$ имеет вид
$
P_Y x = x - frac((x, k), norm(k)^2) k.
$
Вычислим:
$
norm(k)^2 = 1^2 + 7^2 + 1^2 + 2^2 = 1 + 49 + 1 + 4 = 55,
$
$
(g, k) = 4 dot 1 + 9 dot 7 + 3 dot 1 + 1 dot 2 = 4 + 63 + 3 + 2 = 72.
$
Тогда проекция вектора $g$ на $Y$ равна
$
h = P_Y g = g - frac(72, 55) k.
$
Подставляя координаты:
$
h = &(4 - frac(72,55) dot 1; 9 - frac(72,55) dot 7; 3 - frac(72,55) dot 1; 1 - frac(72,55) dot 2) \
= &(frac(220 - 72, 55); frac(495 - 504, 55); frac(165 - 72, 55); frac(55 - 144, 55)) \
= &(frac(148,55); -frac(9,55); frac(93,55); -frac(89,55)).
$
Норма $h$:
$
norm(h)^2 =
&frac(148^2 + 9^2 + 93^2 + 89^2, 55^2) = \
&frac(21904 + 81 + 8649 + 7921, 3025) =
frac(38555, 3025) = frac(701, 55).
$
Для любого $y in Y$ имеем $(g, y) = (h, y)$, следовательно,
$
norm(g)_(Y^*) = sup_(y in Y, norm(y) = 1) |(h, y)| = norm(h) = sqrt(frac(701, 55)) approx 3.57.
$
Так как $sqrt(701 \/ 55) approx 3.57 < sqrt(107) approx 10.34$, формальное продолжение $f_0$ не сохраняет норму.

=== Ортонормированный базис подпространства $Y$ с условием $g(a) = g(b) = 0$ и $g(c) != 0$

Вектор $h = P_Y g$ принадлежит $Y$ и задаёт тот же функционал на $Y$, что и $g$. Положим
$
c = frac(h, norm(h)) = frac(h, sqrt(701 \/ 55)).
$
Тогда $c in Y$, $norm(c) = 1$, и
$
g(c) = (h, c) = norm(h) = sqrt(frac(701, 55)) != 0.
$

Теперь построим ортонормированный базис ядра функционала $g$ на $Y$:
$
ker(g|_Y) = {y in Y | (g, y) = 0} = Y sect {h}^perp.
$
Это множество описывается системой
$
cases(
  x_1 + 7 x_2 + x_3 + 2 x_4 = 0,
  148 x_1 - 9 x_2 + 93 x_3 - 89 x_4 = 0.
)
$
Из первого уравнения выразим $x_3 = -x_1 - 7x_2 - 2x_4$ и подставим во второе:
$
148x_1 - 9x_2 + 93(-x_1 - 7x_2 - 2x_4) - 89x_4 = 0
$
$
55x_1 - 660x_2 - 275x_4 = 0.
$
Разделим на 55:
$
x_1 - 12x_2 - 5x_4 = 0.
$

*Первый вектор.* При $x_4 = 0$ получаем $x_1 = 12x_2$. Возьмём $x_2 = 1$: $x_1 = 12$, $x_3 = -12 - 7 - 0 = -19$. Вектор
$
v = (12, 1, -19, 0), quad norm(v)^2 = 144 + 1 + 361 + 0 = 506.
$

*Второй вектор.* Ищем вектор $w$, ортогональный $v$ и лежащий в $ker(g|_Y)$. Используем $w_1 = 12w_2 + 5w_4$ и подставим в условие ортогональности $(v, w) = 0$ (выражая $w_3 = -w_1 - 7w_2 - 2w_4$):
$
12w_1 + w_2 - 19(-w_1 - 7w_2 - 2w_4) = 0
$
$
31w_1 + 134w_2 + 38w_4 = 0.
$
Подставляем $w_1 = 12w_2 + 5w_4$:
$
31(12w_2 + 5w_4) + 134w_2 + 38w_4 = 506w_2 + 193w_4 = 0.
$
Берём $w_2 = -193$, $w_4 = 506$. Тогда $w_1 = 12(-193) + 5(506) = -2316 + 2530 = 214$,
$w_3 = -214 - 7(-193) - 2 dot 506 = -214 + 1351 - 1012 = 125$.
Итак:
$
w =
(214, -193, 125, 506), \
quad norm(w)^2 = 45796 + 37249 + 15625 + 256036 = 354706.
$

Непосредственно проверяется, что $v, w in Y$, $(g, v) = (g, w) = 0$ и $(v, w) = 0$.

Нормируем векторы:
$
a = frac(v, sqrt(506)), quad b = frac(w, sqrt(354706)).
$
Тогда ${a, b, c}$ --- ортонормированный базис $Y$, причём
$
g(a) = 0, quad g(b) = 0, quad g(c) = sqrt(frac(701, 55)).
$

=== Дополнение до базиса $RR^4$ и построение продолжения

Дополним $Y$ до всего $RR^4$ вектором
$
d = frac(k, norm(k)) = frac((1, 7, 1, 2), sqrt(55)),
$
который ортогонален $Y$ и имеет единичную норму. Система ${a, b, c, d}$ является ортонормированным базисом $X$.

Определим линейный функционал $f$ на $X$ его значениями на базисных векторах:
$
f(a) = 0, quad f(b) = 0, quad f(c) = g(c) = sqrt(frac(701, 55)), quad f(d) = 0.
$
Такой функционал линеен, непрерывен, и для любого $y = alpha a + beta b + gamma c in Y$ имеем $f(y) = gamma sqrt(701\/55) = g(y)$. Следовательно, $f|_Y = g$.

*Почему $norm(f)_(X^*) = norm(g)_(Y^*)$?* В ортонормированном базисе ${a, b, c, d}$ координаты представляющего вектора $f_"vec"$ равны $(0, 0, sqrt(701\/55), 0)$, т.е.
$
f_"vec" = sqrt(frac(701, 55)) dot c = frac(sqrt(701\/55), norm(h)) h = h.
$
Таким образом, $f(x) = (h, x)$ для всех $x in RR^4$, и
$
norm(f)_(X^*) = norm(h) = sqrt(frac(701, 55)) = norm(g)_(Y^*).
$
Функционал $f$ реализует норм-сохраняющее продолжение теоремы Хана–Банаха.

=== Вычисление $f(e_j)$ и проверка нормы

Стандартный базис: $e_1 = (1,0,0,0)$, $e_2 = (0,1,0,0)$, $e_3 = (0,0,1,0)$, $e_4 = (0,0,0,1)$.

Поскольку $f(x) = (h, x)$, значения функционала:
$
&f(e_1) = h_1 = frac(148,55), quad \
&f(e_2) = h_2 = -frac(9,55), quad \
&f(e_3) = h_3 = frac(93,55), quad \
&f(e_4) = h_4 = -frac(89,55).
$

Матрица функционала (строка) в стандартном базисе:
$
[f] = lr([frac(148,55), quad -frac(9,55), quad frac(93,55), quad -frac(89,55)]).
$

Норма функционала в $ell^2_4$:
$
norm(f) = &frac(1, 55) sqrt(148^2 + 9^2 + 93^2 + 89^2) \
&= frac(sqrt(21904 + 81 + 8649 + 7921), 55)
= frac(sqrt(38555), 55)
= sqrt(frac(701, 55)),
$
что совпадает с нормой $norm(g)_(Y^*)$. Задача решена.

#pagebreak()
= Приложение А \ ИСХОДНЫЙ КОД

#show link: underline
Ссылка: #link("https://github.com/artyoomi/etu-func-analysis-2026")

