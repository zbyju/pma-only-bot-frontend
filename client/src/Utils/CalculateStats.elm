module Utils.CalculateStats exposing (..)

import List.Extra as LE
import Utils.ServerStats as SS


type alias EmotesUsagePeriods =
    List EmoteUsagePeriods


type alias EmoteUsagePeriods =
    { name : String
    , countLastWeek : Float
    , countLastDay : Float
    }


type alias EmotesUsage =
    List EmoteUsage


type alias EmoteUsage =
    { name : String, count : Float }


calculateEmoteUsagePeriods : SS.ServerStats -> EmotesUsagePeriods
calculateEmoteUsagePeriods serverStats =
    let
        statsLastWeek =
            List.sortBy .name <| calculateEmoteUsageLastWeek serverStats

        _ =
            Debug.log "week" statsLastWeek

        statsLastDay =
            List.sortBy .name <| calculateEmoteUsageLastDay serverStats

        _ =
            Debug.log "wtf" statsLastDay

        zippedStats =
            LE.zip statsLastWeek statsLastDay

        _ =
            Debug.log "wtf" zippedStats

        statsPeriods =
            zippedStats
                |> List.map
                    (\( lastWeek, lastDay ) ->
                        { name = lastWeek.name
                        , countLastWeek = lastWeek.count
                        , countLastDay = lastDay.count
                        }
                    )

        _ =
            Debug.log "final" statsPeriods
    in
    zippedStats
        |> List.map
            (\( lastWeek, lastDay ) ->
                { name = lastWeek.name
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
        emoteNames =
            emotesUsage
                |> List.map .name
                |> LE.unique

        _ =
            Debug.log "test" emoteNames
    in
    emoteNames
        |> List.map
            (\n ->
                let
                    emoteCount =
                        emotesUsage
                            |> List.filter (\emote -> emote.name == n)
                            |> List.map .count
                            |> List.sum
                in
                { name = n, count = emoteCount }
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
    List.map (\e -> { name = e.emote.name, count = toFloat e.count }) userUsage.emotes


flatten : List (List a) -> List a
flatten list =
    List.foldr (++) [] list
