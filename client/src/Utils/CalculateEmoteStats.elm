module Utils.CalculateEmoteStats exposing (..)

import List.Extra as LE
import Utils.ServerStats as SS


type alias EmotesUsagePeriods =
    List EmoteUsagePeriods


type alias EmoteUsagePeriods =
    { emote : SS.Emote
    , countLastWeek : Float
    , countLastDay : Float
    }


type alias EmotesUsage =
    List EmoteUsage


type alias EmoteUsage =
    { emote : SS.Emote, count : Float }


calculateEmoteUsagePeriods : SS.ServerStats -> EmotesUsagePeriods
calculateEmoteUsagePeriods serverStats =
    let
        statsLastWeek =
            List.sortBy (\e -> e.emote.name) <| calculateEmoteUsageLastWeek serverStats

        statsLastDay =
            List.sortBy (\e -> e.emote.name) <| calculateEmoteUsageLastDay serverStats

        zippedStats =
            LE.zip statsLastWeek statsLastDay

        statsPeriods =
            zippedStats
                |> List.map
                    (\( lastWeek, lastDay ) ->
                        { emote = lastWeek.emote
                        , countLastWeek = lastWeek.count
                        , countLastDay = lastDay.count
                        }
                    )
    in
    zippedStats
        |> List.map
            (\( lastWeek, lastDay ) ->
                { emote = lastWeek.emote
                , countLastWeek = lastWeek.count
                , countLastDay = lastDay.count
                }
            )


calculateEmoteUsageLastWeek : SS.ServerStats -> EmotesUsage
calculateEmoteUsageLastWeek =
    calculateEmoteUsage


calculateEmoteUsageLastDay : SS.ServerStats -> EmotesUsage
calculateEmoteUsageLastDay serverStats =
    let
        lastDay =
            LE.last serverStats.stats

        lastDayInArray =
            case lastDay of
                Nothing ->
                    []

                Just val ->
                    [ val ]
    in
    calculateEmoteUsage { stats = lastDayInArray }


reduceEmoteUsage : EmotesUsage -> EmotesUsage
reduceEmoteUsage emotesUsage =
    let
        emoteDistinct =
            emotesUsage
                |> LE.uniqueBy (\e -> e.emote.name)
    in
    emoteDistinct
        |> List.map
            (\emote ->
                let
                    emoteCount =
                        emotesUsage
                            |> List.filter (\e -> e.emote.name == emote.emote.name)
                            |> List.map .count
                            |> List.sum
                in
                { emote = emote.emote, count = emoteCount }
            )


calculateEmoteUsage : SS.ServerStats -> EmotesUsage
calculateEmoteUsage serverStats =
    serverStats.stats
        |> List.map calculateEmoteUsagePerDay
        |> flatten
        |> reduceEmoteUsage


calculateEmoteUsagePerDay : SS.DayStats -> EmotesUsage
calculateEmoteUsagePerDay day =
    day.perUser
        |> List.map calculateUserEmoteUsage
        |> flatten


calculateUserEmoteUsage : SS.StatsPerUserPerDay -> EmotesUsage
calculateUserEmoteUsage userUsage =
    List.map (\e -> { emote = e.emote, count = toFloat e.count }) userUsage.emotes


flatten : List (List a) -> List a
flatten list =
    List.foldr (++) [] list
