module Page.Server exposing (Model, Msg, init, update, view)

import Browser
import Chart as C
import Chart.Attributes as CA
import Component.Header as Header
import Component.StatTile as StatTile
import Component.VerticalSpace as VerticalSpace
import Dropdown
import Element
import Element.Background
import Element.Font as Font
import Html
import Http
import List exposing (concat)
import Route
import Style.Base as Base
import Style.Color as Color
import Utils.CalculateEmoteStats as CES
import Utils.CalculateUserStats as CUS
import Utils.Decode.ServerStatsDecoder as SSDecode
import Utils.ListUtils as LU
import Utils.ServerStats as SS


type ServerStatsState
    = LoadingServerStats
    | ErrorServerStats String
    | SuccessServerStats SS.ServerStats


type alias UserDropdown =
    { state : Dropdown.State
    , selectedUser : Maybe SS.User
    }


type alias EmoteDropdown =
    { state : Dropdown.State
    , selectedEmote : Maybe SS.Emote
    }


type alias Model =
    { apiOrigin : String
    , serverId : String
    , serverStatsState : ServerStatsState
    , users : List SS.User
    , emotes : List SS.Emote
    , userDropdown : UserDropdown
    , emoteDropdown : EmoteDropdown
    }


getServerStats : String -> String -> Cmd Msg
getServerStats apiOrigin serverId =
    Http.get
        { url = apiOrigin ++ "stats/server/" ++ serverId
        , expect = Http.expectJson GotServerStats SSDecode.decodeServerStats
        }


init : ( String, String ) -> ( Model, Cmd Msg )
init ( api, serverId ) =
    ( { serverId = serverId
      , apiOrigin = api
      , serverStatsState = LoadingServerStats
      , users = []
      , emotes = []
      , userDropdown = { state = Dropdown.newState "userDropdown", selectedUser = Nothing }
      , emoteDropdown = { state = Dropdown.newState "emoteDropdown", selectedEmote = Nothing }
      }
    , getServerStats api serverId
    )


type Msg
    = GotServerStats (Result Http.Error SS.ServerStats)
    | SelectedUser (Maybe SS.User)
    | DropdownUserMsg (Dropdown.Msg SS.User)
    | SelectedEmote (Maybe SS.Emote)
    | DropdownEmoteMsg (Dropdown.Msg SS.Emote)


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
                    let
                        users =
                            CUS.getAllUsers serverStats

                        emotes =
                            CES.getAllUsers serverStats
                    in
                    ( { model
                        | serverStatsState = SuccessServerStats serverStats
                        , users = users
                        , emotes = emotes
                      }
                    , Cmd.none
                    )

        DropdownUserMsg dropdownUserMsg ->
            let
                ud =
                    model.userDropdown

                ( updatedDropdownState, dropdownCmd ) =
                    Dropdown.update userDropdownConfig dropdownUserMsg model.userDropdown.state

                updatedUserDropdown =
                    { ud | state = updatedDropdownState }
            in
            ( { model | userDropdown = updatedUserDropdown }
            , dropdownCmd
            )

        SelectedUser selectedUser ->
            let
                ud =
                    model.userDropdown

                updatedUserDropdown =
                    { ud | selectedUser = selectedUser }
            in
            ( { model | userDropdown = updatedUserDropdown }
            , Cmd.none
            )

        DropdownEmoteMsg dropdownEmoteMsg ->
            let
                ed =
                    model.emoteDropdown

                ( updatedDropdownState, dropdownCmd ) =
                    Dropdown.update emoteDropdownConfig dropdownEmoteMsg model.emoteDropdown.state

                updatedEmoteDropdown =
                    { ed | state = updatedDropdownState }
            in
            ( { model | emoteDropdown = updatedEmoteDropdown }
            , dropdownCmd
            )

        SelectedEmote selectedEmote ->
            let
                ed =
                    model.emoteDropdown

                updatedEmoteDropdown =
                    { ed | selectedEmote = selectedEmote }
            in
            ( { model | emoteDropdown = updatedEmoteDropdown }
            , Cmd.none
            )


dropdownConfig : (Maybe a -> Msg) -> (a -> String) -> String -> Dropdown.Config Msg a
dropdownConfig selectedMsg entityToLabel prompt =
    Dropdown.newConfig selectedMsg entityToLabel
        |> Dropdown.withPrompt prompt
        |> Dropdown.withItemClass "dropdown-item"
        |> Dropdown.withMenuClass "dropdown-menu"
        |> Dropdown.withPromptClass "dropdown-prompt"
        |> Dropdown.withSelectedClass "dropdown-selected"
        |> Dropdown.withTriggerClass "dropdown-trigger"
        |> Dropdown.withArrowClass "dropdown-arrow"
        |> Dropdown.withClearClass "dropdown-clear"


userDropdownConfig : Dropdown.Config Msg SS.User
userDropdownConfig =
    dropdownConfig SelectedUser userToDropdownLabel "Select user..."


emoteDropdownConfig : Dropdown.Config Msg SS.Emote
emoteDropdownConfig =
    dropdownConfig SelectedEmote emoteToDropdownLabel "Select emote..."


userToDropdownLabel : SS.User -> String
userToDropdownLabel user =
    user.name


emoteToDropdownLabel : SS.Emote -> String
emoteToDropdownLabel emote =
    emote.name


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


content : Model -> Element.Element Msg
content model =
    case model.serverStatsState of
        LoadingServerStats ->
            Element.column [ Element.width Element.fill, Element.height Element.fill ]
                [ Element.el
                    (concat
                        [ Base.heading1
                        , [ Font.center
                          , Element.centerX
                          , Element.paddingXY 0 50
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
                          , Element.spacingXY 0 50
                          ]
                        ]
                    )
                    (Element.text errorMessage)
                ]

        SuccessServerStats serverStats ->
            Element.column [ Element.width Element.fill, Element.height Element.shrink, Element.spacingXY 0 50 ]
                [ VerticalSpace.view 0
                , serverStatsView serverStats model.emotes
                , emoteUsageView serverStats model.emotes
                , emoteStatsView model serverStats
                , userStatsView model serverStats
                , VerticalSpace.view 100
                ]


emoteStatsView : Model -> SS.ServerStats -> Element.Element Msg
emoteStatsView model serverStats =
    case model.emoteDropdown.selectedEmote of
        Nothing ->
            Element.column [ Element.width Element.fill, Element.height Element.shrink, Element.spacingXY 0 50 ]
                [ selectEmoteView model
                , VerticalSpace.view 50
                ]

        Just se ->
            Element.column [ Element.width Element.fill, Element.height Element.shrink, Element.spacingXY 0 50 ]
                [ selectEmoteView model
                , individualEmoteUsageView serverStats model.emotes se
                , VerticalSpace.view 50
                ]


userStatsView : Model -> SS.ServerStats -> Element.Element Msg
userStatsView model serverStats =
    case model.userDropdown.selectedUser of
        Nothing ->
            Element.column [ Element.width Element.fill, Element.height Element.shrink, Element.spacingXY 0 50 ]
                [ selectUserView model
                , VerticalSpace.view 50
                ]

        Just su ->
            Element.column [ Element.width Element.fill, Element.height Element.shrink, Element.spacingXY 0 50 ]
                [ selectUserView model
                , userMessageNumberView serverStats model.users su
                , VerticalSpace.view 50
                ]


serverStatsView : SS.ServerStats -> List SS.Emote -> Element.Element msg
serverStatsView serverStats emotes =
    Element.column [ Element.width Element.fill, Element.height Element.fill ]
        [ topStatsLastDayView serverStats emotes
        ]


topStatsLastDayView : SS.ServerStats -> List SS.Emote -> Element.Element msg
topStatsLastDayView serverStats emotes =
    let
        emoteUsageStats =
            CES.calculateEmoteUsagePeriods emotes serverStats

        topEmoteLastWeek =
            List.head <| List.reverse <| List.sortBy (\e -> e.countLastWeek) emoteUsageStats

        statTileTopEmoteLastWeek =
            case topEmoteLastWeek of
                Nothing ->
                    StatTile.view "Top emote last week" (StatTile.StringStatTile "No emotes used")

                Just topEmote ->
                    StatTile.view "Top emote last week" (StatTile.UrlStatTile topEmote.emote.url topEmote.emote.name)

        topEmoteLastDay =
            List.head <| List.reverse <| List.sortBy (\e -> e.countLastDay) emoteUsageStats

        statTileTopEmoteLastDay =
            case topEmoteLastDay of
                Nothing ->
                    StatTile.view "Top emote last day" (StatTile.StringStatTile "No emotes used")

                Just topEmote ->
                    StatTile.view "Top emote last day" (StatTile.UrlStatTile topEmote.emote.url topEmote.emote.name)
    in
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacingXY 0 50
        ]
        [ Element.el (concat [ Base.heading1, [ Element.centerX, Font.center ] ]) (Element.text "Top")
        , Element.wrappedRow [ Element.centerX, Element.spacingXY 10 0 ]
            [ StatTile.view "Top user last day" (StatTile.IntStatTile 10)
            , StatTile.view "Top user last week" (StatTile.IntStatTile 10)
            , statTileTopEmoteLastWeek
            , statTileTopEmoteLastDay
            ]
        ]


emoteUsageView : SS.ServerStats -> List SS.Emote -> Element.Element msg
emoteUsageView serverStats emotes =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacingXY 0 50
        ]
        [ Element.el (concat [ Base.heading1, [ Element.centerX, Font.center ] ]) (Element.text "Emote usage")
        , Element.el
            [ Element.width <| Element.px 1200
            , Element.height <| Element.px 300
            , Element.centerX
            ]
          <|
            Element.html <|
                emoteUsageBarChart serverStats emotes
        ]


emoteUsageBarChart : SS.ServerStats -> List SS.Emote -> Html.Html msg
emoteUsageBarChart stats emotes =
    let
        emoteUsageStats =
            CES.calculateEmoteUsagePeriods emotes stats
    in
    C.chart
        [ CA.width 1200
        , CA.height 300
        ]
        [ C.yLabels []
        , C.binLabels (\x -> x.emote.name) [ CA.moveDown 20 ]
        , C.legendsAt .max
            .max
            [ CA.column
            , CA.moveLeft 15
            , CA.alignRight
            , CA.spacing 5
            ]
            []
        , C.bars []
            [ C.stacked
                -- I think there might be a bug and the names colors of the legends are not matching the colors of the bars
                -- That's why I switched the names with data
                [ C.bar .countLastDay [] |> C.named "Last Week"
                , C.bar .countLastWeek [] |> C.named "Last Day"
                ]
            ]
            emoteUsageStats
        ]


userMessageNumberView : SS.ServerStats -> List SS.User -> SS.User -> Element.Element msg
userMessageNumberView serverStats users selectedUser =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacingXY 0 50
        ]
        [ Element.el (concat [ Base.heading1, [ Element.centerX, Font.center ] ]) (Element.text "Number of messages by user")
        , Element.el
            [ Element.width <| Element.px 1200
            , Element.height <| Element.px 300
            , Element.centerX
            ]
          <|
            Element.html <|
                userMessageNumberLineChart serverStats users selectedUser
        ]


individualEmoteUsageView : SS.ServerStats -> List SS.Emote -> SS.Emote -> Element.Element msg
individualEmoteUsageView serverStats emotes selectedEmote =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacingXY 0 50
        ]
        [ Element.el (concat [ Base.heading1, [ Element.centerX, Font.center ] ]) (Element.text "Number of messages with emote")
        , Element.el
            [ Element.width <| Element.px 1200
            , Element.height <| Element.px 300
            , Element.centerX
            ]
          <|
            Element.html <|
                emoteUsageLineChart serverStats emotes selectedEmote
        ]


selectUserView : Model -> Element.Element Msg
selectUserView model =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacingXY 0 50
        ]
        [ Element.el (concat [ Base.heading1, [ Element.centerX, Font.center ] ]) (Element.text "Select user")
        , Element.el
            [ Element.centerX
            ]
          <|
            Element.html <|
                usersDropdownView model
        ]


selectEmoteView : Model -> Element.Element Msg
selectEmoteView model =
    Element.column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacingXY 0 50
        ]
        [ Element.el (concat [ Base.heading1, [ Element.centerX, Font.center ] ]) (Element.text "Select emote")
        , Element.el
            [ Element.centerX
            ]
          <|
            Element.html <|
                emotesDropdownView model
        ]


usersDropdownView : Model -> Html.Html Msg
usersDropdownView model =
    Html.map DropdownUserMsg (Dropdown.view userDropdownConfig model.userDropdown.state model.users model.userDropdown.selectedUser)


emotesDropdownView : Model -> Html.Html Msg
emotesDropdownView model =
    Html.map DropdownEmoteMsg (Dropdown.view emoteDropdownConfig model.emoteDropdown.state model.emotes model.emoteDropdown.selectedEmote)


userMessageNumberLineChart : SS.ServerStats -> List SS.User -> SS.User -> Html.Html msg
userMessageNumberLineChart serverStats users selectedUser =
    let
        userCounts =
            CUS.calculateCountOfUserPerDay serverStats selectedUser

        data =
            userCounts
                |> LU.addIndexToList
                |> List.map (\( i, u ) -> { index = toFloat i, count = toFloat u.count })
    in
    C.chart
        [ CA.width 1200
        , CA.height 300
        ]
        [ C.yLabels []
        , C.xLabels []
        , C.legendsAt .max
            .max
            [ CA.column
            , CA.moveLeft 15
            , CA.alignRight
            , CA.spacing 5
            ]
            []
        , C.series .index
            [ C.interpolated .count [ CA.width 4, CA.monotone ] [] |> C.named selectedUser.name
            ]
            data
        ]


emoteUsageLineChart : SS.ServerStats -> List SS.Emote -> SS.Emote -> Html.Html msg
emoteUsageLineChart serverStats emotes selectedEmote =
    let
        emoteCounts =
            CES.calculateEmoteUsagePerDay serverStats selectedEmote

        data =
            emoteCounts
                |> LU.addIndexToList
                |> List.map (\( i, e ) -> { index = toFloat i, count = toFloat e.count })
    in
    C.chart
        [ CA.width 1200
        , CA.height 300
        ]
        [ C.yLabels []
        , C.xLabels []
        , C.legendsAt .max
            .max
            [ CA.column
            , CA.moveLeft 15
            , CA.alignRight
            , CA.spacing 5
            ]
            []
        , C.series .index
            [ C.interpolated .count [ CA.width 4, CA.monotone ] [] |> C.named selectedEmote.name
            ]
            data
        ]
