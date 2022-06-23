module Page.NotFound exposing (view)

import Browser
import Component.Header as Header
import Element as Element


view : Browser.Document msg
view =
    { title = "Not Found Page"
    , body = [ Element.layout [] <| Element.column [ Element.width Element.fill, Element.height Element.fill ] [ header, content ] ]
    }


header : Element.Element msg
header =
    Header.view Nothing


content : Element.Element msg
content =
    Element.text "Content"
