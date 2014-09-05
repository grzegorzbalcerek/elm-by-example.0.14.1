module Calculator where

import CalculatorModel (..)
import CalculatorView (..)
import Window

lastButtonClicked = merges [
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
  buttonCESignal]

stateSignal = foldp step initialState lastButtonClicked

main = lift2 view stateSignal Window.dimensions

