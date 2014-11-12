import Text as T


makeBlue : Text -> Text
makeBlue = T.color blue


main : Element
main =
    T.toText "Hello World"
    |> makeBlue
    |> T.italic
    |> T.bold
    |> T.height 60
    |> T.leftAligned
