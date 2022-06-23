module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Flags
import Html
import Page.Index as Index
import Page.NotFound as NotFound
import Page.Server as Server
import Route
import Url


type Model
    = DecodeFlagsError String
    | AppInitialized Navigation.Key String Page


type Page
    = Index Index.Model
    | Server Server.Model
    | NotFound


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
            in
            url
                |> urlToPage api
                |> Tuple.mapFirst (AppInitialized key api)


urlToPage : String -> Url.Url -> ( Page, Cmd Msg )
urlToPage api =
    Route.fromUrl
        >> Maybe.map (routeToPage api)
        >> Maybe.withDefault ( NotFound, Cmd.none )


routeToPage : String -> Route.Route -> ( Page, Cmd Msg )
routeToPage api route =
    case route of
        Route.Index ->
            api
                |> Index.init
                |> Tuple.mapBoth Index (Cmd.map IndexMsg)

        Route.Server serverId ->
            serverId
                |> Server.init
                |> Tuple.mapBoth Server (Cmd.map ServerMsg)


type Msg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
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

        ( ChangedUrl url, AppInitialized key api _ ) ->
            url
                |> urlToPage api
                |> Tuple.mapFirst (AppInitialized key api)

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

        AppInitialized _ _ page ->
            pageView page


pageView : Page -> Browser.Document Msg
pageView page =
    case page of
        NotFound ->
            NotFound.view

        Index indexModel ->
            Index.view IndexMsg indexModel

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
