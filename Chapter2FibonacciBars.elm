-- -*- coding: utf-8; -*-

import Lib (..)
import Window
import Signal
import Markdown

main = Signal.map (pageTemplate [content] "Chapter1HelloWorld" "toc" "Chapter3MouseSignals") Window.width

content = Markdown.toElement """

# Chapter 2 Fibonacci Bars

The *[FibonacciBars.elm](FibonacciBars.elm)* example program displays a pile of
rectangles. Their widths correspond to the values of the first
Fibonacci numbers. You can see the bars [here](FibonacciBars.html).

Before explaining how that program is written, let’s first make a
small detour, and introduce the REPL (Read Eval Print Loop) tool, that
Elm — like many other functional languages — provides.  The `elm-repl`
command starts it, like so:

      $ elm-repl
      Elm REPL 0.4 <https://github.com/elm-lang/elm-repl#elm-repl>
      Type :help for help, :exit to exit
      >
   
The REPL prints the initial message and the prompt `>` character. We
can now enter Elm statements and evaluate Elm expressions. Let’s first
add two numbers:

      > 1.0 + 6.5
      7.5 : Float

We added two floating-point numbers. Elm printed the result followed
by its type, `Float`, which denotes floating point numbers. The value
and the type are separated with the `:` character. We will now round a
floating point number by calling the `round` function. In addition to
that, we will assign a name to the result:

      > x = round 7.5
      8 : Int

In order to call a function, we use its name, followed by a whitespace
character (or more then one), followed by the function
parameter. Notice, that not only the value has changed (it has been
rounded), but its type as well. It is now `Int`, which represents
integer numbers. By preceding the function call expression with a name
and the equals sign, we have assigned the name to the result
value.

We can use the REPL to find out the signature of the `round` function
by entering its name alone.

      > round
      <function: round> : Float -> Int

As you could expect, the signature of the `round` function says that
the function takes a floating point number and returns an
integer. Let’s now add something to `x`.

      > x + 1.0
      
      Error in repl-temp-000.elm:

      Type mismatch between the following types on line 3, column 3 to 10:

              Int

              Float

          It is related to the following expression:

              x + 1.0

What is that? We got a compilation error. We tried to add `x` of type
`Int` to `1.0`, which is a floating-point number of type `Float`. Elm
does not allow adding an `Int` value to a `Float` value. We need to
turn `x` into a `Float` first. We can do it using the `toFloat`
function.

      > toFloat x
      8 : Float
      > toFloat x + 1.0
      9 : Float

Notice, that the function application binds more than the addition. In
other words, the above expression is equivalent to the following one:

      > (toFloat x) + 1.0
      9 : Float

Let’s give another value a name:

      > y = 4
      4 : number

Wait a moment, what is its type? Didn’t I write that type names must
always start with capital letters? Actually, the type of `y` is not
yet decided by the Elm compiler. It could be an integer value, but it
could also be a floating-point number. Elm does not want to decide too
early. We can add `y` to both an integer value and a floating-point
value:

      > x + y
      12 : Int
      > 1.0 + y
      5 : Float

In both cases we got results of different types. The first result is
of type `Int`, since we are adding a `number` to an `Int` value. Elm
decides to treat the number as an `Int`, and adds it to the other
`Int` value. In the other case, we are adding a `number` to a `Float`
value.  Elm decides to treat the number as a `Float` value, and adds
it to the other `Float` value. It is important to understand how Elm
treats numbers. Some Elm standard functions require parameters of type
`Int`, while other functions require parameters of type `Float`. If
you provide an argument of a wrong type, you will get a compilation
error. In that case you may need to use a conversion function, like
`round` or `toFloat`.

Besides, the `+`, `-` and `*` operators for addition, substracting and
multiplication, Elm provides two operators for division: `/` and
`//`. One is operating on `Float` values and the other one on `Int`
values. Let’s use the REPL to show their signatures. However, since
they are operators, and not functions with alphanumeric names, we need
to enclose them in parenthesis.

      > (/)
      <function> : Float -> Float -> Float
      > (//)
      <function> : Int -> Int -> Int

There is also the `%` operator, for taking a modulo of two numbers.

      > (%)
      <function> : Int -> Int -> Int

Here are examples of using those operators:

      > 10 / 3
      3.3333333333333335 : Float
      > 10 // 3
      3 : Int
      > 10 % 3
      1 : Int

To exit the REPL, use the `:exit` command.

      > :exit

Let’s now go back to our program displaying colorful bars. The program
consists of two files. The *[FibonacciBars.elm](FibonacciBars.elm)*
file defines the `main` function. But let’s first a look at the
*[Fibonacci.elm](Fibonacci.elm)* file, which defines the `Fibonacci`
module. Here is its content:

% Fibonacci.elm
      module Fibonacci where


      import List ((::), head, map2, reverse, tail)


      fibonacci : Int -> List Int
      fibonacci n =
          let fibonacci' n acc =
                  if n <= 2
                      then acc
                      else fibonacci' (n-1) ((head acc + (tail >> head) acc) :: acc)
          in
              fibonacci' n [1,1] |> reverse


      fibonacciWithIndexes : Int -> List (Int,Int)
      fibonacciWithIndexes n = map2 (,) [0..n] (fibonacci n)

It begins with a module declaration and an import statement. Since
`::` is an operator, it needs to be enclosed in parenthesis in the
import statement.

Next comes the `fibonacci` function for calculating the first `n`
Fibonacci numbers. Its type declaration specifies, that it takes one
argument of type `Int` and returns a list of integers `List Int`.

A list literal is a sequence of the list elements, enclosed in square
brackets, and separated by commas:

      > ["a","b","c","d"]
      ["a","b","c","d"] : List String

The `fibonacci` function uses the auxiliary `fibonacci'` function
(yes, the aphostrophe character `'` can be used in identifiers; by
convention identifiers ending with `'` are somehow related to similar
identifiers without the `'` character). The auxiliary function is
defined within the `let` expression, which has the following
structure:

      let <definitions> in <expression>

The result of the `let` expression is the value of the expression
defined after the `in` keyword, but that expression may use the
definitions placed between the `let` and `in` keywords. The
`fibonacci'` function is recursive — it calls itself. It has two
parameters: `n` and `acc`. It is initially called with the parameter
`n` equal to the number of Fibonacci numbers to be generated, and the
`[1,1]` list, which represents the first two numbers.

The body consists of an `if/then/else` expression, which is a
conditional expression with the following structure:

      if <condition> then <result1> else <result2>

The expression calculates its value in one of two distinct ways,
depending on the value of the condition placed between the `if` and
`then` keywords. The condition must evaluate to a boolean value, that
is a value of type `Bool`, which has two possibles values: `True` or
`False`.

If the conditional expression evaluates to `True`, the result of the
whole `if` expression is the result of evaluating the expression after
the `then` keyword. Otherwise, it is the result of evaluating the
expression after the `else` keyword. In our case, when `n` is less
then or equal to `2`, the `fibonacci'` function returns the value of
the accumulator `acc`. Otherwise, it calls itself with the new values
of `n` and `acc` calculated by the expression:

      (head acc + (tail >> head) acc) :: acc

The `head` function returns the first element of a list. The `tail`
function returns a list without its first element.

      > import List (..)
      > head [1,2,3,4]
      1 : number
      > tail [1,2,3,4]
      [2,3,4] : List number

The composition of `tail` and `head` returns the second element from
the list. Two functions can be composed in Elm using the `>>` or `<<`
operators. The `f (g x)` expression is equivalent to both `(g >> f) x`
and `(f << g) x` — both operators are equivalent, except for the order
of arguments.

      > head (tail [1,2,3,4])
      2 : number
      > (head << tail) [1,2,3,4]
      2 : number
      > (tail >> head) [1,2,3,4]
      2 : number

The next fibonacci number is calculated as the sum of the first and
the second element of the current list of results (the accumulator
`acc`) and is stored as the value `next`.

The new accumulator is calculated by prepending its current value with
the next value. The `::` operator yields a new list with its left
operand (an element) prepended to its right operand (a list).

      > 7 :: [1,2,3,4]
      [7,1,2,3,4] : List number

The new `n` value for the recursive call to `fibonacci'` is equal to
the old `n` decremeted by 1.

The result of calling the `fibonacci'` function is reversed using the
`reverse` function, since `fibonacci'` returns the list of numbers in
reversed order.

      > reverse [1,2,3,4]
      [4,3,2,1] : List number

We can test our `fibonacci` function in the REPL. First, we import
functions from the `Fibonacci` module.

      > import Fibonacci (..)

We can now call the `fibonacci` function.

      > fibonacci 10
      [1,1,2,3,5,8,13,21,34,55] : List Int

The bars displayed by our program have the width proportional to the
first ten Fibonacci numbers. But their colors are calculated
differently. They are selected from a list of seven colors based on
the index (position) of each number. We will need a function that
returns a list of pairs containing the Fibonacci numbers paired with
their positions. The `fibonacciWithIndexes` function calculates such
pairs.

      > fibonacciWithIndexes 10
      [(0,1),(1,1),(2,2),(3,3),(4,5),(5,8),(6,13),(7,21),(8,34),(9,55)] : [(Int, Int)]

A pair of values is enclosed in parenthesis and separated by a comma.

      > (1,"a")
      (1,"a") : (number, String)

Unlike a list, both values of a pair may have different types. A pair
is a 2-element tuple. We can also create tuples containing more
elements.

      > (1,"a",4.0)
      (1,"a",4) : (number, String, Float)
      > (1,"a",4.0,6)
      (1,"a",4,6) : (number, String, Float, number)

There is another way we can use to create tuples:

      > (,) 1 "a"
      (1,"a") : ( number, String )
      > (,,) 1 "a" 4.0
      (1,"a",4) : ( number, String, Float )
      > (,,,) 1 "a" 4.0 6
      (1,"a",4,6) : ( number, String, Float, number )

`(,)`, `(,,)` and `(,,,)` are actually functions returning tuples.

      > (,)
      <function> : a -> b -> ( a, b )
      > (,,)
      <function> : a -> b -> c -> ( a, b, c )
      > (,,,)
      <function> : a -> b -> c -> d -> ( a, b, c, d )

Those functions are *generic*, or *polimorphic* — the letters `a`,
`b`, `c` and `d` denote type parameters.

The list of consecutive numbers from 1 to 20 is generated by the
`[1..20]` expression.

      > [1..20]
      [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20] : List number

The `map2` function takes a two-argument function and two lists, and
returns a list of values calculated by applying the function to
consecutive elements of both lists, skipping the excessive elements of
the longer list.

      > map2 (+) [9,8,7,6,5] [4,4,7,7]
      [13,12,14,13] : List number
      > map2 (,) [9,8,7,6,5] [4,4,7,7]
      [(9,4),(8,4),(7,7),(6,7)] : List ( number, number )

Let’s now look at the contents of the
*[FibonacciBars.elm](FibonacciBars.elm)* file.

% FibonacciBars.elm
      module FibonacciBars where


      import Color (blue, brown, green, orange, purple, red, yellow)
      import Fibonacci (fibonacci, fibonacciWithIndexes)
      import Graphics.Collage (collage, filled, rect)
      import Graphics.Element (down, flow, right)
      import List (drop, head, length, map)
      import Text (asText)


      color n =
          let colors = [ red, orange, yellow, green, blue, purple, brown ]
          in
              drop (n % (length colors)) colors |> head


      bar (index, n) =
          flow right [
              collage (n*20) 20 [ filled (color index) (rect (toFloat n * 20) 20) ],
              asText n
          ]


      main = flow down <| map bar (fibonacciWithIndexes 10)

Again, we start with the module declaration. We then proceed by
importing both functions from the `Fibonacci` module and several
members from the standard library modules. Next, we have three
function declarations. Let’s analyze them one by one.

The `color` function returns one of seven colors based on the value of
its parameter. The seven colors are defined in the `let` expression,
in a list. The color names used are all available in the `Color`
module. The function calculates its result by dropping (using the
`drop` function) a number of elements from the list of colors, and
then taking the first element of the remaining list. The `drop` function
takes two arguments: the number of elements to be dropped and a list.

      > drop 2 [1,2,3,4,5]
      [3,4,5] : List number

The number of elements to be dropped is calculated by taking a modulo
of `n` and the length of the list of colors.

The `bar` function produces a colored rectangle together with a number
corresponding to its length. Since it is our first function which
draws something, let’s analyze it in detail, piece by piece.

The `rect (toFloat n * 20) 20` expression uses the `rect` function to
produce a rectangular “shape”. The `rect` function is defined in the
`Graphics.Collage` module. It takes two `Float` values representing
the width and height of the rectangle, and returns a value of type
`Shape`:

      rect : Float -> Float -> Shape

There are other functions creating shapes in the `Graphics.Collage`
module: `oval`, `circle`, `square`, `ngon`, `polygon`. The shape
created by the `rect` function is used as an argument to the `filled`
function in the following expression:

      filled (color index) (rect (toFloat n * 20) 20)

The `filled` function takes a color and a shape, and creates a value
of type `Form` representing the filled (colored) rectangle:

      filled : Color -> Shape -> Form

Other functions creating forms from shapes are available as well:
`textured`, `gradient`, `outlined`. The `Color` argument is calculated
by the `color` function, described above.

The next step is transforming a `Form` into an `Element`. This is the
job of the `collage` function:

      collage : Int -> Int -> List Form -> Element

The `collage` function takes two integer values and a list of forms
and turns them into an `Element`. The two integer values represent the
element width and height. The element created by `collage` in the
`bar` function creates an element which has the same size as the
rectangular form that it contains:

      collage (n*20) 20 [filled (color index) (rect (toFloat n * 20) 20)]

The `flow` function, defined in the `Graphics.Element` module, creates
an `Element` from a list of elements:

      flow : Direction -> List Element -> Element

The `Direction` parameter represents the direction of how the elements
from the list are placed in relation to each other. The following
functions return various `Direction` values: `left`, `right`, `up`,
`down`, `inward`, `outward`.

In the `bar` function, `flow` is used to create an element consisting
of the rectangular bar and a numeric value to its right (thus the
`right` function used for the `Direction` argument). The numeric value
is turned into an `Element` using the `asText` function. That function
can be used to turn any value into a value of type `Element` (not into
a value of type `Text`!):

      asText : a -> Element                                                                                                                                          

A small letter, like `a`, in the type signature denotes a type. Thus the
signature says, that `asText` turns any type `a` (whatever it is) into
an `Element`.

The `main` function uses the `flow` function as well, this time
putting the elements downwards. The second argument of the `flow`
function is preceded by the `<|` operator. That operator is basically
the function application opeator: `f <| a` is equivalend to `f a`,
except that `<|` has low binding priority. Therefore, it can be used
when we do not want to enclose some expression in parenthesis. Let’s
explain it on an example. The following two lines of code are
equivalent:

      flow down (map bar (fibonacciWithIndexes 10))
      flow down <| map bar (fibonacciWithIndexes 10)

They both represent a `flow` function call with two arguments. In the
first line, the second argument is enclosed in parentheses. In the
second line, since the `<|` operator has a low binding priority, the
expression to its right is calculated first and its result is used as
the argument to the `flow down` function (which represents a partial
application of the `flow` function).

The expression used as the second argument of the `flow` function
uses the `map` function, which has the following signature:

      > map
      <function: map> : (a -> b) -> List a -> List b

Notice, that we have used the REPL to verify the signature. We just
entered the name of the function, and REPL responded with its
signature.

The `map` function has two arguments. The first one is a one-argument
function — a function that takes values of some type `a` and returns
values of some type `b`. The second argument is a list of elements of
type `a`. The `map` function returns a list of elements of type `b` by
applying the function to each element of the input list. Here are
three examples of using the `map` function with various arguments.

      > map round [1.2,4.5,7.8,98]
      [1,5,8,98] : List Int
      > map fibonacci [3,4]
      [[1,1,2],[1,1,2,3]] : List (List Int)
      > map (\\x -> x+1) [1,2,3,4]
      [2,3,4,5] : List number

In the second example we used the `fibonacci` function, obtaining a
list of lists.

The third example introduces a new concept — an anonymous function. It
is a function without a name. It starts with the `\\` character, which
is followed by the name (or names) of function arguments. The
arguments are followed by the `->` arrow and the function body. In the
example, the anonymous function has one parameter `x`, and returns the
input value incremented by one.

In the present chapter, we have been able to perform some mathematical
calculations as well as show some graphics. However, our program is
static. In the [next](Chapter3MouseSignals.html) chapter we will show
how Elm lets write dynamic programs by means of signals.

"""
