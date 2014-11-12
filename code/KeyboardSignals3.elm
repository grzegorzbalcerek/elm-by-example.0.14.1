import Keyboard
import Char


main = lift asText (Keyboard.isDown (Char.toCode 'A'))
