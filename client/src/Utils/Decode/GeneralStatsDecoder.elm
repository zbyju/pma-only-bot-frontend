module Utils.Decode.GeneralStatsDecoder exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Utils.GeneralStats as GS


decodeGeneralStats : Decode.Decoder GS.GeneralStats
decodeGeneralStats =
    Decode.map GS.GeneralStats (Decode.field "counts" decodeGeneralStatsCounts)


decodeGeneralStatsCounts : Decode.Decoder GS.GeneralStatsCounts
decodeGeneralStatsCounts =
    Decode.succeed GS.GeneralStatsCounts
        |> Pipeline.required "servers" Decode.int
        |> Pipeline.required "channels" Decode.int
        |> Pipeline.required "users" Decode.int
        |> Pipeline.required "messages" Decode.int
        |> Pipeline.required "emotes" Decode.int
