module Route exposing (Route(..), fromUrl, routeToString)

import Html exposing (Attribute)
import Html.Attributes as Attributes
import Url
import Url.Parser as Parser



-- ROUTING


type Route
    = TodoList
    | Index


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map TodoList (Parser.s "todo-list")
        , Parser.map Index Parser.top
        ]


fromUrl : Url.Url -> Maybe Route
fromUrl =
    Parser.parse parser


routeToString : Route -> String
routeToString route =
    case route of
        TodoList ->
            "/todo-list"

        Index ->
            "/"
