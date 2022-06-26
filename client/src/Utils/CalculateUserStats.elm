module Utils.CalculateUserStats exposing (..)

import List.Extra as LE
import Utils.ListUtils as LU
import Utils.ServerStats as SS


getAllUsers : SS.ServerStats -> List SS.User
getAllUsers serverStats =
    serverStats.stats
        |> List.map .perUser
        |> LU.flatten
        |> List.map (\x -> x.user)
        |> LE.uniqueBy .name


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


type alias UserTotalMessageCountOnDay =
    { date : String
    , count : Int
    }


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
