import Text


main : Element
main =
    Text.toText "Hello World"
        |> Text.color blue
        |> Text.italic
        |> Text.bold
        |> Text.height 60
        |> Text.leftAligned
