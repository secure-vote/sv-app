module Models exposing (..)

import Material
import Msgs exposing (Msg)
import Routes exposing (DialogRoute(NotFoundDialog))


type alias Model =
    { mdl : Material.Model
    , democracies : List Democracy
    , dialogHtml : { title : String, route : DialogRoute Msg }
    }


initModel : Model
initModel =
    { mdl = Material.model
    , democracies = democracies
    , dialogHtml = { title = "", route = NotFoundDialog }
    }


type alias Democracy =
    { name : String
    , desc : String
    , logo : String
    , ballots : List Ballot
    }


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


democracies : List Democracy
democracies =
    [ Democracy "Swarm Fund"
        "Cooperative Ownership Platform for Real Assets"
        "web/img/SwarmFund.svg"
        [ Ballot "Token Release Schedule"
            "This vote is to determine the release schedule of the SWM Token"
            "100"
            "Vote Ends in 42 minutes"
            [ BallotOption 12341234123 "8 releases of 42 days" ""
            , BallotOption 64564746345 "42 releases of 8 days" ""
            , BallotOption 87967875645 "16 releases of 42 days" ""
            , BallotOption 23457478556 "4 releases of 84 days" ""
            ]
        , Ballot "Another Important Vote" "Some very important details" "200" "Vote Ends in 16 hours" []
        , Ballot "Should Everyone Get Free Money?" "Sounds like a good idea to me!" "300" "Vote Ends in 3 days" []
        ]
    , Democracy "Flux (AUS Federal Parliament)" "Flux is your way to participate directly in Australian Federal Parliament" "web/img/Flux.svg" [ Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" "100" "Vote Ends in 16 hours" [] ]
    ]
