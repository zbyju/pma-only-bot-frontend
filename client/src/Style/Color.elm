module Style.Color exposing (..)

import Element
import Element.Background as Background


linkColor : Element.Color
linkColor =
    Element.rgb255 123 77 255


primaryBackground : Element.Color
primaryBackground =
    Element.rgb255 23 23 23


primaryColor : Element.Color
primaryColor =
    Element.rgb255 255 255 255


accentBackground : Element.Color
accentBackground =
    Element.rgb255 123 77 255


accent2Background : Element.Color
accent2Background =
    Element.rgb255 130 87 255


highlightBackground : Element.Color
highlightBackground =
    Element.rgb255 234 96 223


highlightColor : Element.Color
highlightColor =
    Element.rgb255 0 0 0


highlight2Background : Element.Color
highlight2Background =
    Element.rgb255 232 102 222


accentGradient : Element.Attr decorative msg
accentGradient =
    Background.gradient
        { angle = pi / 2
        , steps =
            [ accentBackground
            , accent2Background
            ]
        }
