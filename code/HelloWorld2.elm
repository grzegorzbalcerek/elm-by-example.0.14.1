import Text (..)
main : Element
main = toText "Hello World" |>
       color blue |>
       italic |>
       bold |>
       height 60 |>
       leftAligned
