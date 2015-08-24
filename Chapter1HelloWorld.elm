-- -*- coding: utf-8; -*-
module Chapter1HelloWorld where

import Lib (..)
import Window
import Signal
import Markdown

main = Signal.map (pageTemplate [content] "Introduction" "toc" "Chapter2FibonacciBars") Window.width

content = Markdown.toElement """

# Chapter 1 Hello World

The first example will display the “Hello World” message. The program
— *[HelloWorld1.elm](HelloWorld1.elm)* — is presented below.

% HelloWorld1.elm
      import Text
      import Graphics.Element
      main = Graphics.Element.leftAligned (Text.fromString "Hello World")

The first line — `import Text` — imports the `Text` module, allowing
us to reference its functions in our program. We need the import,
since our program uses the `fromString` function that is defined in
that module. We reference a function by prefixing the function name
with the module name and the dot. We also import the `leftAligned`
function from the `Graphics.Element` module which allows us to convert
our text into a displayable HTML element.

The meaning of an Elm program is defined by the `main` function. Every
program needs to define one. To define a function, we provide its name
followed by the `=` character and the function body. Functions may
have parameters, which are declared between the function name and the
equals sign. The `main` function does not have parameters.

The body of our function contains a call to the `Text.fromString` function
with one argument — the “Hello World” string. The string is delimited
with the quotation marks. The function argument is separated from the
function name by a single space (more spaces would do as well). Elm
does not require enclosing function arguments in parenthesis. We enclose
the result of calling `Text.fromString` into a parenthesis to pass it in
as an argument to `Graphics.Element.leftAligned`.

Before the program can be run, it needs to be compiled. If you create
a directory with the *HelloWorld1.elm* program in it, you can use the
following command to compile:

      elm-make HelloWorld1.elm --output HelloWorld1.html

When you run that command the first time in that directory, it needs
to perform certain setup steps: download, configure and compile
standard library files.  Before doing that, it asks for
permission. You should answer `y` to proceed. The command will create
a file called *elm-package.json* and a folder called *elm-stuff* in
the current directory.

      $ elm-make HelloWorld1.elm --output HelloWorld1.html
      Some new packages are needed. Here is the upgrade plan.

        Install:
          elm-lang/core 1.0.0

      Do you approve of this plan? (y/n) y
      Downloading elm-lang/core
      Packages configured successfully!
      Compiled 33 files
      Successfully generated HelloWorld1.html

When the program is compiled again in the same folder, the setup is
not performed again.

      $ elm-make HelloWorld1.elm --output HelloWorld1.html
      Successfully generated HelloWorld1.html

The compiler builds the *HelloWorld1.html* file. You can now open that
file using your favorite browser. Click [here](HelloWorld1.html) to
see the program output.

The *elm-package.json* file contains information related to the Elm
project. Its content may look like this:

      {
          "version": "1.0.0",
          "summary": "helpful summary of your project, less than 80 characters",
          "repository": "https://github.com/USER/PROJECT.git",
          "license": "BSD3",
          "source-directories": [
              "."
          ],
          "exposed-modules": [],
          "dependencies": {
              "elm-lang/core": "1.0.0 <= v < 2.0.0"
          }
      }

You may change its content manually. It can also be modified by elm
tools: `elm-make`, that we have just met, and `elm-package`, that we
will meet soon.

Our program shows the “Hello World” message using the default
font. What if we want to use a different font? The
*[HelloWorld2.elm](HelloWorld2.elm)* program, presented below, shows
one way of styling the message in a custom way. You can see it in
action [here](HelloWorld2.html).

% HelloWorld2.elm
      module HelloWorld2 where


      import Color exposing (blue)
      import Graphics.Element exposing (..)
      import Text


      main : Element
      main =
          Text.fromString "Hello World"
              |> Text.color blue
              |> Text.italic
              |> Text.bold
              |> Text.height 60
              |> leftAligned

The program begins with a module declaration. The declaration consists
of the `module` keyword followed by the module name and the `where`
keyword, which marks the beginning of the module body. If a program
does not start with the module declaration — like our
*HelloWorld1.elm* program — the module called `Main` is implicitly
assumed.

In order to add style to our message, we use functions from the `Text`
module from Elm’s standard library. To make that possible, we import
the `Text` module.

Instead of importing a module, we can alternatively import its
members, which introduces those members to the current namespace. We
do this by following the module name with a list of imported values
enclosed in parentheses. The second import statement imports one member
(`blue`) from the `Color` module. Alternatively, we can replace the
list with two dot characters, thus importing everything that the module
exported. The third import is using that possiblity, importing
everything that the `Graphics.Element` exported, including the
`Element` type.

The `main` function in this program has a type declaration (or in
other words, its signature). Signatures are optional and we did not
have it in our first program. In fact, the first versions of Elm did
not even provide a way of declaring function signatures. It is however
often a good idea to add them to our programs, as a way of documenting
its functions. The type declaration is given in the line preceding its
definition, and it consists of the function name followed by the colon
character and the function type. Our declaration states, that the
`main` function does not take any parameters and returns a value of
the `Element` type. Elements are “things” that Elm’s runtime know how
to display. The `Element` type name starts with a capital letter. In
fact, all type names in Elm must start with a capital letter.

The function definition must be consistent with its
signature. Otherwise Elm will complain by printing a compilation
error. For example, if we temporarily change the function type
declaration to `main : String` in our program (such a declaration
implies that the result of the `main` function is a string), the
compiler would complain:

      $ elm-make HelloWorld2.elm --output HelloWorld2.html

      Error in HelloWorld2.elm:

      Type mismatch between the following types between lines 8 and 13:

              Graphics.Element.Element

              String

          It is related to the following expression:

              (((((Text.fromString "Hello World") |> (Text.color blue))
                   |> Text.italic)
                  |> Text.bold)
                 |> (Text.height 60))
                |> Text.leftAligned

The `main` function body contains a set of expressions separated with
the `|>` operators. What are they? They are in fact a way of function
application. If we have a function `f` taking one argument `a`, we can
call it using the `f a` syntax. But we can also swap the argument and
the function name and add the `|>` operator, like so:

      a |> f

For greater readability, the program includes new line characters
before the `|>` operators.

The body of our `main` function consists of several function
applications chained together. In fact, it could alternatively have
been written in the following way:

      main = Text.leftAligned (Text.height 60 (Text.bold (Text.italic (Text.color blue (Text.fromString "Hello World")))))

Let’s now analyze what the function does. It starts with a call to the
`fromString` function, which transforms a string into a value of type
`Text`. It’s type looks like this:

      fromString : String -> Text

The `->` arrow separates the function argument type from the result
type. The `Text` value created by the `fromString` function has
certain default properties, like color or font size. The function
calls following the `fromString` call modify those properties,
creating new `Text` values, which differ in some respect from the old
value.

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
separating one argument from the other.

The `italic` and `bold` functions, as their names suggest, modify the
text to be italic and bold. The call to the `height` function sets the
text height to 60 pixels. Like `color`, it is also a two-argument
function:

      height : Float -> Text -> Text

Finally, the `leftAligned` function turns a `Text` value into an
`Element` that can be displayed:

      leftAligned : Text -> Element

Let us get back to the signatures of the `color` and `height`
functions. Why is it, that the same operator — the `->` arrow — is
used for what might seem to be two different things: to separate one
function argument from the other and in the same time to separate the
arguments from the function result type? In fact, strictly speaking,
all Elm functions can only take at most one argument. The `color`
function, which can in many circumstances be treated just as a
function taking two arguments, is more formally speaking a
one-argument function taking an argument of the `Color` type, that
returns another one-argument function, taking an argument of the
`Text` type, which in turn returns the result of type `Text`. It might
seem to be a small technical distinction only and in many situations it
can be ignored. However, it also allows us to use a useful programming
technique of partially applying a function. Consider the
*[HelloWorld3.elm](HelloWorld3.elm)* program, which displays the same
text that *[HelloWorld2.elm](HelloWorld2.elm)* does, but is written in
a slightly different way.

% HelloWorld3.elm
      module HelloWorld3 where


      import Color exposing (blue)
      import Graphics.Element exposing (..)
      import Text as T


      makeBlue : T.Text -> T.Text
      makeBlue = T.color blue


      main : Element
      main =
          T.fromString "Hello World"
              |> makeBlue
              |> T.italic
              |> T.bold
              |> T.height 60
              |> leftAligned

The first difference is the use of a *qualified* import. By suffixing
the import statement for the `Text` module with the `as T` clause, we
make the `Text` module available with the qualified name `T` instead
of the full name `Text`. The references to symbols defined in that
module must now be prefixed with `T.`.

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
[package.elm-lang.org/](http://package.elm-lang.org/) web site.

The final example presented in this chapter —
*[HelloWorld4.elm](HelloWorld4.elm)* — shows a web page, the content
of which is specified using the
[Markdown](http://daringfireball.net/projects/markdown/) format.  See
the program output [here](HelloWorld4.html).

% HelloWorld4.elm
      module HelloWorld4 where


      import Markdown


      main = Markdown.toElement \"\"\"

      # Hello World

      This is the output of the *HelloWorld4.elm* program.

      ---
      \"\"\"

The body of the `main` function contains a call to the
Markdown.toElement function with one argument — a string containing
markdown syntax. The string is delimited with triple quotation mark
characters.

The line starting with a single hash `#` character is displayed as a
header (using the `h1` HTML tag) line.  The words enclosed in
asterisks are displayed in italic.  Finally, the three consecutive
dash characters are showed as a horizontal line. Our program only uses
a few selected Markdown features. You can read about others on the
[Markdown Syntax](http://daringfireball.net/projects/markdown/syntax)
web page.

The `Markdown` module does not belong to the Elm standard library. It
belongs to the *evancz/elm-markdown* package. We can install the
package with the following command:


      $ elm-package install evancz/elm-markdown
      To install evancz/elm-markdown I would like to add the following
      dependency to elm-package.json:

          "evancz/elm-markdown": "1.1.1 <= v < 2.0.0"

      May I add that to elm-package.json for you? (y/n) y

      Some new packages are needed. Here is the upgrade plan.

        Install:
          evancz/elm-html 1.0.0
          evancz/elm-markdown 1.1.1
          evancz/virtual-dom 1.0.0

      Do you approve of this plan? (y/n) y
      Downloading evancz/elm-html
      Downloading evancz/elm-markdown
      Downloading evancz/virtual-dom
      Packages configured successfully!

The command asked two questions and installed the package. It also
modified the *elm-package.json* file from the current folder:

      {
          "version": "1.0.0",
          "summary": "helpful summary of your project, less than 80 characters",
          "repository": "https://github.com/USER/PROJECT.git",
          "license": "BSD3",
          "source-directories": [
              "."
          ],
          "exposed-modules": [],
          "dependencies": {
              "elm-lang/core": "1.0.0 <= v < 2.0.0",
              "evancz/elm-markdown": "1.1.1 <= v < 2.0.0"
          }
      }

Notice the additional line in the *dependencies* section. We can now
compile our program using `elm-make`:

      elm-make HelloWorld4.elm --output HelloWorld4.html

The [next](Chapter2FibonacciBars.html) chapter will show you how to make
arithmetic calculations and draw simple pictures. It will also present
another tool provided by Elm — the REPL.

"""
