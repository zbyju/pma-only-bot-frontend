module Component.VerticalSpace exposing (..)

import Element


view : Int -> Element.Element msg
view space =
    Element.el [ Element.height <| Element.px space ] Element.none
