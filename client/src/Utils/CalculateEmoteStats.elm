module Utils.CalculateEmoteStats exposing (..)

import List.Extra as LE
import Types.ServerStatsTypes as SS
import Utils.ListUtils as LU


type alias EmoteUsagePeriods =
    { emote : SS.Emote
    , countLastWeek : Float
    , countLastDay : Float
    }


type alias EmoteUsage =
    { emote : SS.Emote, count : Float }


type alias EmoteUsageOnDay =
    { date : String
    , count : Int
    }


getAllUsers : SS.ServerStats -> List SS.Emote
getAllUsers serverStats =
    serverStats.stats
        |> List.map .perUser
        |> LU.flatten
        |> List.map (\x -> x.emotes)
        |> LU.flatten
        |> List.map .emote
        |> LE.uniqueBy .name
        |> List.sortBy (\emote -> String.toLower emote.name)


calculateEmoteUsage : SS.ServerStats -> SS.Emote -> EmoteUsage
calculateEmoteUsage serverStats emote =
    { emote = emote
    , count =
        toFloat
            (serverStats.stats
                |> List.map .perUser
                |> LU.flatten
                |> List.map .emotes
                |> LU.flatten
                |> List.filter (\x -> x.emote.name == emote.name)
                |> List.map .count
                |> List.sum
            )
    }


calculateEmoteUsageByUser : SS.ServerStats -> SS.User -> SS.Emote -> EmoteUsage
calculateEmoteUsageByUser serverStats user emote =
    { emote = emote
    , count =
        toFloat
            (serverStats.stats
                |> List.map .perUser
                |> LU.flatten
                |> List.filter (\x -> x.user.name == user.name)
                |> List.map .emotes
                |> LU.flatten
                |> List.filter (\x -> x.emote.name == emote.name)
                |> List.map .count
                |> List.sum
            )
    }


calculateEmoteUsageForEmotes : List SS.Emote -> SS.ServerStats -> List EmoteUsage
calculateEmoteUsageForEmotes emotes serverStats =
    emotes
        |> List.map (calculateEmoteUsage serverStats)


calculateEmoteUsageByUserForEmotes : List SS.Emote -> SS.ServerStats -> SS.User -> List EmoteUsage
calculateEmoteUsageByUserForEmotes emotes serverStats user =
    emotes
        |> List.map (calculateEmoteUsageByUser serverStats user)


calculateEmoteUsagePeriods : List SS.Emote -> SS.ServerStats -> List EmoteUsagePeriods
calculateEmoteUsagePeriods emotes serverStats =
    let
        usageLastWeek =
            calculateEmoteUsageForEmotes emotes serverStats

        lastDayStats =
            case LE.last serverStats.stats of
                Nothing ->
                    { stats = [] }

                Just lastDay ->
                    { stats = [ lastDay ] }

        usageLastDay =
            calculateEmoteUsageForEmotes emotes lastDayStats

        zippedStats =
            LE.zip usageLastWeek usageLastDay

        result =
            zippedStats
                |> List.map
                    (\( lastWeek, lastDay ) ->
                        { emote = lastWeek.emote
                        , countLastWeek = lastWeek.count
                        , countLastDay = lastDay.count
                        }
                    )
    in
    result


calculateEmoteUsagePerDay : SS.ServerStats -> SS.Emote -> List EmoteUsageOnDay
calculateEmoteUsagePerDay serverStats emote =
    serverStats.stats
        |> List.map
            (\day ->
                let
                    count =
                        day.perUser
                            |> List.map .emotes
                            |> LU.flatten
                            |> List.filter (\x -> x.emote.name == emote.name)
                            |> List.map .count
                            |> List.sum
                in
                { date = day.date, count = count }
            )
