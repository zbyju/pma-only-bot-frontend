module Style.Base exposing (..)

import Element
import Element.Background as Background
import Element.Font as Font


heading1 : List (Element.Attribute msg)
heading1 =
    [ Font.bold
    , Font.size 40
    ]
