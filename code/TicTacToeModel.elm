module TicTacToeModel where

data Player = O | X
data Result = Draw | Winner Player
type Field = { col: Int, row: Int }
type Move = (Field,Player)
type Moves = [Move]
data GameState = FinishedGame Result Moves
               | NotFinishedGame Player Moves

other : Player -> Player
other player = case player of
  X -> O
  O -> X

moves : GameState -> Moves
moves state = case state of
  (NotFinishedGame _ moves) -> moves
  (FinishedGame _ moves) -> moves

initialState : GameState
initialState = NotFinishedGame X []

isFieldEmpty : Moves -> Field -> Bool
isFieldEmpty moves field = all (\move -> not (fst move == field)) moves

subsequences : [a] -> [[a]]
subsequences lst = case lst of
  []  -> [[]]
  h::t -> let st = subsequences t
          in st ++ map (\x -> h::x) st

playerWon : Player -> Moves -> Bool
playerWon player =
  let fieldsAreInLine fields =
        all (\{col}     -> col == 1)       fields ||
        all (\{col}     -> col == 2)       fields ||
        all (\{col}     -> col == 3)       fields ||
        all (\{row}     -> row == 1)       fields ||
        all (\{row}     -> row == 2)       fields ||
        all (\{row}     -> row == 3)       fields ||
        all (\{col,row} -> col == row)     fields ||
        all (\{col,row} -> col + row == 4) fields
  in not .
     isEmpty .
     filter fieldsAreInLine .
     map (map fst) .
     filter (all (\(_,p) -> p == player)) .
     filter (\x -> length x == 3) .
     subsequences

addMove : Move -> GameState -> GameState
addMove move state =
  let newMoves = move :: (moves state)
      player = snd move
  in if | playerWon player newMoves -> FinishedGame (Winner player) newMoves
        | length newMoves == 9 -> FinishedGame Draw newMoves
        | otherwise -> NotFinishedGame (other player) newMoves

makeComputerMove : GameState -> GameState
makeComputerMove state = case state of
  FinishedGame _ _ -> state
  NotFinishedGame player moves ->
    let fields = [{col=2,row=2},{col=1,row=1},{col=3,row=3},{col=1,row=3},{col=3,row=1},{col=1,row=2},{col=2,row=1},{col=2,row=3},{col=3,row=2}]
        newField = head <| filter (isFieldEmpty moves) fields
        newMoves = (newField,player)::moves
  in addMove (newField,player) state

makeHumanAndComputerMove : Field -> GameState -> GameState
makeHumanAndComputerMove field state = case state of
  FinishedGame _ _ -> state
  NotFinishedGame player moves -> 
    if isFieldEmpty moves field
    then addMove (field,player) state |> makeComputerMove
    else state

undoMoves : GameState -> GameState
undoMoves state = case state of
  NotFinishedGame _ [] -> state
  NotFinishedGame player moves ->
    NotFinishedGame player (moves |> tail |> tail)
  FinishedGame _ _ -> state

processClick : (Int,Int) -> GameState -> GameState
processClick (x,y) =
    let col = 1 + x `div` 100
        row = 1 + y `div` 100
    in
      if col >= 1 && col <= 3 && row >= 1 && row <= 3
      then makeHumanAndComputerMove {col=col,row=row}
      else id
