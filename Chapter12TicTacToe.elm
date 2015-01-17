-- -*- coding: utf-8; -*-

import Lib (..)
import Window
import Signal (..)
import Markdown
import Graphics.Element (..)
import Graphics.Collage (..)

content w = pageTemplate [ content1
                         , container w 510 middle picture1
                         , content2
                         ] "Chapter11Paddle" "toc" "Chapter13Snake" w
main = content <~ Window.width

content1 = Markdown.toElement """

# Chapter 12 Tic Tac Toe

This chapter presents a program implementing the Tic Tac Toe game. You
can play it [here](TicTacToe.html) using your mouse to select the
field where you want to make a move. To start a new game click the
“New Game” button. If the game is not over, you can undo your last
move (and the computer’s move that followed it) by clicking the “Undo”
button.

The code is divided into three modules:

 * `TicTacToeModel`
 * `TicTacToeView`
 * `TicTacToe`

We start our analysis with the `TicTacToeModel` module defined in the
*[TicTacToeModel.elm](TicTacToeModel.elm)* file. The module contains
several data type declarations.

% TicTacToeModel.elm
      module TicTacToeModel where


      import List ((::), all, filter, head, isEmpty, length, map, tail)


      type Player = O | X


      type Result = Draw | Winner Player


      type alias Field = { col: Int, row: Int }


      type alias Move = (Field,Player)


      type alias Moves = List Move


      type GameState =
            FinishedGame Result Moves
          | NotFinishedGame Player Moves

The `Player` data type represents the two players. The `Result` data
type represents the result of the game — either a draw or a victory of
one of the players. The `Field` data type is a record containing the
coordinates (column and row) of a field. The `Move` type is a pair of
a `Field` and a `Player`. The `Moves` type is a list of `Move`
values. The `GameState` represents the game state, which can be either
a finished game, which has a result and a list of moves that were
made, or a not yet finished game, which contains the player which is
to make the next move, and a list of moves made so far.

The data types are followed by definitions of several functions. The
first one of them takes a player as argument and returns the “other”
player.
% TicTacToeModel.elm

      other : Player -> Player
      other player =
          case player of
              X -> O
              O -> X

The `moves` function extracts the list of moves from the game state.
% TicTacToeModel.elm

      moves : GameState -> Moves
      moves state =
          case state of
              (NotFinishedGame _ moves) -> moves
              (FinishedGame _ moves) -> moves

The `initialState` function returns the initial game state. We have assumed
that the player `X` always starts.
% TicTacToeModel.elm

      initialState : GameState
      initialState = NotFinishedGame X []

The `isFieldEmpty` function verifies whether a given field is not yet
occupied, given the list of moves made so far.
% TicTacToeModel.elm

      isFieldEmpty : Moves -> Field -> Bool
      isFieldEmpty moves field = all (\\move -> not (fst move == field)) moves

The function uses the `all` function, which takes a predicate function
(a function that takes an argument and returns a boolean value) and a
list and returns `True` if the predicate returns `True` for each
individual element of the list. Our predicate verifies whether the
field of the given move is the same as the field given as argument to
the `isFieldEmpty` function. Let’s test the function in the REPL.

      > import TicTacToeModel (..)
      > isFieldEmpty [({col=1,row=1},X),({col=3,row=2},O)] {col=1,row=1}
      False : Bool
      > isFieldEmpty [({col=1,row=1},X),({col=3,row=2},O)] {col=1,row=2}
      True : Bool

The `subsequences` function is a helper function that works on lists,
but is not available in the standard library `List` module.
% TicTacToeModel.elm

      subsequences : List a -> List (List a)
      subsequences lst =
          case lst of
              []  -> [[]]
              h::t -> let st = subsequences t
                      in
                          st ++ map (\\x -> h::x) st

It returns all subsequences of a given list.

      > subsequences []
      [[]] : List (List a)
      > subsequences [1]
      [[],[1]] : List (List number)
      > subsequences [1,2]
      [[],[2],[1],[1,2]] : List (List number)
      > subsequences [1,2,4]
      [[],[4],[2],[2,4],[1],[1,4],[1,2],[1,2,4]] : List (List number)

Notice how the empty list `[]` and a non-empty list consisting of the
head `h` and tail `t` are used as patterns in the `case` expression.

The `playerWon` function verifies whether the given player won,
considering the list of moves made so far.
% TicTacToeModel.elm

      playerWon : Player -> Moves -> Bool
      playerWon player =
          let fieldsAreInLine fields =
                  all (\\{col} -> col == 1) fields ||
                  all (\\{col} -> col == 2) fields ||
                  all (\\{col} -> col == 3) fields ||
                  all (\\{row} -> row == 1) fields ||
                  all (\\{row} -> row == 2) fields ||
                  all (\\{row} -> row == 3) fields ||
                  all (\\{col,row} -> col == row) fields ||
                  all (\\{col,row} -> col + row == 4) fields
          in  subsequences
                  >> filter (\\x -> length x == 3)
                  >> filter (all (\\(_,p) -> p == player))
                  >> map (map fst)
                  >> filter fieldsAreInLine
                  >> isEmpty
                  >> not

The function has one argument (called `player`), yet the type
declaration seems to declare two arguments. That means, that the
function takes one argument of type `Player` and returns another
function, of type `Moves -> Bool`.

The `fieldsAreInLine` helper function verifies whether the given list
of fields has only fields that are on the same line (vertical,
horizontal or diagonal).

The function returned by `playerWon` is composed from several smaller
functions using the `>>`, which composes two functions together. We
will analyze the individual functions starting from the first one —
`subsequences` — which returns all subsequences of the list of
moves. The next function filters those subsequences, leaving only
those that have three elements. The next one filters them even more,
leaving only those, which only have the moves of the player equal to
the first argument of the `playerWon` function. The next one turns the
list of moves into a list of fields by extracting the first element of
each move. The next function filters the list even more using the
helper function `fieldsAreInLine`. Finally, the last two functions
verify whether the list which is the result of all the previous
filtering is not empty.

      > playerWon X []
      False : Bool
      > playerWon X [({col=1,row=3},X),({col=3,row=3},O),({col=3,row=1},X),({col=1,row=1},O),({col=2,row=2},X)]
      True : Bool

The `addMove` function takes a move and a state and returns a new game
state.
% TicTacToeModel.elm

      addMove : Move -> GameState -> GameState
      addMove move state =
          let newMoves = move :: (moves state)
              player = snd move
          in
              if  | playerWon player newMoves -> FinishedGame (Winner player) newMoves
                  | length newMoves == 9 -> FinishedGame Draw newMoves
                  | otherwise -> NotFinishedGame (other player) newMoves

The function adds the move to the existing state and then verifies
whether the new situation corresponds to a finished game, either
because one of the players won, or because there is no more place left
on the board. In that case a `FinishedGame` state is returned.

      > addMove ({ col = 3, row = 1 },X) (NotFinishedGame X [({ col = 3, row = 3 },O),({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
      FinishedGame (Winner X) ([({ col = 3, row = 1 },X),({ col = 3, row = 3 },O),({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
       : GameState

Otherwise, if the game is not finished, a new `NotFinishedGame` value is
returned.

      > addMove ({ col = 3, row = 1 },X) (NotFinishedGame X [({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
      NotFinishedGame O ([({ col = 3, row = 1 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
       : GameState

The `makeComputerMove` function implements the algorithm used by the
computer to choose the next move.
% TicTacToeModel.elm

      makeComputerMove : GameState -> GameState
      makeComputerMove state = case state of
          FinishedGame _ _ -> state
          NotFinishedGame player moves ->
              let fields = [
                      {col=2,row=2},
                      {col=1,row=1},
                      {col=3,row=3},
                      {col=1,row=3},
                      {col=3,row=1},
                      {col=1,row=2},
                      {col=2,row=1},
                      {col=2,row=3},
                      {col=3,row=2}
                  ]
                  newField = head <| filter (isFieldEmpty moves) fields
                  newMoves = (newField, player) :: moves
              in
                  addMove (newField, player) state

The algorithm is very simple, and is not the optimal one. An optimal
algorithm would not leave a chance for the human player to win. This
algorithm however is not optimal for the game, so the player has a
change to win with the computer. The computer simply takes moves from
a predefined list. The moves that cannot be performed, because the
given field is not empty, are discarded, and the first one of the
remaining moves is selected.

      > makeComputerMove (NotFinishedGame X [])
      NotFinishedGame O ([({ col = 2, row = 2 },X)]) : GameState
      > makeComputerMove (NotFinishedGame O [({ col = 2, row = 2 },X)])
      NotFinishedGame X ([({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
       : GameState

The `makeHumanAndComputerMove` function takes a field selected by the
player, and the current game state, and returns a new game state.
% TicTacToeModel.elm

      makeHumanAndComputerMove : Field -> GameState -> GameState
      makeHumanAndComputerMove field state =
          case state of
              FinishedGame _ _ -> state
              NotFinishedGame player moves -> 
                  if isFieldEmpty moves field
                      then addMove (field,player) state |> makeComputerMove
                      else state

The function first verifies if the next move is allowed to be made on
the provided field. The move is not allowed if the game is already
finished, or if the field is not empty.

      > makeHumanAndComputerMove { col = 2, row = 1 } (FinishedGame (Winner X) [({ col = 3, row = 1 },X),({ col = 3, row = 3 },O),({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
      FinishedGame (Winner X) ([({ col = 3, row = 1 },X),({ col = 3, row = 3 },O),({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
       : GameState
      > makeHumanAndComputerMove { col = 2, row = 2 } (NotFinishedGame O [({ col = 2, row = 2 },X)])
      NotFinishedGame O ([({ col = 2, row = 2 },X)]) : GameState

If the move is allowed, the `addMove` is used for adding the move to
the game state, and returning the new state. The new state is then
passed to `makeComputerMove` to make the subsequent move by the
computer.

      > makeHumanAndComputerMove { col = 2, row = 2 } (NotFinishedGame O [])
      NotFinishedGame O ([({ col = 1, row = 1 },X),({ col = 2, row = 2 },O)])
       : GameState

The `undoMoves` function modifies the state to undo two moves — the
last computer move and the user move preceding it.
% TicTacToeModel.elm

      undoMoves : GameState -> GameState
      undoMoves state =
          case state of
              NotFinishedGame _ [] -> state
              NotFinishedGame player moves ->
                  NotFinishedGame player (moves |> tail |> tail)
              FinishedGame _ _ -> state

The moves are only removed if the game is not finished, and only if
there are actually moves that can be removed (the list of moves is not
empty).

      > undoMoves (FinishedGame (Winner X) [({ col = 3, row = 1 },X),({ col = 3, row = 3 },O),({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
      FinishedGame (Winner X) ([({ col = 3, row = 1 },X),({ col = 3, row = 3 },O),({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
       : GameState
      > undoMoves initialState
      NotFinishedGame X [] : GameState
      > undoMoves (NotFinishedGame O [({ col = 1, row = 3 },X),({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
      NotFinishedGame O ([({ col = 2, row = 2 },X)]) : GameState

The `processClick` function modifies the game state in reaction to a
mouse click by the user.
% TicTacToeModel.elm

      processClick : (Int,Int) -> GameState -> GameState
      processClick (x,y) =
          let col = 1 + x // 100
              row = 1 + y // 100
          in
              if col >= 1 && col <= 3 && row >= 1 && row <= 3
                  then makeHumanAndComputerMove {col=col,row=row}
                  else identity

The function uses the standard `identity` function, which returns its input
unchanged.

      > identity
      <function> : a -> a
      > identity 4
      4 : number
      > identity "abc"
      "abc" : String

The coordinates of the click position are translated into the
coordinates of one of the board fields. If the click is indeed inside
the board, the `makeHumanAndComputerMove` function is used for returning
the state-modifying function. Otherwise the `id` function is used in
order to (not) modify the state.

      > processClick (150,150) initialState
      NotFinishedGame X ([({ col = 1, row = 1 },O),({ col = 2, row = 2 },X)])
       : GameState
      > processClick (1500,150) initialState
      NotFinishedGame X [] : GameState

The [`TicTacToeView`](TicTacToeView.elm) module defines the drawing
functions.

% TicTacToeView.elm
      module TicTacToeView where


      import Color (black, white)
      import Graphics.Collage (circle, collage, filled, group, move, rect, rotate)
      import Graphics.Element (Element, container, down, flow, layers, middle, right, spacer)
      import Graphics.Input (button)
      import List (map)
      import Signal (Channel, channel, send)
      import Text (plainText)
      import TicTacToeModel (..)

The `drawLines` function draws the two vertical and two horizontal
lines of the game board.
% TicTacToeView.elm

      drawLines : Element
      drawLines =
          collage 300 300 [
              filled black (rect 3 300) |> move (-50,0),
              filled black (rect 3 300) |> move (50,0),
              filled black (rect 300 3) |> move (0,-50),
              filled black (rect 300 3) |> move (0,50)
          ]

The `drawMoves` function draws the moves of both players.
% TicTacToeView.elm

      drawMoves : GameState -> Element
      drawMoves state =
          let moveSign player =
                  group (case player of
                            X ->
                                let xline = filled black (rect 5 64)
                                in  [ rotate (degrees 45) xline
                                    , rotate (degrees 135) xline
                                    ]
                            O ->
                                [ filled black <| circle 30
                                , filled white <| circle 25
                                ]
                        )
              playerMove ({col,row}, player) =
                  moveSign player |> move (toFloat <| 100*col-200,toFloat <| -100*row+200)
          in
              collage 300 300 (map playerMove <| moves state)

The `stateDescription` returns the text of the message that the user
sees below the board.
% TicTacToeView.elm

      stateDescription : GameState -> String
      stateDescription state =
          case state of
            FinishedGame Draw _ -> "Game Over. Draw"
            FinishedGame (Winner p) _ -> "Game Over. Winner: " ++ toString p
            NotFinishedGame p _ -> "Next move: " ++ toString p

The `newGameChannel` function creates a channel for sending messages
in response to clicking the “New Game” button. The `newGameButton`
creates a clickable button using the `button` function from the
`Graphics.Input` module.

      button : Message -> String -> Element

The `Message` object is created using the `send` function, which takes
the channel as one of its arguments

% TicTacToeView.elm

      newGameChannel : Channel ()
      newGameChannel = channel ()


      newGameButton : Element
      newGameButton = button (send newGameChannel ()) "New Game"

There are also two similar functions related to the “Undo” button.
% TicTacToeView.elm

      undoChannel : Channel ()
      undoChannel = channel ()


      undoButton : Element
      undoButton = button (send  undoChannel ()) "Undo"

The `view` function collects the complete view, by drawing the board
lines and the player moves on top of each other, and the state
description message and the two buttons below.
% TicTacToeView.elm

      view : GameState -> Element
      view state =
          flow down [
              layers [drawLines, drawMoves state],
              container 300 60 middle <| plainText <| stateDescription state,
              container 300 60 middle <| flow right [undoButton, spacer 20 20, newGameButton]
          ]

The [`TicTacToe`](TicTacToe.elm) module implements the remainder of the game.

% TicTacToe.elm
      module TicTacToe where


      import Graphics.Element (Element)
      import Mouse
      import Signal ((<~), Signal, foldp, mergeMany, sampleOn, subscribe)
      import TicTacToeModel (..)
      import TicTacToeView (..)

The module creates several signals and combines them together. The
following figure presents how the individual signals are combined
together to produce the main game signal.

"""

sigBox a b c w x line = signalFunctionBox 14 18 50 a b c w x (line*100-300)
sigVertU line x = sigVerticalLine 25 x (line*100-238)
sigVertD line x = sigVerticalLine 25 x (line*100-238-25)
sigVert line x = sigVerticalLine 50 x (line*100-250)
sigHoriz w line x = sigHorizontalLine w x (line*100-250)
sigArr line x = sigDownwardArrow x (line*100-265)
sigVertArr line x = group [sigVert line x, sigArr line x ]

picture1 = collage 700 510
  [ sigBox "Signal ()" "newGameButtonSignal" "subscribe newGameChannel" 180 -240 5
  , sigBox "Signal (Int,Int)" "clickSignal" "sampleOn Mouse.clicks Mouse.position" 240 0 5
  , sigBox "Signal ()" "undoButtonSignal" "subscribe undoChannel" 180 240 5

  , sigVertArr 4 -240
  , sigVertArr 4 0
  , sigVertArr 4 240

  , sigBox "Signal (GameState -> GameState)" "newGameSignal" "" 200 -240 4
  , sigBox "Signal (GameState -> GameState)" "moveSignal" "" 200 0 4
  , sigBox "Signal (GameState -> GameState)" "undoSignal" "" 200 240 4

  , sigVertU 3 -240
  , sigVertArr 3 0
  , sigVertU 3 240
  , sigHoriz 480 3 0

  , sigBox "Signal (GameState -> GameState)" "inputSignal" "merges" 200 0 3

  , sigVertArr 2 0

  , sigBox "Signal GameState" "gameStateSignal" "foldp" 140 0 2

  , sigVertArr 1 0

  , sigBox "Signal Element" "main" "" 140 0 1
  ]

content2 = Markdown.toElement """

The first three functions create the basic input signals that are then
transformed into other signals. The `clickSignal` function creates a
signal which outputs the mouse pointer position on every click. The
`newGameButtonSignal` function returns the signal associated with
`newGameChannel`. The `undoButtonSignal` function returns the signal
associated with `undoChannel`.
% TicTacToe.elm

      clickSignal : Signal (Int,Int)
      clickSignal = sampleOn Mouse.clicks Mouse.position


      newGameButtonSignal : Signal ()
      newGameButtonSignal = subscribe newGameChannel


      undoButtonSignal : Signal ()
      undoButtonSignal = subscribe undoChannel

The next three functions transform each of the above signals into a
signal of state-transforming functions. Those signals have the type of
`Signal (GameState -> GameState)`. The functions carried by the signal
events will then be applied to the game state.

The `newGameSignal` creates a signal of functions that return the
initial game state regardless of the current state.
% TicTacToe.elm

      newGameSignal : Signal (GameState -> GameState)
      newGameSignal = always (always initialState) <~ newGameButtonSignal

The `always` function returns a function that disregards its input and
always outputs a certain value.

      > always
      <function> : a -> b -> a
      > f = always 1
      <function> : a -> number
      > f 2
      1 : number
      > f 6
      1 : number

It is used twice. The outer `always` disregards the `()` values of the
`newGameButtonSignal` signal, while the inner `always` disregards the
current state.

The `undoSignal` function creates a signal of `undoMoves` functions.
% TicTacToe.elm

      undoSignal : Signal (GameState -> GameState)
      undoSignal = always undoMoves <~ undoButtonSignal

The `moveSignal` function returns a signal of state-transforming
functions created by calling the `processClick` function with mouse
click positions. The `processClick` function is partially applied
here — only its first argument is applied.
% TicTacToe.elm

      moveSignal : Signal (GameState -> GameState)
      moveSignal = processClick <~ clickSignal

The `inputSignal` function merges the three signals described above
into one.
% TicTacToe.elm

      inputSignal : Signal (GameState -> GameState)
      inputSignal = mergeMany [ moveSignal, newGameSignal, undoSignal ]

The `gameStateSignal` uses the `foldp` function to modify the game state.
% TicTacToe.elm

      gameStateSignal : Signal GameState
      gameStateSignal = foldp (<|) initialState inputSignal

Recall the `foldp` signature.

      foldp : (a -> b -> b) -> b -> Signal a -> Signal b

In our case the input signal has the `Signal (GameState -> GameState)`
type, thus `a` is `GameState -> GameState`. The output signal has the
type `Signal GameState`, and thus `b` is `GameState`. We can conclude
therefore, that the function that we need to pass as the first
argument to `foldp` needs to have the following signature:

      (GameState -> GameState) -> GameState -> GameState

Well, that signature looks like a function application operator
`(<|)` — we can thus use it in the `foldp` call.

      (<|) : (a -> b) -> a -> b

So, the way how the `foldp` function works in our game is that it
receives state-transforming functions as input, and applies each of
them to the current state that it maintains and outputs.

The `main` function simply combines the signal of state values with
the `view` function from the `TicTacToeView` module.
% TicTacToe.elm

      main : Signal Element
      main = view <~ gameStateSignal

The [next](Chapter13Snake.html) chapter presents another game.

"""
