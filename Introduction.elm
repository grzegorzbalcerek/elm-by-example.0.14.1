-- -*- coding: utf-8; -*-

import Lib (..)
import Window

main = lift (pageTemplate [content] "toc" "toc" "Chapter1HelloWorld") Window.width

content = [markdown|

# Introduction

This is a tutorial for the Elm programming language. It is a language
for creating web pages and web applications using Functional Reactive
Programming techniques.

This tutorial does not cover installing and configuring an Elm
programming environment. The Elm [web page](http://elm-lang.org)
provides installation instructions.

Elm is a relatively new programming language. It is evolving
quickly. Breaking changes are not something that is avoided at all
cost. With new Elm releases certain parts of this tutorial may become
obsolete. I am planning to update the tutorial as new Elm versions
appear, however you may expect a time lag between new Elm versions and
new versions of this tutorial. This version of the tutorial targets
Elm 0.12.3.

I am not treating this tutorial as a finished work. You may expect its
content to evolve and to be updated. Partly because of the Elm
evolution that I mentioned above. And partly because I may add new
examples, modify the existing ones, or do other changes that I find
appropriate. Feel free to let me know of any errors, issues, problems,
inconsistencies, or any other remarks that you may have. The source of
the tutorial is located on
[github](http://github.com/grzegorzbalcerek/elm-by-example) and you
can open an issue there.

The [first](Chapter1HelloWorld.html) chapter will show you how to make
simple Elm programs.

|]
