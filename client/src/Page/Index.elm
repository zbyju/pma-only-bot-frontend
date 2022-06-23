module Page.Index exposing (Model, Msg, init, update, view)

import Browser
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
    { isLoggedIn : Bool
    }


init : String -> ( Model, Cmd Msg )
init _ =
    ( { isLoggedIn = False }
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
    { title = "Index Page"
    , body =
        [ Element.layout [ Element.Background.color Color.primaryBackground, Font.color Color.primaryColor ] <| Element.column [ Element.width Element.fill, Element.height Element.fill ] [ header, content ] ]
    }


header : Element.Element msg
header =
    Header.view (Just Route.Index)


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
            (Element.text "Welcome to the dashboard of my Discord Bot!")
        , login True
        ]


login : Bool -> Element.Element msg
login _ =
    Element.column [ Element.width Element.fill, Element.height Element.fill, Element.spacingXY 0 25 ]
        [ Element.el [ Font.center, Element.centerX ] (Element.text "You can continue into the dashboard by logging in.")
        , Element.link [ Element.centerX, Element.paddingXY 15 12, Element.Background.color Color.accentBackground ] { url = "http://localhost:3001/api/v1/auth/discord", label = Element.text "Login using Discord" }
        ]
