module Component.Header exposing (view)

import Element
import Element.Background as Background
import Element.Font as Font
import Route
import Simple.Transition as Transition
import Style.Color as Color


view : Maybe Route.Route -> Element.Element msg
view activeRoute =
    Element.el
        [ Element.width Element.fill, Background.color (Element.rgb255 0 0 0) ]
        (Element.row
            [ Element.paddingXY 100 0, Element.centerY, Element.spaceEvenly ]
            (List.map
                (\( route, name ) -> navLinkView route name (isActive activeRoute route))
                routeList
            )
        )


isActive : Maybe Route.Route -> Route.Route -> Bool
isActive maybeActiveRoute route =
    case maybeActiveRoute of
        Nothing ->
            False

        Just activeRoute ->
            activeRoute == route


navLinkView : Route.Route -> String -> Bool -> Element.Element msg
navLinkView route name isLinkActive =
    case isLinkActive of
        False ->
            Element.link
                [ Element.paddingXY 15 10
                , Element.mouseOver
                    [ Background.color Color.accent2Background
                    ]
                , Transition.properties
                    [ Transition.backgroundColor 500 []
                    ]
                    |> Element.htmlAttribute
                ]
                { url = Route.routeToString route, label = Element.text name }

        True ->
            Element.link
                [ Element.paddingXY 15 10
                , Background.color Color.highlightBackground
                , Font.color Color.highlightColor
                ]
                { url = Route.routeToString route, label = Element.text name }


routeList : List ( Route.Route, String )
routeList =
    [ ( Route.Index, "Home" )
    ]
