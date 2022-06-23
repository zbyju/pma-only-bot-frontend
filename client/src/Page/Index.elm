module Page.Index exposing (Model, Msg, init, update, view)

import Browser
import Component.Header as Header
import Element
import Element.Background
import Element.Font as Font
import Route
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
    Element.text "Index"
