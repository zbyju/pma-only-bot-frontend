module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Flags
import Html
import Http
import Json.Decode as Decode
import Page.Index as Index
import Page.NotFound as NotFound
import Page.Server as Server
import Route
import Url


type Model
    = DecodeFlagsError String
    | AppInitialized Navigation.Key ( String, Bool ) Page


type Page
    = Index Index.Model
    | Server Server.Model
    | NotFound


type alias AuthStatus =
    { isAuthenticated : Bool }


init : Flags.RawFlags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init rawFlags url key =
    case Flags.decodeFlags rawFlags of
        Err decodeFlagsError ->
            ( DecodeFlagsError decodeFlagsError
            , Cmd.none
            )

        Ok flags ->
            let
                api =
                    Flags.toBaseApiUrl flags

                res =
                    url
                        |> urlToPage ( api, False )
                        |> Tuple.mapFirst (AppInitialized key ( api, False ))
            in
            ( Tuple.first res, Cmd.batch [ Tuple.second res, getAuthStatus api ] )


urlToPage : ( String, Bool ) -> Url.Url -> ( Page, Cmd Msg )
urlToPage ( api, isLoggedIn ) =
    Route.fromUrl
        >> Maybe.map (routeToPage ( api, isLoggedIn ))
        >> Maybe.withDefault ( NotFound, Cmd.none )


routeToPage : ( String, Bool ) -> Route.Route -> ( Page, Cmd Msg )
routeToPage ( api, isLoggedIn ) route =
    case route of
        Route.Index ->
            ( api, isLoggedIn )
                |> Index.init
                |> Tuple.mapBoth Index (Cmd.map IndexMsg)

        Route.Server serverId ->
            ( api, serverId )
                |> Server.init
                |> Tuple.mapBoth Server (Cmd.map ServerMsg)


getAuthStatus : String -> Cmd Msg
getAuthStatus apiOrigin =
    Http.riskyRequest
        { method = "GET"
        , headers = []
        , url = apiOrigin ++ "auth/discord/status"
        , body = Http.emptyBody
        , expect = Http.expectJson GotAuthStatus decodeAuthStatus
        , timeout = Nothing
        , tracker = Nothing
        }


decodeAuthStatus : Decode.Decoder AuthStatus
decodeAuthStatus =
    Decode.map AuthStatus (Decode.field "isAuthenticated" Decode.bool)


type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | GotAuthStatus (Result Http.Error AuthStatus)
    | IndexMsg Index.Msg
    | ServerMsg Server.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, AppInitialized key _ _ ) ->
            ( model
            , case urlRequest of
                Browser.Internal url ->
                    url
                        |> Url.toString
                        |> Navigation.pushUrl key

                Browser.External href ->
                    Navigation.load href
            )

        ( ChangedUrl url, AppInitialized key ( api, authStatus ) _ ) ->
            url
                |> urlToPage ( api, authStatus )
                |> Tuple.mapFirst (AppInitialized key ( api, authStatus ))

        ( IndexMsg indexMsg, AppInitialized key ( api, authStatus ) (Index indexModel) ) ->
            indexModel
                |> Index.update indexMsg
                |> Tuple.mapBoth (Index >> AppInitialized key ( api, authStatus )) (Cmd.map IndexMsg)

        ( ServerMsg serverMsg, AppInitialized key ( api, authStatus ) (Server serverModel) ) ->
            serverModel
                |> Server.update serverMsg
                |> Tuple.mapBoth (Server >> AppInitialized key ( api, authStatus )) (Cmd.map ServerMsg)

        ( GotAuthStatus authStatusResult, AppInitialized key ( api, _ ) page ) ->
            case authStatusResult of
                Err _ ->
                    ( AppInitialized key ( api, False ) page, Cmd.none )

                Ok authStatus ->
                    ( AppInitialized key ( api, authStatus.isAuthenticated ) page, Cmd.none )

        _ ->
            ( model
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    case model of
        DecodeFlagsError _ ->
            { title = "Decode Flags Error"
            , body = [ Html.div [] [ Html.text "Something went wrong with flags decoding ..." ] ]
            }

        AppInitialized _ ( _, isLoggedIn ) page ->
            pageView page isLoggedIn


pageView : Page -> Bool -> Browser.Document Msg
pageView page isLoggedIn =
    case page of
        NotFound ->
            NotFound.view

        Index indexModel ->
            Index.view IndexMsg isLoggedIn indexModel

        Server serverModel ->
            Server.view ServerMsg serverModel


main : Program Flags.RawFlags Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
