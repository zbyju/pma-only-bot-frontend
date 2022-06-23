module Page.NotFound exposing (view)

import Browser
import Component.Header as Header
import Element as Element
import Element.Background as Background
import Element.Font as Font
import Route
import Style.Color as Color


view : Browser.Document msg
view =
    { title = "Not Found Page"
    , body = [ Element.layout [ Background.color Color.primaryBackground, Font.color Color.primaryColor ] <| Element.column [ Element.width Element.fill, Element.height Element.fill ] [ header, content ] ]
    }


header : Element.Element msg
header =
    Header.view Nothing


content : Element.Element msg
content =
    Element.el [ Element.width Element.fill, Element.height Element.fill ]
        (Element.paragraph
            [ Element.centerX, Element.centerY, Font.center, Font.size 32 ]
            [ Element.el [ Font.light ] (Element.text "This page was not found. You can go back to the ")
            , Element.link [ Font.bold, Font.color Color.linkColor ] { url = Route.routeToString Route.Index, label = Element.text "front-page here" }
            , Element.el [ Font.light ] (Element.text ".")
            ]
        )
