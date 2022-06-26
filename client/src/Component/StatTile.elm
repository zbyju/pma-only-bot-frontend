module Component.StatTile exposing (ValueStatTile(..), view)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Round
import Simple.Transition as Transition
import Style.Color as Color


type ValueStatTile
    = StringStatTile String
    | IntStatTile Int
    | FloatStatTile Float
    | UrlStatTile String String


view : String -> ValueStatTile -> Element.Element msg
view label value =
    let
        valueElement =
            case value of
                StringStatTile str ->
                    Element.text str

                IntStatTile int ->
                    Element.text <| String.fromInt int

                FloatStatTile float ->
                    Element.text <| Round.round 2 float

                UrlStatTile url desc ->
                    Element.image
                        [ Element.width <| Element.px 36
                        , Element.height <| Element.px 36
                        ]
                        { src = url, description = desc }

        ( ( paddingT, paddingB ), ( paddingL, paddingR ) ) =
            case value of
                UrlStatTile _ _ ->
                    ( ( 4, 10 ), ( 12, 12 ) )

                _ ->
                    ( ( 10, 10 ), ( 12, 12 ) )
    in
    Element.column
        [ Element.paddingEach { top = paddingT, bottom = paddingB, left = paddingL, right = paddingR }
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
            valueElement
        , Element.el
            [ Element.centerX
            , Font.center
            , Font.extraLight
            , Font.size 20
            ]
            (Element.text label)
        ]
