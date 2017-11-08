module Models exposing (..)

import Material


type alias Model =
    { mdl : Material.Model
    , democracies : List Democracy
    }


initModel : Model
initModel =
    { mdl = Material.model
    , democracies = democracies
    }


type alias Democracy =
    { name : String
    , desc : String
    , ballots : List Ballot
    }


type alias Ballot =
    { name : String
    , desc : String
    , start : String
    , finish : String
    }


democracies : List Democracy
democracies =
    [ Democracy "Swarm Fund" "Cooperative Ownership Platform for Real Assets" [ Ballot "Token Release Schedule" "This vote is to determine the release schedule of the SWM Token" "100" "Vote Ends in 42 minutes" ]
    , Democracy "Flux (AUS Federal Parliament)" "Flux is your way to participate directly in Australian Federal Parliament" [ Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" "100" "Vote Ends in 16 hours" ]
    ]
