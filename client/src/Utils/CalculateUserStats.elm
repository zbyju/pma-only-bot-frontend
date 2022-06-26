module Utils.CalculateUserStats exposing (..)

import List.Extra as LE
import Utils.CalculateEmoteStats as CES
import Utils.ListUtils as LU
import Utils.ServerStats as SS


type alias UserTotalMessageCountOnDay =
    { date : String
    , count : Int
    }


type alias UserCountPeriods =
    { user : SS.User
    , countLastWeek : Float
    , countLastDay : Float
    }


getAllUsers : SS.ServerStats -> List SS.User
getAllUsers serverStats =
    serverStats.stats
        |> List.map .perUser
        |> LU.flatten
        |> List.map (\x -> x.user)
        |> LE.uniqueBy .name
        |> List.sortBy (\user -> String.toLower user.name)


calculateTotalCountOfUser : SS.User -> SS.ServerStats -> Int
calculateTotalCountOfUser user serverStats =
    serverStats.stats
        |> List.map .perUser
        |> LU.flatten
        |> List.filter (\x -> x.user.name == user.name)
        |> List.map .channels
        |> LU.flatten
        |> List.map .count
        |> List.sum


calculateEmoteCountOfUser : SS.User -> SS.ServerStats -> Int
calculateEmoteCountOfUser user serverStats =
    serverStats.stats
        |> List.map .perUser
        |> LU.flatten
        |> List.filter (\x -> x.user.name == user.name)
        |> List.map .emotes
        |> LU.flatten
        |> List.map .count
        |> List.sum


calculateUserCountsPeriods : List SS.User -> SS.ServerStats -> List UserCountPeriods
calculateUserCountsPeriods users serverStats =
    let
        usageLastWeek =
            users
                |> List.map (\user -> ( user, calculateTotalCountOfUser user serverStats ))

        lastDayStats =
            case LE.last serverStats.stats of
                Nothing ->
                    { stats = [] }

                Just lastDay ->
                    { stats = [ lastDay ] }

        usageLastDay =
            users
                |> List.map (\user -> ( user, calculateTotalCountOfUser user lastDayStats ))

        zippedStats =
            LE.zip usageLastWeek usageLastDay

        result =
            zippedStats
                |> List.map
                    (\( ( userLastWeek, countLastWeek ), ( userLastDay, countLastDay ) ) ->
                        { user = userLastWeek
                        , countLastWeek = toFloat countLastWeek
                        , countLastDay = toFloat countLastDay
                        }
                    )
    in
    result


calculateCountOfUserPerDay : SS.ServerStats -> SS.User -> List UserTotalMessageCountOnDay
calculateCountOfUserPerDay serverStats user =
    serverStats.stats
        |> List.map
            (\day ->
                let
                    count =
                        day.perUser
                            |> List.filter (\x -> x.user.name == user.name)
                            |> List.map .channels
                            |> LU.flatten
                            |> List.map .count
                            |> List.sum
                in
                { date = day.date, count = count }
            )
