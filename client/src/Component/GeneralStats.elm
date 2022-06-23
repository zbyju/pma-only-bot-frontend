module Component.GeneralStats exposing (..)

import Component.StatTile as StatTile
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Style.Base as Base


view : Element.Element msg
view =
    Element.column
        [ Element.width Element.fill
        , Element.centerX
        , Element.paddingEach { top = 100, left = 0, right = 0, bottom = 20 }
        , Element.spacingXY 0 20
        ]
        [ Element.el (List.concat [ Base.heading2, [ Element.centerX ] ]) (Element.text "General stats")
        , Element.wrappedRow [ Element.centerX, Element.spacingXY 10 0 ]
            [ StatTile.view "#Servers" 10
            , StatTile.view "#Channels" 10
            , StatTile.view "#Users" 10
            , StatTile.view "#Messages" 10
            , StatTile.view "#Emotes" 10
            ]
        ]
