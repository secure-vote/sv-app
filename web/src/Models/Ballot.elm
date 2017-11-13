module Models.Ballot exposing (..)


type alias Ballot =
    { name : String
    , desc : String
    , start : String
    , finish : String
    , options : List BallotOption
    }


type alias BallotOption =
    { id : Int
    , name : String
    , desc : String
    }
