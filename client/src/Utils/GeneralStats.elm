module Utils.GeneralStats exposing (..)


type alias GeneralStats =
    { counts : GeneralStatsCounts
    }


type alias GeneralStatsCounts =
    { servers : Int
    , channels : Int
    , users : Int
    , messages : Int
    , emotes : Int
    }


getServerCount : GeneralStats -> Int
getServerCount generalStats =
    generalStats.counts.servers


getChannelCount : GeneralStats -> Int
getChannelCount generalStats =
    generalStats.counts.channels


getUserCount : GeneralStats -> Int
getUserCount generalStats =
    generalStats.counts.users


getMessageCount : GeneralStats -> Int
getMessageCount generalStats =
    generalStats.counts.messages


getEmoteCount : GeneralStats -> Int
getEmoteCount generalStats =
    generalStats.counts.emotes
