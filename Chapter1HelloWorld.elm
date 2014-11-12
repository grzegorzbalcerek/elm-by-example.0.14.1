-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Introduction" "toc" "Chapter2FibonacciBars") Window.width

content = [markdown|

# Chapter 1 Hello World

The first example will display the “Hello World” message. The program
— *[HelloWorld1.elm](HelloWorld1.elm)* — is presented below.

% HelloWorld1.elm
      main = plainText "Hello World"

The meaning of an Elm program is defined by the `main` function. Every
program needs to define one. To define a function, we provide its name
followed by the `=` character and the function body. Functions may
have parameters, which are declared between the function name and the
equals sign. The `main` function does not have parameters.

The body of our function contains a call to the `plainText` function
with one argument — the “Hello World” string. The string is delimited
with the quotation marks. The function argument is separated from the
function name by a single space (more spaces would do as well). Elm
does not require enclosing function arguments in parenthesis.

Before the program can be run, it needs to be compiled. The following
command compiles it:

      elm HelloWorld1.elm

The compiler builds the *HelloWorld.html* file in the *build*
folder. You can now open that file using your favorite browser. Click
[here](HelloWorld1.html) to see the program output.

Our program shows the “Hello World” message using the default
font. What if we want to use a different font? The *[HelloWorld2.elm](HelloWorld2.elm)*
program, presented below, shows one way styling the message in a
custom way. You can see it in action [here](HelloWorld2.html).

% HelloWorld2.elm
      import Text


      main : Element
      main =
          Text.toText "Hello World"
          |> Text.color blue
          |> Text.italic
          |> Text.bold
          |> Text.height 60
          |> Text.leftAligned

In order to style to our message, we use functions from the `Text`
module from Elm’s standard library. The first line: `import Text`
imports the `Text` module, allowing us to reference its functions in
our program. We reference a function by prefixing the function name with
the module name and the dot.

The second line is the `main` function type declaration (or in other
words, its signature). Signatures are optional and we did not have it
in our first program. In fact, the first versions of Elm did not even
provide a way of declaring function signatures. It is however often a
good idea to add them to our programs, as a way of documenting its
functions. The type declaration is given in the line preceding its
definition, and it consists of the function name followed by the colon
character and the function type. Our declaration states, that the
`main` function does not take any parameters and returns a value of
the `Element` type. Elements are “things” that Elm’s runtime know how
to display. The `Element` type name starts with a capital letter. In
fact, all type names in Elm must start with a capital letters.

The function definition must be consistent with its
signature. Otherwise Elm will complain by printing a compilation
error. For example, if we temporarily change the function type
declaration to `main : String` in our program (such a declaration
implies that the result of the `main` function is a string), the
compiler would complain:

      $ elm HelloWorld2.elm
      [1 of 1] Compiling Main                ( HelloWorld2.elm )
      Type error between lines 3 and 8:
              (((((Text.toText "Hello World") |> (Text.color blue)) |>
                 Text.italic) |>
                Text.bold) |>
               (Text.height 60)) |>
              Text.leftAligned

         Expected Type: Graphics.Element.Element
           Actual Type: String

The `main` function body contains a set of expressions separated with
the `|>` operators. What are they? They are in fact a way of function
application. If we have a function `f` taking one argument `a`, we can
call it using the `f a` syntax. But we can also swap the argument and
the function name and add the `|>` operator, like so:

      a |> f

For greater readability, we have also added new line characters before
the `|>` operators.

The body of our `main` function consists of several function
applications chained together. In fact, it could alternatively have
been written in the following way:

      main = Text.leftAligned (Text.height 60 (Text.bold (Text.italic (Text.color blue (Text.toText "Hello World")))))

Let’s now analyze what the function does. It starts with a call to the
`toText` function, which transforms a string into a value of type
`Text`. It’s type looks like this:

      toText : String -> Text

The `->` arrow separates the function argument type from the result
type. The `Text` value created by the `toText` function has certain
default properties, like the color or font size. The function calls
following the `toText` call modify those properties, creating new
`Text` values which differ in some respect from the old value.

It is important to keep in mind, that Elm functions do not modify
their arguments in place. So, whenever I write about “modifying” the
function argument in some way, it is really a shortcut for saying that
the function returns a copy of the argument, which differs from the
original argument in some way.

The `color` function let us specify the color of the `Text` value. It
takes two arguments: the color and the text value and it returns a new
text value. Here is it’s type:

      color : Color -> Text -> Text

Notice how the `->` operator not only separates the result type of the
function from its arguments, but the same operator is also used for
separatting one argument from the other.

The `italic` and `bold` functions, as their names suggest, modify the
text to be italic and bold. The call to the `height` function sets the
text height to 60 pixels. Like `color`, it is also a two-argument
function:

      height : Float -> Text -> Text

Finally, the `leftAligned` function turns a `Text` value to an
`Element` that can be displayed:

      leftAligned : Text -> Element

Let us get back to the signatures of the `color` and `height`
functions. Why is it, that the same operator — the `->` arrow — is
used for what might seem to be two different things: to separate one
function argument from the other one and in the same time to separate
the arguments from the function result type? In fact, stricly
speaking, all Elm functions can only take at most one argument. The
`color` function, which can in many circumstances be treated just as a
function taking two arguments, is more formally speaking a
one-argument function taking an argument of the `Color` type, that
returns another one-argument function, taking an argument of the
`Text` type, which in turn returns the result of type `Text`. It
might seem to be a small technical distinction only and in many
situtions it can be ignored. However, it also allows us to use a
useful programming technique of partially applying a
function. Consider the *[HelloWorld3.elm](HelloWorld3.elm)* program, which displays the
same text that *[HelloWorld2.elm](HelloWorld2.elm)* does, but is written in a slightly
different way.

% HelloWorld3.elm
      import Text as T


      makeBlue : Text -> Text
      makeBlue = T.color blue


      main : Element
      main =
          T.toText "Hello World"
          |> makeBlue
          |> T.italic
          |> T.bold
          |> T.height 60
          |> T.leftAligned

The first difference is the use of a *qualified* import. By suffixing
the import statement for the `Text` module with the `as T` clause, we
make the `Text` module available with the qualified name `T` instead
of the full name `Text`. The references to the functions defined in
that module must now be prefixed with `T.`.

The `main` function differs from its equivalent in the previous
program by using the auxiliary function `makeBlue` instead of directly
calling the `color` function with the `blue` argument.

Let us analyze the `makeBlue` function. Its body consists of applying
the `blue` value (of type `Color`) as the argument of the `color`
function. Let us recall the signature of `color`:

      color : Color -> Text -> Text

We have applied the first argument, but not the second. The result of
that application is a `Text -> Text` function. We have thus converted
a two-argument function `color` into a one-argument function
`makeBlue`, that transforms a `Text` value into another `Text` value,
which has its color set to blue.

The `Text` module is part of the Elm standard library. We have so far
only used a small subset of its functions, but it contains more of
them. If you want to verify what are the functions that a module
provide, try to find the module on the
[library.elm-lang.org](http://library.elm-lang.org/) web site.

Let us now turn to the last example in this chapter. We will display
text specified using the
[Markdown](http://daringfireball.net/projects/markdown/) format. The
*[HelloWorld4.elm](HelloWorld4.elm)* program, presented below, shows a
small web page. You can see the program output
[here](HelloWorld4.html).

      main = [markdown|

      # Hello World

      This is the output of the *HelloWorld4.elm* program.

      ---

<pre>  &#x7c;]</pre>

The body of the `main` function defines a markdown block delimited by
the `[markdown|` and <code>&#x7c;]</code> tags. The line starting with
a single hash `#` character is displayed as a header (using the `h1`
HTML tag) line.  The words enclosed in asterisks are displayed in
italic.  Finally, the three consecutive dash characters are showed as
a horizontal line. Our program only uses a few selected Markdown
features. You can read about others on the [Markdown
Syntax](http://daringfireball.net/projects/markdown/syntax) web page.

The [next](Chapter2FibonacciBars.html) chapter will show you how to make
arithmetic calculations and draw simple pictures. It will also present
another tool provided by Elm — the REPL.

|]
