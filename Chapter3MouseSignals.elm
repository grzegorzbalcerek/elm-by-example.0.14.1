-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Chapter2FibonacciBars" "toc" "Chapter4WindowSignals") Window.width

content = [markdown|

# Chapter 3 Mouse Signals

Our programs written so far were all static — they were just web pages
that did nothing once displayed. We are going to change that and make
pages dynamic by reacting to mouse events. Elm handles mouse events by
means of so called *signals*. Before describing what signals are,
let’s see them in action. Take a look at the
*[MouseSignals1.elm](MouseSignals1.elm)* program, presented below. A
working example is available [here](MouseSignals1.html).

    import Mouse
    main = lift asText Mouse.x

Try running that program and notice what happens as you move your
mouse pointer. The program shows the `x` coordinate of the mouse
pointer. The value changes as the pointer changes its position. How
does the program do that? The `Mouse.x` expression represents a signal
of mouse pointer *x* coordinates. A signal is a stream of values that
change over time. As the mouse cursor changes its position, the signal
value representing its coordinate changes as well. A signal is always
defined. It always has a value. The initial value of that particular
signal is 0 — you can notice that by observing the initial value shown
by the program just after it is started, but before the mouse pointer
moves. Once you move the mouse pointer, the *x* coordinate changes as
the pointer moves left or right. If you stop moving the mouse, the
signal “remembers” the last value.

The type of `Mouse.x` is `Signal Int`. That type indicates that it is
a signal of `Int` values. We cannot show it directly on the screen,
that is we cannot write `main = Mouse.x`, because such program would
not compile. All our programs so far assigned to `main` values of type
`Element`, but it is not the only possible type of the `main`
function. The other possible type is `Signal Element`. In other words,
Elm can display a static element, or a dynamic signal of elements.

We can use the `asText` function to turn an `Int` into an
`Element`. But what we need is to turn a `Signal Int` into a `Signal
Element`. How can we do that? By using the `lift` function! Here is
its signature:

      lift : (a -> b) -> Signal a -> Signal b

It takes a function and a signal, and applies the function to the
values “carried” by the signal. In other words, it applies the
function “inside” the signal, turning a signal of some values of type
`a` into a signal of values of type `b`.

Elm allows using functions as operators, that is in the infix
notation, by enclosing them in backsticks. We could thus define the
`main` function in an alternative way as follows:

      main = asText `lift` Mouse.x

However, Elm provides already the `<~` operator that is equivalent to
the `lift` function. Thus, we can also write:

      main = asText <~ Mouse.x

The next example — *[MouseSignals2.elm](MouseSignals2.elm)* — shows
two signals combined together and displayed as a pair of mouse pointer
coordinates. You can see it in action [here](MouseSignals2.html).

      import Mouse

      combine : a -> b -> Element
      combine a b = asText (a,b)

      main = lift2 combine Mouse.x Mouse.y

The `lift` function is not enough when we want to combine two signals
into one. Luckily Elm provides the `lift2` function that let us do
that. It has the following signature:

      lift2 : (a -> b -> c) -> Signal a -> Signal b -> Signal c

Our program merges the `Mouse.x` and `Mouse.y` (which obviously
represents the mouse pointer *y* coordinates) signals using the
`lift2` function. Elm also provides other similar functions: `lift3`,
`lift4`, …, up to `lift8`. However, it also provides an alternative
way of combining several signals into one. The last line of our
program could have been written as follows:

      main = combine <~ Mouse.x ~ Mouse.y

What is going on here? We already know the `<~` operator, which is
equivalent to the `lift` function. The `~` operator has the following
signature:

      (~) : Signal (a -> b) -> Signal a -> Signal b

Given a signal of functions from `a` to `b` and a signal of `a`
values, the operator returns a signal of `b` values. How is that
useful, you might ask? Let’s analyze our definition of the `main`
function. The `combine` function has the following signature:

      combine : a -> b -> Element

It is a two-argument function. The `<~` operator “uses” its first
argument, leaving the second one unaffected. Therefore, `combine <~
Mouse.x` expression has the type `Signal (b -> Element)`. The `~`
operator takes that value, and the signal of `b` values and returns a
`Signal Element`, which can be assigned to `main`.

To complete our presentation of mouse-related signals, let’s take a
look at yet another program — *[MouseSignals3.elm](MouseSignals3.elm)*
(the working program is available [here](MouseSignals3.html)):

      import Mouse

      showsignals a b c d e f g h =
       flow down <| map plainText
       [ "Mouse.position: " ++ show a
       , "Mouse.x: " ++ show b
       , "Mouse.y: " ++ show c
       , "Mouse.clicks: " ++ show d
       , "Mouse.isDown: " ++ show e
       , "count Mouse.isDown: " ++ show f
       , "sampleOn Mouse.clicks Mouse.position: " ++ show g
       , "sampleOn Mouse.isDown Mouse.position: " ++ show h
       ]

      main = showsignals <~ Mouse.position
                          ~ Mouse.x
                          ~ Mouse.y
                          ~ Mouse.clicks
                          ~ Mouse.isDown
                          ~ count Mouse.isDown
                          ~ sampleOn Mouse.clicks Mouse.position
                          ~ sampleOn Mouse.isDown Mouse.position

The `showsignals` function presents a list of several (eight) values
with descriptions. Each item on that list represents a signal. Signal
values are “feeded” into the function using the `<~` and `~`
operators.

The `show` function used as the argument of the `map` function,
converts any value to a `String`.

      show : a -> String

The first signal, `Mouse.position`, represents the mouse pointer
coordinates as a pair of values. We have already seen the `Mouse.x`
and `Mouse.y` signals.

The `Mouse.clicks()` signal is a signal of `()` values. The `()` value
is both a type and the only value of that type. It is called unit.

      > ()
      () : ()

The `Mouse.clicks` signal generates a new event for every mouse
click (to be more precise, the event corresponds to the moment of when
the mouse button is released).

The `Mouse.isDown` signal is a signal of boolean values indicating
whether the mouse button is being pressed.

The next signal uses the `count` function which converts a signal into
a signal of `Int` values indicating how many events from the original
signal have occurred.

The last two signals use the `sampleOn` function, which samples the
second signal whenever the first signal changes its value.

      sampleOn : Signal a -> Signal b -> Signal b

Thus the last but one signal is a stream of mouse positions from the
moments of when the mouse button was released, while the last signal
represents mouse positions from the moments of both when the mouse
button was pressed and relesed.

The `count` and `sampleOn` functions are defined in the
[`Signal`](http://library.elm-lang.org/catalog/elm-lang-Elm/0.12.3/Signal)
module. The module provides various functions for signal manipulations.

The [next](Chapter4WindowSignals.html) chapter presents signals
defined in the `Window` module.

|]
