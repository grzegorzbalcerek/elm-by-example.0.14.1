-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Chapter1HelloWorld" "toc" "Chapter3MouseSignals") Window.width

content = [markdown|

# Chapter 2 Fibonacci Bars

The *[FibonacciBars.elm](FibonacciBars.elm)* example program displays a pile of
rectangles. Their widths correspond to the values of the first
Fibonacci numbers. You can see the bars [here](FibonacciBars.html).

Before explaining how that program is written, let’s first make a
small detour, and introduce the REPL (Read Eval Print Loop) tool, that
Elm — like many other functional languages — provides.  The `elm-repl`
command starts it, like so:

      $ elm-repl
      Elm REPL 0.2.2 <https://github.com/elm-lang/elm-repl#elm-repl>
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
value. Let’s now add something to `x`.

      > x + 1.0
      [1 of 1] Compiling Repl                ( repl-temp-000.elm )
      Type error on line 3, column 3 to 10:
              x + 1.0

         Expected Type: Int
           Actual Type: Float

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

Let’s now go back to our program displaying colorful bars. The program
consists of two files. The *[FibonacciBars.elm](FibonacciBars.elm)*
file defines the `main` function. But let’s first a look at the
*[Fibonacci.elm](Fibonacci.elm)* file, which defines the `Fibonacci`
module. Here is its content:

      module Fibonacci where

      fibonacci : Int -> [Int]
      fibonacci n =
        let fibonacci' n acc =
              if n <= 2
              then acc
              else fibonacci' (n-1) ((head acc + (head . tail) acc) :: acc)
        in fibonacci' n [1,1] |> reverse

      fibonacciWithIndexes : Int -> [(Int,Int)]
      fibonacciWithIndexes n = zip [0..20] (fibonacci n)

It begins with a module declaration. The declaration consists of the
`module` keyword followed by the module name and the `where` keyword,
which marks the beginning of the module body.

Next comes the `fibonacci` function for calculating the first `n`
Fibonacci numbers. Its type declaration specifies, that it takes one
argument and returns a list of integers.

In Elm, the list type is specified by enclosing the type of the list
elements in brackets, so for example a list of integers is denoted as
`[Int]`. List elements are also enclosed in square brackets, and are
separated by commas:

      > ["a","b","c","d"]
      ["a","b","c","d"] : [String]

The `fibonacci` function uses the auxiliary `fibonacci'` function
(yes, the aphostrophe character `'` can be used in identifiers; by
convention identifiers ending with `'` are somehow related to similar
identifiers without the `'` character). The auxiliary function is
defined withing the `let` expression, which has the following
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

In our case the condition verifies whether the value `n` is less then
or equal to `0`. If the conditional expression evaluates to `True`,
the result of the whole `if` expression is the result of evaluating
the expression after the `then` keyword. Otherwise, it is the result
of evaluating the expression after the `else` keyword. In our case,
when `n` is less then or equal to `2`, the `fibonacci'` function
returns the value of the accumulator `acc`. Otherwise, it calls itself
with the new values of `n` and `acc`. The new `n` is equal to the old
`n` decremeted by 1. The new accumulator is prepended with a new
number, which is the sum of the first two numbers from the current
accumulator value.

The `head` function returns the first element of a list. The `tail`
function returns a list without its first element.

      > head [1,2,3,4]
      1 : number
      > tail [1,2,3,4]
      [2,3,4] : [number]

The composition of `tail` and `head` returns the second element from
the list. Two functions can be composed in Elm using the `.` (dot)
operator. Thus `(f . g) x` is equivalent to `f (g x)`.

      > head (tail [1,2,3,4])
      2 : number
      > (head . tail) [1,2,3,4]
      2 : number

The `::` operator yields a new list with its left operand (an element)
prepended to its right operand (a list).

      > 7 :: [1,2,3,4]
      [7,1,2,3,4] : [number]

The result of calling the `fibonacci'` function is reversed using the
`reverse` function, since `fibonacci'` returns the list of numbers in
reversed order.

      > reverse [1,2,3,4]
      [4,3,2,1] : [number]

We can test our `fibonacci` function in the REPL. But before calling
the function, we import all functions from the `Fibonacci` module.

      > import Fibonacci

The import statement informs the REPL, that we want to import the
`Fibonacci` module. We can now reference the `fibonacci` function from
that module by prefixing it with the module name:

      > Fibonacci.fibonacci 10
      [1,1,2,3,5,8,13,21,34,55] : [Int]

Beside importing the module, we can also “open” it, which introduces
certain module functions to the current namespace. We do this by
following the module name with a list of imported values enclosed in
parentheses. Alternatively, we can replace the list with two dot
characters, thus imporing everything that the module exported.

      > import Fibonacci (..)

We can now directly reference the function without prefixing it with
the module name.

      > fibonacci 10
      [1,1,2,3,5,8,13,21,34,55] : [Int]

The bars displayed by our program have the width proportional to the
first ten Fibonacci numbers. But their colors are calculated
differently. They are selected from a list of seven colors based on
the index (position) of each number. We will need a function that
returns a list of pairs containing the Fibonacci numbers paired with
their positions. The `fibonacciWithIndexes` function calculates such
pairs by zipping (using the `zip` function) a list of consecutive
numbers with the list of ten first Fibonacci numbers calculated by
the `fibonacci 10` call.

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

The list of consecutive numbers from 1 to 20 is generated by the `[1..20]` expression.

      > [1..20]
      [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20] : [number]

The `zip` function takes two lists, and returns a list of pairs
consisting of consecutive elements from both lists.

      > zip ["a","b","c","d"] [1..20]
      [("a",1),("b",2),("c",3),("d",4)] : [(String, number)]

Notice, that the first list is shorter than the second one. That is
fine, since `zip` will only produce a list as long as the shorter of its
arguments.

Let’s now look at the contents of the *[FibonacciBars.elm](FibonacciBars.elm)* file.

      module FibonacciBars where

      import Fibonacci (fibonacci,fibonacciWithIndexes)

      color n =
        let colors = [red,orange,yellow,green,blue,purple,brown]
        in drop (n `mod` (length colors)) colors |> head

      bar (index,n) = flow right [
        collage (n*20) 20 [filled (color index) (rect (toFloat n * 20) 20)],
        asText n]

      main = flow down <| map bar (fibonacciWithIndexes 10)

Again, we start with the module declaration. We then proceed by
importing both functions from the `Fibonacci` module. We explicitly
enumerate, in parenthesis, the functions to be imported. Next, we have
three function declarations. Let’s analyze them one by one.

The `color` function returns one of seven colors based on the value of
its parameter. The seven colors are defined in the `let` expression,
in a list. The color names used are all available by default in Elm
programs. The function calculates its result by dropping (using the
`drop` function) a number of elements from the list of colors, and
then taking the first element of the remaining list. The drop function
takes two arguments: the number of elements to be dropped and a list.

      > drop 2 [1,2,3,4,5]
      [3,4,5] : [number]

The number of elements to be dropped is calculated by taking a modulo
of `n` and the length of the list of colors. The `mod` function
calculates the modulo of two numbers:

      > mod 10 3
      1 : Int

The `color` function uses `mod` in the “infix” notation. In order to
use a regular, two-argument function in the “infix” notation, we
enclose the function name in backsticks and place it between both
operands.

      > 10 `mod` 3
      1 : Int

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
module: `oval`, `circle`, `square`, `ngon`, `polygon`. The functions
of that module are imported by default in Elm programs, thus are
accessible without additional imports.

The shape created by the `rect` function is used as an argument to the
`filled` function in the following expression:

      filled (color index) (rect (toFloat n * 20) 20)

The `filled` function takes a color and a shape, and creates a value
of type `Form` representing the filled (colored) rectangle:

      filled : Color -> Shape -> Form

Other functions creating forms from shapes are available as well:
`textured`, `gradient`, `outlined`. The `Color` argument is calculated
by the `color` function, described above. You may remember, that we
used a function called `color` in the previous chapter. By defining
our own `color` function, we have “hidden” the `color` function
provided by default by Elm.

The next step is transforming a `Form` into an `Element`. This is the
job of the `collage` function:

      collage : Int -> Int -> [Form] -> Element

The `collage` function takes two integer values and a list of forms
and turns them into an `Element`. The two integer values represent the
element width and height. The element created by `collage` in the
`bar` function creates an element which has the same size as the
rectangular form that it contains:

      collage (n*20) 20 [filled (color index) (rect (toFloat n * 20) 20)]

The `flow` function, defined in the `Graphics.Element` module, creates
an `Element` from a list of elements:

      flow : Direction -> [Element] -> Element

The `Direction` parameter represents the direction of how the elements
from the list are placed in relation to each other. The following
functions return various `Direction` values: `left`, `right`, `up`,
`down`, `inward`, `outward`.

In the `bar` function, `flow` is used to create an element
consisting of the rectangular bar and a numeric value to its right
(thus the `right` function used for the `Direction` argument). The
numeric value is turned into an `Element` using the `asText`
function. That function can be used to turn any value into an element:

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
      <function: map> : (a -> b) -> [a] -> [b]

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
      [1,5,8,98] : [Int]
      > map fibonacci [3,4]
      [[1,1,2],[1,1,2,3]] : [[Int]]
      > map (\x -> x+1) [1,2,3,4]
      [2,3,4,5] : [number]

In the second example we used the `fibonacci` function, obtaining a
list of lists.

The third example introduces a new concept — an anonymous function. It
is a function without a name. It starts with the `\` character, which
is followed by the name (or names) of function arguments. The
arguments are followed by the `->` arrow and the function body. In the
example, the anonymous function has one parameter `x`, and returns the
input value incremented by one.

In the present chapter, we have been able to perform some mathematical
calculations as well as show some graphics. However, our program is
static. In the [next](Chapter3MouseSignals.html) chapter we will show
how Elm lets write dynamic programs by means of signals.

|]
