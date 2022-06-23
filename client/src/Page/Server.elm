module Page.Server exposing (Model, Msg, init, update, view)

import Browser
import Component.GeneralStats as GeneralStats
import Component.Header as Header
import Element
import Element.Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import List exposing (concat)
import Route
import Simple.Transition exposing (backgroundColor)
import Style.Base as Base
import Style.Color as Color


type alias Model =
    { serverId : String
    }


init : String -> ( Model, Cmd Msg )
init serverId =
    ( { serverId = serverId }
    , Cmd.none
    )


type Msg
    = ClickedLogin


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update api msg model =
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
            (Element.text "Server stats")
        ]
