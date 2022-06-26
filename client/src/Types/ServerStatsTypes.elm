module Types.ServerStatsTypes exposing (..)


type alias Server =
    { serverId : String
    , name : String
    }


type alias Emote =
    { emoteId : String
    , name : String
    , url : String
    }


type alias User =
    { userId : String
    , name : String
    }


type alias Channel =
    { channelId : String
    , name : String
    }


type alias ServerStats =
    { stats : List DayStats
    }


type alias DayStats =
    { server : Server
    , date : String
    , perUser : List StatsPerUserPerDay
    , serverStats : ServerStatsPerDay
    }


type alias StatsPerUserPerDay =
    { user : User
    , emotes : List EmoteCount
    , channels : List ChannelCount
    }


type alias EmoteCount =
    { emote : Emote
    , count : Int
    }


type alias ChannelCount =
    { channel : Channel
    , count : Int
    }


type alias ServerStatsPerDay =
    { count : Int
    , perChannel : List StatsPerChannel
    }


type alias StatsPerChannel =
    { channel : Channel
    , count : Int
    }
