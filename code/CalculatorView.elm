module CalculatorView where


import CalculatorModel (..)
import Graphics.Input (Input, input, clickable)
import Text


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


makeButtonAndSignal : String -> ButtonType -> (Element, Signal String)
makeButtonAndSignal label btnSize =
    let buttonInput = input label
        button = makeButton label btnSize
        clickableButton = clickable buttonInput.handle label button
    in
        (clickableButton, buttonInput.signal)


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


display : CalculatorState -> Element
display state =
    collage 240 60 [
       outlined { defaultLine | width <- 2, cap <- Padded } <| rect 232 50,
       toForm (container 220 50 midRight (plainText <| showState state))
    ]


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
