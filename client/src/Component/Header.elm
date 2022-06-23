module Component.Header exposing (view)

import Element
import Element.Background as Background
import Route


view : Maybe Route.Route -> Element.Element msg
view activeRoute =
    Element.el
        [ Element.width Element.fill, Background.color (Element.rgb255 240 0 245) ]
        (Element.row
            []
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
navLinkView route name _ =
    Element.link [] { url = Route.routeToString route, label = Element.text name }


routeList : List ( Route.Route, String )
routeList =
    [ ( Route.Index, "Home" )
    , ( Route.TodoList, "TodoList" )
    ]
