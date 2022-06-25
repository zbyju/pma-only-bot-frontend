module Page.Server exposing (Model, Msg, init, update, view)

import Browser
import Component.Header as Header
import Element
import Element.Background
import Element.Font as Font
import Http
import List exposing (concat)
import Route
import Style.Base as Base
import Style.Color as Color
import Utils.Decode.ServerStatsDecoder as SSDecode
import Utils.ServerStats as SS


type ServerStatsState
    = LoadingServerStats
    | ErrorServerStats String
    | SuccessServerStats SS.ServerStats


type alias Model =
    { apiOrigin : String
    , serverId : String
    , serverStatsState : ServerStatsState
    }


getServerStats : String -> String -> Cmd Msg
getServerStats apiOrigin serverId =
    Http.get
        { url = apiOrigin ++ "stats/server/" ++ serverId
        , expect = Http.expectJson GotServerStats SSDecode.decodeServerStats
        }


init : ( String, String ) -> ( Model, Cmd Msg )
init ( api, serverId ) =
    ( { serverId = serverId, apiOrigin = api, serverStatsState = LoadingServerStats }
    , getServerStats api serverId
    )


type Msg
    = GotServerStats (Result Http.Error SS.ServerStats)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotServerStats result ->
            case result of
                Err _ ->
                    ( { model
                        | serverStatsState = ErrorServerStats "There has been an error when fetching stats for this server."
                      }
                    , Cmd.none
                    )

                Ok serverStats ->
                    ( { model
                        | serverStatsState = SuccessServerStats serverStats
                      }
                    , Cmd.none
                    )


view : (Msg -> msg) -> Model -> Browser.Document msg
view wrapMsg model =
    { title = "Server Page"
    , body =
        [ Element.layout
            [ Element.Background.color Color.primaryBackground
            , Font.color Color.primaryColor
            ]
          <|
            Element.column
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
                [ header model.serverId
                , Element.map wrapMsg <| content model
                ]
        ]
    }


header : String -> Element.Element msg
header serverId =
    Header.view (Just <| Route.Server serverId)


content : Model -> Element.Element msg
content model =
    case model.serverStatsState of
        LoadingServerStats ->
            Element.column [ Element.width Element.fill, Element.height Element.fill ]
                [ Element.el
                    (concat
                        [ Base.heading1
                        , [ Font.center
                          , Element.centerX
                          , Element.paddingXY 0 150
                          ]
                        ]
                    )
                    (Element.text "Loading...")
                ]

        ErrorServerStats errorMessage ->
            Element.column [ Element.width Element.fill, Element.height Element.fill ]
                [ Element.el
                    (concat
                        [ Base.heading1
                        , [ Font.center
                          , Element.centerX
                          , Element.paddingXY 0 150
                          ]
                        ]
                    )
                    (Element.text errorMessage)
                ]

        SuccessServerStats serverStats ->
            Element.column [ Element.width Element.fill, Element.height Element.fill ]
                [ Element.el
                    (concat
                        [ Base.heading1
                        , [ Font.center
                          , Element.centerX
                          , Element.paddingXY 0 150
                          ]
                        ]
                    )
                    (Element.text "Ok")
                ]
