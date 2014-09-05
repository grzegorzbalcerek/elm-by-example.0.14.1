-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "Chapter3MouseSignals" "toc" "Chapter5Eyes") Window.width

content = [markdown|

# Chapter 4 Window Signals

The
[`Window`](http://library.elm-lang.org/catalog/elm-lang-Elm/0.12.3/Window)
module from the standard library defines signals which provide
information about the dimensions of the container in which the Elm
program lives. The container may be the whole browser window, but does
not have to be — it may be a `div` element where an Elm program is
embeded on an HTML page.

Our first example is a standalone program, and thus the signals
represent the dimensions of the browser window. The
*[WindowSignals1.elm](WindowSignals1.elm)* program is presented below,
and its working instance is available [here](WindowSignals1.html).

      module WindowSignals1 where

      import Window

      showsignals a b c =
       flow down <| map plainText
       [ "Window.dimensions: " ++ show a
       , "Window.width: " ++ show b
       , "Window.height: " ++ show c
       ]

      main = showsignals <~ Window.dimensions
                          ~ Window.width
                          ~ Window.height

Three signals are presented by the program:

 * `Window.dimensions` represents pairs (tuples) of the width and height of the container,
 * `Window.width` represents its width,
 * `Window.height` represents its height.

We will now embed our program in an HTML page. The
*WindowSignals2.html* page shows how an Elm program can be
embedded. Here is the page source:

      <html>
        <head>
          <script src="elm-runtime.js"></script>
          <script src="build/WindowSignals1.js"></script>
        </head>
        <body>
          <div id="container" style="border: black solid 1px"></div>
          <script>
            var container = document.getElementById('container')
            Elm.embed(Elm.WindowSignals1, container)
          </script>
        <body>
      </html>

The page includes the Elm runtime file *elm-runtime.js*. In fact,
every compiled Elm program also includes that file.  You can for
example verify, that *elm-runtime.js* is included by the
*WindowSignal1.html* page produced by the Elm compiler as the result
of compiling the *WindowSignals1.elm* program. If you cannot find the
*elm-runtime.js* in your Elm installation, compile any Elm program and
verify, in the HTML page produced by the compiler, where the runtime
file is included from.

The next line includes the *build/WindowSignals1.js* file. The
following command can be used to produce that file:

      elm --only-js WindowSignals1.elm

The `--only-js` flag instructs the Elm compiler to only generate the
JavaScript file. No html file is generated.

The *[WindowSignals2.html](WindowSignals2.txt)* page contains a `div`
element where the Elm program will be embedded. In order to easily
distinguish visually the `div` element on the page, a simple border is
added to it.

After the `div` element there is a `script` element containing a
fragment of code that is responsible for actually embedding the Elm
program into the `div` element. Note, that the script needs to be
placed after the `div` element in the page source.

The `script` element contains two statements. The first one finds the
`div` element and stores it in the `container` variable. The second
statement actually embeds the Elm program. The `Elm.embed` function is
called with two arguments. The first one is `Elm.WindowSignals1`. The
`WindowSignals1` is the name of the module defined in the
*WindowSignals1.elm* source file. The second argument is our container
element.

You can open the HTML page [here](WindowSignals2.html) and notice that
the dimensions reported by the program correspond to the dimensions of
the `div` element, not the dimensions of the whole window.

In this and the previous chapters we have learned about mouse and
window related signals. The [next](Chapter5Eyes.html) chapter presents
an example that uses those signals.

|]
