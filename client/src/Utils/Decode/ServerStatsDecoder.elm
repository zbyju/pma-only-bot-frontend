module Utils.Decode.ServerStatsDecoder exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Types.ServerStatsTypes as SS


decodeServerStats : Decode.Decoder SS.ServerStats
decodeServerStats =
    Decode.map SS.ServerStats
        (Decode.field "stats" (Decode.list decodeDayStats))


decodeDayStats : Decode.Decoder SS.DayStats
decodeDayStats =
    Decode.map4 SS.DayStats
        (Decode.field "server" decodeServer)
        (Decode.field "date" Decode.string)
        (Decode.field "perUser" (Decode.list decodeStatsPerUserPerDay))
        (Decode.field "serverStats" decodeServerStatsPerDay)


decodeStatsPerUserPerDay : Decode.Decoder SS.StatsPerUserPerDay
decodeStatsPerUserPerDay =
    Decode.map3 SS.StatsPerUserPerDay
        (Decode.field "user" decodeUser)
        (Decode.field "emotes" (Decode.list decodeEmoteCount))
        (Decode.field "channels" (Decode.list decodeChannelCount))


decodeEmoteCount : Decode.Decoder SS.EmoteCount
decodeEmoteCount =
    Decode.map2 SS.EmoteCount
        (Decode.field "emote" decodeEmote)
        (Decode.field "count" Decode.int)


decodeChannelCount : Decode.Decoder SS.ChannelCount
decodeChannelCount =
    Decode.map2 SS.ChannelCount
        (Decode.field "channel" decodeChannel)
        (Decode.field "count" Decode.int)


decodeServerStatsPerDay : Decode.Decoder SS.ServerStatsPerDay
decodeServerStatsPerDay =
    Decode.map2 SS.ServerStatsPerDay
        (Decode.field "count" Decode.int)
        (Decode.field "perChannel" (Decode.list decodeStatsPerChannel))


decodeStatsPerChannel : Decode.Decoder SS.StatsPerChannel
decodeStatsPerChannel =
    Decode.map2 SS.StatsPerChannel
        (Decode.field "channel" decodeChannel)
        (Decode.field "count" Decode.int)


decodeServer : Decode.Decoder SS.Server
decodeServer =
    Decode.succeed SS.Server
        |> Pipeline.required "serverId" Decode.string
        |> Pipeline.required "name" Decode.string


decodeEmote : Decode.Decoder SS.Emote
decodeEmote =
    Decode.succeed SS.Emote
        |> Pipeline.required "emoteId" Decode.string
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "url" Decode.string


decodeUser : Decode.Decoder SS.User
decodeUser =
    Decode.succeed SS.User
        |> Pipeline.required "userId" Decode.string
        |> Pipeline.required "name" Decode.string


decodeChannel : Decode.Decoder SS.Channel
decodeChannel =
    Decode.succeed SS.Channel
        |> Pipeline.required "channelId" Decode.string
        |> Pipeline.required "name" Decode.string
