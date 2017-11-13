module Models exposing (..)

import Dict exposing (Dict)
import Material
import Models.Ballot exposing (Ballot, BallotOption)
import Msgs exposing (MouseState, Msg)
import Routes exposing (DialogRoute(NotFoundDialog), Route(DashboardR))


type alias Model =
    { mdl : Material.Model
    , democracies : Dict Int Democracy
    , dialogHtml : { title : String, route : DialogRoute Msg }
    , route : Route
    , currentDemocracy : Democracy
    , currentBallot : Ballot
    , elevations : Dict Int MouseState
    }


initModel : Model
initModel =
    { mdl = Material.model
    , democracies = Dict.fromList democracies
    , dialogHtml = { title = "", route = NotFoundDialog }
    , route = DashboardR
    , currentDemocracy = Democracy "" "" "" []
    , currentBallot = Ballot "" "" "" "" []
    , elevations = Dict.empty
    }


type alias Democracy =
    { name : String
    , desc : String
    , logo : String
    , ballots : List Ballot
    }


democracies : List ( comparable, Democracy )
democracies =
    [ ( 3623456347
      , Democracy
            "Swarm Fund"
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
      )
    , ( 3456346785
      , Democracy
            "Flux (AUS Federal Parliament)"
            "Flux is your way to participate directly in Australian Federal Parliament"
            "web/img/Flux.svg"
            [ Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" "100" "Vote Ends in 16 hours" [] ]
      )
    ]
