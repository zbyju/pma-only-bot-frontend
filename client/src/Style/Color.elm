module Style.Color exposing (..)

import Element
import Element.Background as Background


linkColor : Element.Color
linkColor =
    Element.rgb255 132 124 252


primaryBackground : Element.Color
primaryBackground =
    Element.rgb255 23 23 23


primaryColor : Element.Color
primaryColor =
    Element.rgb255 255 255 255


accentBackground : Element.Color
accentBackground =
    Element.rgb255 132 124 252


accent2Background : Element.Color
accent2Background =
    Element.rgb255 122 114 242


highlightBackground : Element.Color
highlightBackground =
    Element.rgb255 250 255 0


highlightColor : Element.Color
highlightColor =
    Element.rgb255 0 0 0


highlight2Background : Element.Color
highlight2Background =
    Element.rgb255 240 245 0


accentGradient : Element.Attr decorative msg
accentGradient =
    Background.gradient
        { angle = pi / 2
        , steps =
            [ accentBackground
            , accent2Background
            ]
        }
