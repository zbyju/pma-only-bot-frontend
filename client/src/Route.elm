module Route exposing (Route(..), fromUrl, routeToString)

import Url
import Url.Parser as Parser



-- ROUTING


type Route
    = Index
    | Server


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Index Parser.top
        , Parser.map Server (Parser.s "server")
        ]


fromUrl : Url.Url -> Maybe Route
fromUrl =
    Parser.parse parser


routeToString : Route -> String
routeToString route =
    case route of
        Index ->
            "/"

        Server ->
            "/server/"
