module DrawCircles where


import Array as A


color : Int -> Color
color n =
    let colors =
            A.fromList [ green, red, blue, yellow, brown, purple, orange ]
    in
        A.getOrElse black (n % (A.length colors)) colors


circleForm : (Int, (Int, Int)) -> Form
circleForm (r, (x, y)) =
    circle (toFloat r*5)
        |> filled (color r)
        |> move (toFloat x,toFloat y)


drawCircles : [(Int, (Int, Int))] -> (Int, Int) -> Element
drawCircles d (w, h) = collage w h <| map circleForm d

main =
    drawCircles [
            (3, (-200, 0)),
            (4, (-100, 0)),
            (5, (0, 0)),
            (7, (100, 0)),
            (9, (200, 0))
        ]
        (600, 400)
