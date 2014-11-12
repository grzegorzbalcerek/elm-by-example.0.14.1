{-
  This module contains functions which draw
  the eyes.
-}
module EyesView where


eyeBorder : Float -> Float -> Form
eyeBorder w h =
    group [
        filled black <| oval w h,
        filled white <| oval (w*9/10) (h*9/10)
    ]


eyePupil : Float -> Float -> Form
eyePupil w h = filled black <| oval w h


eyesView : (Int, Int) -> (Float, Float, Float, Float) -> Element
eyesView (w, h) (xPl, yPl, xPr, yPr) =
    let xC = (toFloat w) / 4
        yC = (toFloat h) / 2
    in
        collage
            w
            h
            [
                eyeBorder (2*xC) (2*yC) |> moveX (-xC),
                eyeBorder (2*xC) (2*yC) |> moveX xC,
                eyePupil (xC/5) (yC/5) |> move (xPl,yPl),
                eyePupil (xC/5) (yC/5) |> move (xPr,yPr)
            ]


-- test
main = eyesView (700, 500) (-50, -50, 100, 100)
