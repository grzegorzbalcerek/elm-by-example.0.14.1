-- -*- coding: utf-8; -*-

import Lib (..)
import Window
import Signal
import Markdown

main = Signal.map (pageTemplate [content] "Chapter3MouseSignals" "toc" "Chapter5Eyes") Window.width

content = Markdown.toElement """

# Chapter 4 Window Signals

The `Window` module from the standard library defines signals which
provide information about the dimensions of the container in which the
Elm program lives. The container may be the whole browser window, but
does not have to be — it may for example be a `div` element where an
Elm program is embeded on an HTML page.

Our first example is a standalone program, and thus the signals
represent the dimensions of the browser window. The
*[WindowSignals1.elm](WindowSignals1.elm)* program is presented below,
and its working instance is available [here](WindowSignals1.html).

% WindowSignals1.elm
      module WindowSignals1 where


      import Graphics.Element (down, flow)
      import List (map)
      import Signal ((~), (<~))
      import Text (plainText)
      import Window


      showsignals a b c =
          flow
              down
              <|
                  map
                  plainText
                  [
                      "Window.dimensions: " ++ toString a,
                      "Window.width: " ++ toString b,
                      "Window.height: " ++ toString c
                  ]


      main =
          showsignals
              <~ Window.dimensions
              ~ Window.width
              ~ Window.height

Three signals are presented by the program:

 * `Window.dimensions` represents pairs (tuples) of the width and height of the container,
 * `Window.width` represents its width,
 * `Window.height` represents its height.

We will now embed our program in an HTML page. The
*WindowSignals2.html.txt* page shows how an Elm program can be
embedded.

% WindowSignals2.html
      ‹html›
        ‹head›
          ‹script src="WindowSignals1.js"›‹/script›
        ‹/head›
        ‹body›
          ‹div id="container" style="border: black solid 1px"›‹/div›
          ‹script›
            var div = document.getElementById('container')
            Elm.embed(Elm.WindowSignals1, div)
          ‹/script›
        ‹body›
      ‹/html›

The page includes the *WindowSignals1.js* file. The
following command can be used to produce that file:

      $ elm-make WindowSignals1.elm --output WindowSignals1.js
      Successfully generated WindowSignals1.js

So far, we have been providing file names with the *.html* extention
as the argument to the `--output` option. Here, we provide a file with
the *.js* extention, and the compiler is producing a JavaScript file.
In fact, producing JavaScript is the default. If w omit the `--output`
option, the compiler outputs a file called *elm.js*.

      $ elm-make WindowSignals1.elm
      Successfully generated elm.js

The *[WindowSignals2.html](WindowSignals2.html.txt)* page contains a `div`
element where the Elm program will be embedded. In order to easily
distinguish visually the `div` element on the page, a simple border is
added to it.

After the `div` element there is a `script` element containing a
fragment of code that is responsible for actually embedding the Elm
program into the `div` element. Note, that the script needs to be
placed after the `div` element in the page source.

The `script` element contains two statements. The first one finds the
`<div>` element and stores it in the `div` variable. The second
statement actually embeds the Elm program. The `Elm.embed` function is
called with two arguments. The first one is `Elm.WindowSignals1`,
where the `WindowSignals1` part is the name of the module defined in
the *WindowSignals1.elm* source file. The second argument is our `div`
element.

You can open the HTML page [here](WindowSignals2.html) and notice that
the dimensions reported by the program correspond to the dimensions of
the `div` element, not the dimensions of the whole window.

We can also embed the compiled Elm program as a fullscreen
application. The *[WindowSignals3.html](WindowSignals3.html)* page
shows how how to do it.

% WindowSignals3.html
      ‹html›
        ‹head›
          ‹script src="WindowSignals1.js"›‹/script›
        ‹/head›
        ‹body›
          ‹script›
            Elm.fullscreen(Elm.WindowSignals1)
          ‹/script›
        ‹body›
      ‹/html›

The *[WindowSignals3.html](WindowSignals3.html.txt)* page code is similar
to the *[WindowSignals2.html](WindowSignals2.html.txt)* code, but there is
no `div` element, and the one-argument `Elm.fullscreen` function is
used instead of `Elm.embed`.

In this and the previous chapters we have learned about mouse and
window related signals. The [next](Chapter5Eyes.html) chapter presents
an example that uses those signals.

"""
