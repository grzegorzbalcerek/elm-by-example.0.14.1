-- -*- coding: utf-8; -*-

import Lib (..)
import Window
import Signal
import Markdown

main = Signal.map (pageTemplate [content] "Chapter2FibonacciBars" "toc" "Chapter4WindowSignals") Window.width

content = Markdown.toElement """

# Chapter 3 Mouse Signals

Our programs written so far were all static — they were just web pages
that did nothing once displayed. We are going to change that and make
pages dynamic by reacting to mouse events. Elm handles mouse events by
means of so called *signals*. Before describing what signals are,
let’s see them in action. Take a look at the
*[MouseSignals1.elm](MouseSignals1.elm)* program, presented below. A
working example is available [here](MouseSignals1.html).

% MouseSignals1.elm
      module MouseSignals1 where


      import Mouse
      import Signal (map)
      import Text (asText)


      main = map asText Mouse.x

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
function. Another possible type is `Signal Element`. In other words
Elm can display a dynamic signal of elements.

We can use the `asText` function to turn an `Int` into an
`Element`. But what we need is to turn a `Signal Int` into a `Signal
Element`. How can we do that? By using the `map` function from the
`Signal` module!  Here is its signature:

      map : (a -> b) -> Signal a -> Signal b

It takes a function and a signal, and applies the function to the
values “carried” by the signal. In other words, it applies the
function “inside” the signal, turning a signal of some values of type
`a` into a signal of values of type `b`.

Elm allows using functions as operators, that is in the infix
notation, by enclosing them in backsticks. We could thus define the
`main` function in an alternative way as follows:

      main = asText `map` Mouse.x

However, Elm provides already the `<~` operator that is equivalent to
the `map` function. Thus, we can also write (provided we also import
the `<~` operator from the `Signal` module):

      main = asText <~ Mouse.x

The next example — *[MouseSignals2.elm](MouseSignals2.elm)* — shows
two signals combined together and displayed as a pair of mouse pointer
coordinates. You can see it in action [here](MouseSignals2.html).

% MouseSignals2.elm
      module MouseSignals2 where


      import Graphics.Element (Element)
      import Mouse
      import Signal (map2)
      import Text (asText)


      combine : a -> b -> Element
      combine a b = asText (a,b)


      main = map2 combine Mouse.x Mouse.y

The `map` function is not enough when we want to combine two signals
into one. Luckily Elm provides the `map2` function that let us do
that. It has the following signature:

      map2 : (a -> b -> c) -> Signal a -> Signal b -> Signal c

Our program merges the `Mouse.x` and `Mouse.y` (which obviously
represents the mouse pointer *y* coordinates) signals using the `map2`
function. Elm also provides other similar functions: `map3`, `map4`
and `map5`. However, it also provides an alternative way of combining
several signals into one. The last line of our program could have been
written as follows (again, importing `~` would be necessary):

      main = combine <~ Mouse.x ~ Mouse.y

What is going on here? We already know the `<~` operator, which is
equivalent to the `map` function. The `~` operator has the following
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

% MouseSignals3.elm
      module MouseSignals3 where


      import Graphics.Element (down, flow)
      import List (map)
      import Mouse
      import Signal ((~), (<~), sampleOn)
      import Text (plainText)


      showsignals a b c d e f g =
          flow
              down
              <|
                  map
                      plainText
                      [
                          "Mouse.position: " ++ toString a,
                          "Mouse.x: " ++ toString b,
                          "Mouse.y: " ++ toString c,
                          "Mouse.clicks: " ++ toString d,
                          "Mouse.isDown: " ++ toString e,
                          "sampleOn Mouse.clicks Mouse.position: " ++ toString f,
                          "sampleOn Mouse.isDown Mouse.position: " ++ toString g
                      ]


      main =
          showsignals
              <~ Mouse.position
              ~ Mouse.x
              ~ Mouse.y
              ~ Mouse.clicks
              ~ Mouse.isDown
              ~ sampleOn Mouse.clicks Mouse.position
              ~ sampleOn Mouse.isDown Mouse.position

The `showsignals` function presents a list of several values with
descriptions. Each item on that list represents a signal. Signal
values are “feeded” into the function using the `<~` and `~`
operators.

The `toString` function used as the argument of the `map` function,
converts any value to a `String`.

      toString : a -> String

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

The last two signals use the `sampleOn` function, which samples the
second signal whenever the first signal changes its value.

      sampleOn : Signal a -> Signal b -> Signal b

Thus the last but one signal is a stream of mouse positions from the
moments of when the mouse button was released, while the last signal
represents mouse positions from the moments of both when the mouse
button was pressed and relesed.

The [next](Chapter4WindowSignals.html) chapter presents signals
defined in the `Window` module.

"""
