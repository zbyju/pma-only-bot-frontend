module Component.StatTile exposing (view)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Simple.Transition as Transition
import Style.Color as Color


view : String -> Float -> Element.Element msg
view label value =
    Element.column
        [ Element.paddingXY 10 5
        , Background.color Color.accentBackground
        , Element.spacingXY 0 5
        , Font.center
        , Element.centerX
        , Element.centerY
        , Border.rounded 10
        ]
        [ Element.el
            [ Element.centerX
            , Font.center
            , Font.bold
            , Font.size 30
            , Element.paddingEach { top = 0, left = 0, right = 0, bottom = 5 }
            ]
            (Element.text <| String.fromFloat value)
        , Element.el
            [ Element.centerX
            , Font.center
            , Font.extraLight
            ]
            (Element.text label)
        ]
