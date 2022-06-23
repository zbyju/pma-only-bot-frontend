module Style.Base exposing (..)

import Element
import Element.Background as Background
import Element.Font as Font


heading1 : List (Element.Attribute msg)
heading1 =
    [ Font.bold
    , Font.size 40
    ]


heading2 : List (Element.Attribute msg)
heading2 =
    [ Font.bold
    , Font.size 30
    ]


heading3 : List (Element.Attribute msg)
heading3 =
    [ Font.bold
    , Font.size 25
    ]
