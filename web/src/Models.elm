module Models exposing (..)

import Dict exposing (Dict)
import Material
import Models.Ballot exposing (Ballot, BallotId, BallotOption)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (MouseState, Msg)
import Routes exposing (DialogRoute(NotFoundDialog), Route(DashboardR))


type alias Model =
    { mdl : Material.Model
    , democracies : Dict DemocracyId Democracy
    , ballots : Dict BallotId Ballot
    , dialogHtml : { title : String, route : DialogRoute Msg }
    , route : Route
    , elevations : Dict Int MouseState
    }


initModel : Route -> Model
initModel route =
    { mdl = Material.model
    , democracies = Dict.fromList democracies
    , ballots = Dict.fromList ballots
    , dialogHtml = { title = "", route = NotFoundDialog }
    , route = route
    , elevations = Dict.empty
    }


democracies : List ( comparable, Democracy )
democracies =
    [ ( 3623456347
      , Democracy
            "Swarm Fund"
            "Cooperative Ownership Platform for Real Assets"
            "web/img/SwarmFund.svg"
            [ 1234531245, 6345745845, 4578267564 ]
      )
    , ( 3456346785
      , Democracy
            "Flux (AUS Federal Parliament)"
            "Flux is your way to participate directly in Australian Federal Parliament"
            "web/img/Flux.svg"
            [ 8678457457 ]
      )
    ]


ballots : List ( comparable, Ballot )
ballots =
    [ ( 1234531245
      , Ballot "Token Release Schedule"
            "This vote is to determine the release schedule of the SWM Token"
            "100"
            "Vote Ends in 42 minutes"
            [ BallotOption 12341234123 "8 releases of 42 days" ""
            , BallotOption 64564746345 "42 releases of 8 days" ""
            , BallotOption 87967875645 "16 releases of 42 days" ""
            , BallotOption 23457478556 "4 releases of 84 days" ""
            ]
      )
    , ( 6345745845, Ballot "Another Important Vote" "Some very important details" "200" "Vote Ends in 16 hours" [] )
    , ( 4578267564, Ballot "Should Everyone Get Free Money?" "Sounds like a good idea to me!" "300" "Vote Ends in 3 days" [] )
    , ( 8678457457, Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" "100" "Vote Ends in 16 hours" [] )
    ]
