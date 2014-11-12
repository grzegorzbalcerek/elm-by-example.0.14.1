-- -*- coding: utf-8; -*-

import Lib (..)
import Window

content w = pageTemplate [content1,container w 200 middle picture1,content2,container w 100 middle picture2,content3] "Chapter9Circles" "toc" "Chapter11KeyboardSignals" w
main = lift content Window.width

content1 = [markdown|

# Chapter 10 Calculator

The *[Calculator.elm](Calculator.elm)* program implements a simple
calculator that can be used to perform arithmetic operations. You can
run it [here](Calculator.html). To use the calculator, click its
buttons using your mouse.

The code is divided into three modules:

 * `CalculatorModel`
 * `CalculatorView`
 * `Calculator`

We start our analysis with the `CalculatorModel` module defined in the
*[CalculatorModel.elm](CalculatorModel.elm)* file. The module starts with
thdeclaration and a list of imports:

% CalculatorModel.elm
      module CalculatorModel where


      import Char
      import Set
      import String
      import Maybe (maybe)

The following line defines a new data type called `ButtonType`:
% CalculatorModel.elm

      data ButtonType = Regular | Large

The definition starts with the `data` keyword followed by the type
name, the equals sign and the type definition. The `data` keyword is
used for defining so called Algebraic Data Types (ADT). Such types
consist of a number of alternatives which are separated with the `|`
character. In our case, we have two alternatives: `Regular` and
`Large`.

Our data type is very simple. However, using the `data` keyword, it is
possible to define more complex data types as well. For example, the
following data type represents a list of integers:

      data ListOfInts = Nil | Cons Int ListOfInts

The alternatives are sometimes called *type constructors*. Our
`ListOfInts` data type defines two of them. The first one is called
`Nil` and represents the empty list. The other one is more
interesting. Its name is `Cons` and it has two arguments, which are
actually type names. The first one is `Int` and the second one is
`ListOfTypes`, which is the name of the type being defined! This means
that we have a recursive definition here. What this definition tells
us, is that a list is either and empty list (`Nil`) or a non-empty
list (`Cons`) consisting of an `Int` value and another list.

As an example, let us create a two-element list, containing the values
1 and 2:

      > Cons 1 (Cons 2 Nil)
      Cons 1 (Cons 2 Nil) : ListOfInts

A data type defined with the `data` keyword can have type
parameters. The following data type represents lists of elements of an
arbitrary type. The type of the list elements is represeted by the `a`
parameter:

      data GenericList a = Nil | Cons a (GenericList a)

Here we create a list of characters containing the characters ‘a’, ‘b’
and ‘c’:

      > Cons 'a' (Cons 'b' (Cons 'c' Nil))
      Cons 'a' (Cons 'b' (Cons 'c' Nil)) : GenericList Char

Let’s now go back to the `CalculatorModel` module. The `buttonSize`
function accepts a value of type `ButtonType` as argument and returns
an integer number:
% CalculatorModel.elm

      buttonSize : ButtonType -> Int
      buttonSize size =
          case size of
              Regular -> 60
              Large -> 120

We use here the `case` expression, which let us *pattern match* on the
individual type constructors (or, more generally, on *patterns*). Elm
tries to match the value placed between the `case` and `of` keywords
(`size` in our case) against the patterns defined after the `of`
keyword. Each pattern is followed by the `->` arrow and the expression
which becomes the result of the whole `case` expression if the
corresponding pattern is matched. The patterns are tried one by one,
and once any of them matches, the others are skipped.

      > import CalculatorView (..)
      > buttonSize Regular
      60 : Int
      > buttonSize Large
      120 : Int

Since the type constructors of the `ButtonType` type are very simple,
the patterns used in the `buttonSize` function are also simple — they
exactly correspond to the type constructors. As another example, let
us analyze the following function, which calculates the length of a
`GenericList`:

      listSize : GenericList a -> Int
      listSize lst =
          case lst of
              Nil -> 0
              Cons _ tail -> 1 + listSize tail

If the `lst` list is empty, the first pattern matches, and the
function returns 0. The second pattern is more interesting. It
consists of the name of the type constructor (`Cons`) followed by the
`_` character and the `tail` symbol. The `_` character matches any
value, and it is used when we are not interested in the value being
matched. The `tail` symbol is a variable, that will acquire the value
of the second parameter of the `Cons` value. So, for example, if `lst`
is `(Cons 4 (Cons 6 Nil))`, then `tail` will have the value of `Cons 6
Nil` assigned to it. When the second pattern is matched, the function
returns 1 plus the result of a recursive call to itself with the
`tail` value as argument.

      > listSize Nil
      0 : Int
      > listSize (Cons 4 (Cons 6 Nil))
      2 : Int

The `CalculatorModel` module defines a record type representing the
calculator state.
% CalculatorModel.elm

      type CalculatorState = {
               input: String,
               operator: String,
               number: Float
           }

The calculator needs to remember three things, represented by three
state members:

  * `input` is the number that the user enters into the calculator by
    clicking on the number buttons and the dot button
  * `operator` is one of the four arithmetic operations selected by the user
  * `number` is the result of previous computations (or zero at the beginning)

The exact rules of how the calculator works are implemented in the
`step` function, which takes as arguments the current calculator state
and the button clicked by the user and calculates the new state.
% CalculatorModel.elm

      step : String -> CalculatorState -> CalculatorState
      step btn state =
          if  | btn == "C" -> initialState
              | btn == "CE" -> { state | input <- "0" }
              | state.input == "" && isOper btn -> { state | operator <- btn }
              | isOper btn -> {
                    number = calculate state.number state.operator state.input,
                    operator = btn,
                    input = ""
                }
              | otherwise ->
                    { state |
                        input <-
                             if  | (state.input == "" || state.input == "0") && btn == "." -> "0."
                                 | state.input == "" || state.input == "0" -> btn
                                 | String.length state.input >= 18 -> state.input
                                 | btn == "." && any (\c -> c == '.') (String.toList state.input) -> state.input
                                 | otherwise -> state.input ++ btn }

The `step` function uses an alternative form of the `if`
expression. The `if` keyword is followed by a number of conditions and
expressions. Each condition is preceded by the `|` character. After
each condition there is an arrow `->` followed by an expression. The
`if` expression verifies each condition, one by one, until the first
one that evaluates to `True`. The expression that follows that
condition becomes the result of the whole `if` expression. The last
condition in our `if` expressions is `otherwise`, which evaluates to
`True`, thus making that condition the “catch all” clause.

The following two forms of the `if` expression are thus equivalent:

      if <condition>
      then <expression1>
      else <expression2>

      if | <condition> -> <expression1>
         | otherwise -> <expression2>

The `step` function works as follows. If the user selects the *C*
button, the initial state, calculated by the `initialState` function,
is returned.
% CalculatorModel.elm

      initialState = { number = 0.0, input = "", operator = "" }

If the user selects the *CE* button, then `input` is set to zero, and
the previously entered input is forgotten. If the user selects one of
the operators, as verified by the `isOper` function, and if there was
no previous input (the `input` is equal to an empty string), then the
operator is saved in the new state. The syntax for updating the
`operator` member looks as follows:

      { state | operator <- btn }

The `state` represents the old state. The `operator` is the name of
the member being updated. The `btn` is the new value to be assigned to
the `operator` member. The whole expression does not change the
`state` value, but it returns a new value, similar to `state` but with
the `operator` member updated.

The `isOper` function is defined as follows:
% CalculatorModel.elm

      isOper : String -> Bool
      isOper btn = Set.member btn (Set.fromList ["+","-","*","/","="])

The function uses two functions from the `Set` module. The
`Set.fromList` function creates a set from a list. The `Set.member`
function verifies if its first argument belongs to the set represented
by the second argument.

If the user selected one of the operators, but there is already an
input value present in the `input` field, then a whole new state is
calculated and returned as follows:

  * the value of the `number` member is calculated by the `calculate`
    function based on the old state
  * the value of the operator clicked by the user is stored in the `operator` member
  * the `input` is reset to an empty string

The `calculate` function is defined as follows:
% CalculatorModel.elm

      calculate : Float -> String -> String -> Float
      calculate number op input =
          let number2 = maybe 0.0 identity (String.toFloat input)
          in
              if  | op == "+" -> number + number2
                  | op == "-" -> number - number2
                  | op == "*" -> number * number2
                  | op == "/" -> number / number2
                  | otherwise ->  number2

It first converts the value of the `input` member to a floating point
number using the `String.toFloat` function. That function does not
return a `Float` value however, as showed by the repl:

      > String.toFloat
      <function: toFloat> : String -> Maybe Float

The return value is of type `Maybe Float`. `Maybe` is an algebraic
data type defined in the `Maybe` module as follows:

      data Maybe a = Just a | Nothing

Thus the `String.toFloat` function may return one of two values: `Just
Float` or `Nothing`. The first one is returned if the conversion
succeeds, the second one otherwise. The `calculate` function could
pattern match on the result using a `case` expression, but it does not
have to do it, since the `Maybe` module provides the `maybe` function
which already implements the pattern matching on `Maybe` values. The
function expects three arguments:

      > import Maybe
      > Maybe.maybe
      <function> : a -> (b -> a) -> Maybe b -> a

The first one is a value to be returned if the third argument is
`Nothing`. The second is a function, which is applied to the value
contained in the `Just` constructor. The result of that function
application becomes the result of the `maybe` function call.

The `calculate` function uses the `id` function, which just returns its
argument, as the second argument to `maybe`, since it only wants to
exctract the `Just` value without transforming it. The `0.0` value is
used as a fallback in case the conversion fails.

After converting the input value to `Float`, the `calculate` function
performs the appropriate (based on the value of the `operator` member)
arithmetic operation on the value of the `number` mamber, and the
result of converting the input to `Float`.

Finally (going back to the `step` function), if the user selects
something else, which must be either a digit or a dot, then the
`input` member is updated as follows:

  * if the current input is empty or “0” and the dot is selected, the input is set to be “0.”
  * if the current input is empty or “0”, the input is set to be equal to the label of the selected button
  * if the current input has length equal or greater than 18, no new data is appended to the input
  * if the current input contains a dot already, and the dot is selected, the input string remains unchanged
  * otherwise, the label of the selected button is appended to the input string

There is one more function in the `CalculatorModel` module. The
`showState` function converts the state to a string to be shown in the
calculator display. The result is the value of the `input` member,
unless it is empty, in which case the value of the `number` member is
converted to a string and returned.
% CalculatorModel.elm

      showState : CalculatorState -> String
      showState {number,input} =
          if input == ""
              then show number
              else input

We can now turn our analysis to the `CalculatorView` module, which is
defined in the *[CalculatorView.elm](CalculatorView.elm)* file. Its
definition starts as follows:

% CalculatorView.elm
      module CalculatorView where


      import CalculatorModel (..)
      import Graphics.Input (Input, input, clickable)
      import Text

After the imports, the `makeButton` function is defined. That function
creates an element representing a calculator button. It takes a string
that will be the button label, and a `ButtonType` value as arguments.
% CalculatorView.elm

      makeButton : String -> ButtonType -> Element
      makeButton label size =
          let xSize = buttonSize size
              buttonColor = rgb 199 235 243
          in
              collage
                  xSize
                  60
                  [
                      filled buttonColor <| rect (toFloat (xSize-8)) 52,
                      outlined { defaultLine | width <- 2, cap <- Padded }
                          <| rect (toFloat (xSize-8)) 52,
                      Text.toText label |> Text.height 30 |> Text.bold |> Text.centered |> toForm
                  ]

A button is composed of a filled rectangle, which forms the button
background color, an outlined rectangle forming the button border, and
a text. The `buttonSize` function from the `CalculatorModel` module is
used for calculating the horizontal size of the button. The auxiliary
`buttonColor` function returns the button color.

The `outlined` function expects in its first argument a value of type
`LineStyle`, which is a record type defined in the `Graphics.Collage`
module. The record contains the following members:

  * `color `of type `Color` — represents the line color
  * `width` of type `Float` — represents the line width in pixels
  * `cap` of type `LineCap` — represents the shape of line ends
  * `join` of type `LineJoin` — represents the shape of line joins
  * `dashing` of type `[Int}` — represents the dashing pattern
  * `dashOffset` of type `Int` — represents the dashing offset

You do not have to construct the whole record yourself. The
`defaultLine` function returns a default line style. You can use it
and modify certain members. For example, to have a default line, but
with the `width` set to 5, you can use the expression:

      { defaultLine | width <- 5 }

The `cap` member can be set to values `Flat` (default), `Round` or
`Padded`. The `join` member can be set to `Smooth`, `Clipped` or
`Sharp Float` (`Sharp 10` is the default). The following figure
illustrates the various line caps and joins:

|]

picture1 = let
    myShape = path [(-50,-50),(50,-50),(50,50),(0,0)]
    dot = filled red (circle 4)
    dot50 = dot |> move (50,50)
    line1 = { defaultLine | width <- 20,
                            cap <- Flat,
                            join <- Sharp 10 }
    line2 = { defaultLine | width <- 20,
                            cap <- Round,
                            join <- Smooth }
    line3 = { defaultLine | width <- 20,
                            cap <- Padded,
                            join <- Clipped }
  in [line1,line2,line3] |>
     map (\line -> traced line myShape) |>
     map (\form -> collage 170 170 [form,dot,dot50]) |>
     flow right

content2 = [markdown|

The first one has the `cap` set to `Flat` and the `join` set to
`Sharp 10`. The second one has the `cap` set to `Flat` and the `join`
set to `Smooth`.  The last one has the `cap` set to `Padded` and the
`join` set to `Clipped`.  The red dots indicate the position of one of
joins and one of caps.

The following figure illustrates the `dashing`. It presents three
lines. The first one has `dashing` set to `[]` (the default). The
second, to `[40,10]` and the third one to `[40,10,40]`.

|]

picture2 = let
  myShape = path [(-200,0),(200,0)]
  line1 = { defaultLine | width <- 3,
                          dashing <- [],
                          dashOffset <- 0 }
  line2 = { defaultLine | width <- 3,
                          dashing <- [40,10],
                          dashOffset <- 20 }
  line3 = { defaultLine | width <- 3,
                          dashing <- [10,40,10],
                          dashOffset <- 0 }
 in [line1,line2,line3] |>
     map (\line -> traced line myShape) |>
     map (\form -> collage 420 30 [form]) |>
     flow down

content3 = [markdown|

The *CalculatorViewTest1.elm* program (showed below) can be used to
visually test the `makeButton` function (try it
[here](CalculatorViewTest1.html)).

% CalculatorViewTest1.elm
      import CalculatorModel (..)
      import CalculatorView (..)


      main = makeButton "test" Large

Being able to create a button is not enough for our purposes. What we
need is a *clickable* button. A button, which will have some kind of
signal associated with it. We create such buttons using the
`makeButtonAndSignal` function:
% CalculatorView.elm

      makeButtonAndSignal : String -> ButtonType -> (Element, Signal String)
      makeButtonAndSignal label btnSize =
          let buttonInput = input label
              button = makeButton label btnSize
              clickableButton = clickable buttonInput.handle label button
          in
              (clickableButton, buttonInput.signal)

To create a clickable element, we first need an `Input` value. The
`Input` type is defined in the `Graphics.Input` module and is a record
with two members: `handle` and `signal`. To create such a value, we
use the `input` function:

      input : a -> Input a

In our function we use a `String` value as the argument to the `input`
function. Thus the `buttonInput` value has the `Input String`
type. The next step is to take a regular element and pass it as an
argument to the `clickable` method, which has the following signature:

      clickable : Handle a -> a -> Element -> Element

The first argument is a handle, that can be obtained from the `handle`
member of the `Input` value. The second one is the value of the events
that will be emmitted by the signal associated with the clickable
element. Finally, the third argument is the regular element (created
using the `makeButton` function in our case). The function returns an
“enchanced” element (`clickableButton` in our function). Once we have
it, the `signal` member of the `Input` value represents the signal of
events. Our `makeButtonAndSignal` function returns a pair of values:
the clickable button and the signal.

Next, we use the `makeButtonAndSignal` function to create all the
calculator buttons and the associated signals.
% CalculatorView.elm

      (button0, button0Signal) = makeButtonAndSignal "0" Regular
      (button1, button1Signal) = makeButtonAndSignal "1" Regular
      (button2, button2Signal) = makeButtonAndSignal "2" Regular
      (button3, button3Signal) = makeButtonAndSignal "3" Regular
      (button4, button4Signal) = makeButtonAndSignal "4" Regular
      (button5, button5Signal) = makeButtonAndSignal "5" Regular
      (button6, button6Signal) = makeButtonAndSignal "6" Regular
      (button7, button7Signal) = makeButtonAndSignal "7" Regular
      (button8, button8Signal) = makeButtonAndSignal "8" Regular
      (button9, button9Signal) = makeButtonAndSignal "9" Regular
      (buttonEq, buttonEqSignal) = makeButtonAndSignal "=" Regular
      (buttonPlus, buttonPlusSignal) = makeButtonAndSignal "+" Regular
      (buttonMinus, buttonMinusSignal) = makeButtonAndSignal "-" Regular
      (buttonDiv, buttonDivSignal) = makeButtonAndSignal "/" Regular
      (buttonMult, buttonMultSignal) = makeButtonAndSignal "*" Regular
      (buttonDot, buttonDotSignal) = makeButtonAndSignal "." Regular
      (buttonC, buttonCSignal) = makeButtonAndSignal "C" Large
      (buttonCE, buttonCESignal) = makeButtonAndSignal "CE" Large

Besides the buttons, the calculator needs a display where the results
of the calculation as well as the user input will be shown. The
`display` function creates it.
% CalculatorView.elm

      display : CalculatorState -> Element
      display state =
          collage 240 60 [
             outlined { defaultLine | width <- 2, cap <- Padded } <| rect 232 50,
             toForm (container 220 50 midRight (plainText <| showState state))
          ]

It takes the calculator state as argument and uses the `showState`
function to present it to the user.

Finally, the `view` function combines the components and draws the calculator.
% CalculatorView.elm

      view : CalculatorState -> (Int, Int) -> Element
      view value (w, h) =
          container
              w
              h
              middle
              <| layers
                  [
                      collage
                          250
                          370
                          [
                              rect
                                  248
                                  368
                                  |> outlined { defaultLine | width <- 3, cap <- Padded }
                          ],
                      flow
                          down
                          [
                              spacer 250 5,
                              flow right [ spacer 5 60, display value ],
                              flow right [ spacer 5 60, buttonCE, buttonC ],
                              flow right [ spacer 5 60, buttonPlus, button1, button2, button3 ],
                              flow right [ spacer 5 60, buttonMinus, button4, button5, button6 ],
                              flow right [ spacer 5 60, buttonMult, button7, button8, button9 ],
                              flow right [ spacer 5 60, buttonDiv, button0, buttonDot, buttonEq ]
                          ]
                  ]

The `view` function takes two arguments: the calculator state, and a
pair representing the window sizes. The `CalculatorView` module
defines a `main` method for testing purposes. You can see it in action
[here](CalculatorView.html).

The `Calculator` module is the main module of our calculator program:

% Calculator.elm
      module Calculator where


      import CalculatorModel (..)
      import CalculatorView (..)
      import Window


      lastButtonClicked =
          merges [
              button0Signal,
              button1Signal,
              button2Signal,
              button3Signal,
              button4Signal,
              button5Signal,
              button6Signal,
              button7Signal,
              button8Signal,
              button9Signal,
              buttonEqSignal,
              buttonPlusSignal,
              buttonMinusSignal,
              buttonDivSignal,
              buttonMultSignal,
              buttonDotSignal,
              buttonCSignal,
              buttonCESignal
          ]


      stateSignal = foldp step initialState lastButtonClicked


      main = lift2 view stateSignal Window.dimensions

The `lastButtonClicked` function combines individual signals
associated with the calculator buttons into one signal using the
`merges` function from the `Signal` standard library module.

The `merges` function has the following signature:

      merges : [Signal a] -> Signal a

As the signature shows, all the signals in the input list need to have
the same type.

The `stateSignal` function uses the `foldp` function to combine the
`lastButtonClicked` signal with the `step` function from the
`CalculatorModel` module.

Finally, the `main` function combines the `stateSignal` and
`Window.dimensions` signals with the `view` function from the
`CalculatorView` module.

So far, we have only used the mouse to interact with our programs. In
the [next](Chapter11KeyboardSignals.html) chapter we will learn how to
use keyboard releated signals.

|]

