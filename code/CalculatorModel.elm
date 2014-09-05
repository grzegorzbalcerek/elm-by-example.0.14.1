module CalculatorModel where

import Char
import Set
import String

data ButtonType = Regular | Large

buttonSize : ButtonType -> Int
buttonSize size = case size of
  Regular -> 60
  Large -> 120

type CalculatorState = {
  input: String,
  operator: String,
  number: Float }

initialState = { number = 0.0, input = "", operator = "" }

isOper : String -> Bool
isOper btn = Set.member btn (Set.fromList ["+","-","*","/","="])

calculate : Float -> String -> String -> Float
calculate number op input =
  let number2 = maybe 0.0 id (String.toFloat input)
  in if | op == "+" -> number + number2
        | op == "-" -> number - number2
        | op == "*" -> number * number2
        | op == "/" -> number / number2
        | otherwise ->  number2

step : String -> CalculatorState -> CalculatorState
step btn state =
  if | btn == "C" -> initialState
     | btn == "CE" -> { state | input <- "0" }
     | state.input == "" && isOper btn -> { state | operator <- btn }
     | isOper btn -> {
          number = calculate state.number state.operator state.input,
          operator = btn,
          input = "" }
     | otherwise -> { state | input <-
         if | (state.input == "" || state.input == "0") && btn == "." -> "0."
            | state.input == "" || state.input == "0" -> btn
            | String.length state.input >= 18 -> state.input
            | btn == "." && any (\c -> c == '.') (String.toList state.input) -> state.input
            | otherwise -> state.input ++ btn }

showState : CalculatorState -> String
showState {number,input} = if input == "" then show number else input

