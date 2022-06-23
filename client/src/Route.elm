module Route exposing (Route(..), fromUrl, routeToString)

import Url
import Url.Parser as Parser exposing ((</>))



-- ROUTING


type Route
    = Index
    | Server String


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Index Parser.top
        , Parser.map Server <| Parser.s "server" </> Parser.string
        ]


fromUrl : Url.Url -> Maybe Route
fromUrl =
    Parser.parse parser


routeToString : Route -> String
routeToString route =
    case route of
        Index ->
            "/"

        Server serverId ->
            "/server/" ++ serverId
