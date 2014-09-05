import Text (..)

makeBlue : Text -> Text
makeBlue = color blue

main : Element
main = toText "Hello World" |>
       makeBlue |>
       italic |>
       bold |>
       height 60 |>
       leftAligned
