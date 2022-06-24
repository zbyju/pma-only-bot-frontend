module Page.Server exposing (Model, Msg, init, update, view)

import Browser
import Component.Header as Header
import Element
import Element.Background
import Element.Font as Font
import List exposing (concat)
import Route
import Style.Base as Base
import Style.Color as Color


type alias Model =
    { apiOrigin : String
    , serverId : String
    }


init : ( String, String ) -> ( Model, Cmd Msg )
init ( api, serverId ) =
    ( { serverId = serverId, apiOrigin = api }
    , Cmd.none
    )


type Msg
    = ClickedLogin


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLogin ->
            ( model, Cmd.none )


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
                [ header model.serverId, content ]
        ]
    }


header : String -> Element.Element msg
header serverId =
    Header.view (Just <| Route.Server serverId)


content : Element.Element msg
content =
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
            (Element.text "Server")
        ]
