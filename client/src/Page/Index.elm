module Page.Index exposing (Model, Msg, init, update, view)

import Browser
import Component.Header as Header
import Component.StatTile as StatTile
import Element
import Element.Background
import Element.Border as Border
import Element.Font as Font
import Http
import List exposing (concat)
import Route
import Style.Base as Base
import Style.Color as Color
import Utils.Decode.GeneralStatsDecoder as GSDecode
import Utils.GeneralStats as GS


type GeneralStatsState
    = LoadingGeneralStats
    | ErrorGeneralStats String
    | SuccessGeneralStats GS.GeneralStats


type alias Model =
    { apiOrigin : String
    , generalStatsState : GeneralStatsState
    }


type Msg
    = GotGeneralStats (Result Http.Error GS.GeneralStats)


getGeneralStats : String -> Cmd Msg
getGeneralStats apiOrigin =
    Http.get
        { url = apiOrigin ++ "stats/general"
        , expect = Http.expectJson GotGeneralStats GSDecode.decodeGeneralStats
        }


init : ( String, Bool ) -> ( Model, Cmd Msg )
init ( apiOrigin, _ ) =
    ( { apiOrigin = apiOrigin
      , generalStatsState = LoadingGeneralStats
      }
    , getGeneralStats apiOrigin
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotGeneralStats result ->
            case result of
                Err _ ->
                    ( { model
                        | generalStatsState = ErrorGeneralStats "There has been an error when fetching general statistics."
                      }
                    , Cmd.none
                    )

                Ok generalStats ->
                    ( { model
                        | generalStatsState = SuccessGeneralStats generalStats
                      }
                    , Cmd.none
                    )


view : (Msg -> msg) -> Bool -> Model -> Browser.Document msg
view wrapMsg isLoggedIn model =
    { title = "Index Page"
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
                [ header
                , Element.map wrapMsg <| content model isLoggedIn
                ]
        ]
    }


header : Element.Element msg
header =
    Header.view (Just Route.Index)


content : Model -> Bool -> Element.Element msg
content model isLoggedIn =
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
            (Element.text "Welcome to the dashboard of my Discord Bot!")
        , loginView isLoggedIn
        , generalStatsView model.generalStatsState
        ]


loginView : Bool -> Element.Element msg
loginView isLoggedIn =
    if not isLoggedIn then
        Element.column
            [ Element.width Element.fill
            , Element.spacingXY 0 25
            ]
            [ Element.el
                [ Font.center
                , Element.centerX
                ]
                (Element.text "You can continue into the dashboard by logging in.")
            , Element.link
                [ Element.centerX
                , Element.paddingXY 15 12
                , Element.Background.color Color.accentBackground
                , Border.rounded 10
                ]
                { url = "http://localhost:3001/api/v1/auth/discord", label = Element.text "Login using Discord" }
            ]

    else
        Element.column
            [ Element.width Element.fill
            , Element.spacingXY 0 25
            ]
            [ Element.el
                [ Font.center
                , Element.centerX
                ]
                (Element.text "You are logged in!")
            , Element.link
                [ Element.centerX
                , Element.paddingXY 15 12
                , Element.Background.color Color.accentBackground
                , Border.rounded 10
                ]
                { url = "http://localhost:3000/server/MOCK_SERVER_ID", label = Element.text "Continue to the dashboard" }
            ]


generalStatsView : GeneralStatsState -> Element.Element msg
generalStatsView generalStatsState =
    case generalStatsState of
        LoadingGeneralStats ->
            Element.el
                [ Font.center
                , Element.centerX
                , Element.paddingXY 0 100
                ]
            <|
                Element.text "Loading general stats..."

        ErrorGeneralStats errorMessage ->
            Element.el
                [ Font.center
                , Element.centerX
                , Element.paddingXY 0 100
                ]
            <|
                Element.text errorMessage

        SuccessGeneralStats generalStats ->
            Element.column
                [ Element.width Element.fill
                , Element.centerX
                , Element.paddingEach { top = 100, left = 0, right = 0, bottom = 20 }
                , Element.spacingXY 0 20
                ]
                [ Element.el (List.concat [ Base.heading2, [ Element.centerX ] ]) (Element.text "General stats")
                , Element.wrappedRow [ Element.centerX, Element.spacingXY 10 0 ]
                    [ StatTile.view "#Servers" (StatTile.IntStatTile generalStats.counts.servers)
                    , StatTile.view "#Channels" (StatTile.IntStatTile generalStats.counts.channels)
                    , StatTile.view "#Users" (StatTile.IntStatTile generalStats.counts.users)
                    , StatTile.view "#Messages" (StatTile.IntStatTile generalStats.counts.messages)
                    , StatTile.view "#Emotes" (StatTile.IntStatTile generalStats.counts.emotes)
                    ]
                ]
