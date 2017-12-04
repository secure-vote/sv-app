module Models exposing (..)

import Dict exposing (Dict)
import Material
import Models.Ballot exposing (Ballot, BallotId, BallotOption)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (MouseState, Msg)
import Routes exposing (DialogRoute(NotFoundD), Route(DashboardR))
import Time exposing (Time)


type alias Model =
    { mdl : Material.Model
    , democracies : Dict DemocracyId Democracy
    , ballots : Dict BallotId Ballot
    , members : Dict MemberId Member
    , dialogHtml : { title : String, route : DialogRoute Msg }
    , route : Route
    , fields : Dict Int String
    , intFields : Dict Int Int
    , boolFields : Dict Int Bool
    , elevations : Dict Int MouseState
    , now : Time
    }


initModel : Route -> Model
initModel route =
    { mdl = Material.model
    , democracies = Dict.fromList democracies
    , ballots = Dict.fromList ballots
    , members = Dict.fromList members
    , dialogHtml = { title = "", route = NotFoundD }
    , route = route
    , fields = Dict.empty
    , intFields = Dict.empty
    , boolFields = Dict.empty
    , elevations = Dict.empty
    , now = 0
    }


democracies : List ( comparable, Democracy )
democracies =
    [ ( 3623456347
      , Democracy
            "Swarm Fund"
            "Cooperative Ownership Platform for Real Assets"
            "web/img/SwarmFund.svg"
            [ 1234531245, 6345745845, 4578267564, 5745672345, 34574567233, 898732464567 ]
      )
    , ( 4678546564, Democracy "Democracy 1" "Lorem Ipsum" "" [ 4357435345, 4367845333, 7896767563 ] )
    , ( 8567453454, Democracy "Democracy 2" "Lorem Ipsum" "" [ 9065445766, 8654355233, 3578876545 ] )
    , ( 5686543234, Democracy "Democracy 3" "Lorem Ipsum" "" [ 9069546534, 7342132479 ] )
    , ( 8455477864, Democracy "Democracy 4" "Lorem Ipsum" "" [ 8956378645 ] )
    , ( 4567847345, Democracy "Democracy 5" "Lorem Ipsum" "" [] )

    --    , ( 3456346785
    --      , Democracy
    --            "Flux (AUS Federal Parliament)"
    --            "Flux is your way to participate directly in Australian Federal Parliament"
    --            "web/img/Flux.svg"
    --            [ 8678457457 ]
    --      )
    ]


ballots : List ( comparable, Ballot )
ballots =
    --    Swarm Fund Democracy Ballots
    [ ( 1234531245
      , Ballot "Token Release Schedule"
            "This vote is to determine the release schedule of the SWM Token"
            1512000000000
            1612200000000
            [ BallotOption 12341234123 "8 releases of 42 days" "Lorem Ipsum"
            , BallotOption 64564746345 "42 releases of 8 days" "Lorem Ipsum"
            , BallotOption 87967875645 "16 releases of 42 days" "Lorem Ipsum"
            , BallotOption 23457478556 "4 releases of 84 days" "Lorem Ipsum"
            ]
      )
    , ( 6345745845
      , Ballot "Another Important Vote"
            "Some very important details"
            1612000000000
            1612200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 4578267564
      , Ballot "Should Everyone Get Free Money?"
            "Sounds like a good idea to me!"
            1512000000000
            1512100000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 5745672345
      , Ballot "Another Vote"
            "Lorem Ipsum"
            1512000000000
            1712200000000
            [ BallotOption 12341234123 "8 releases of 42 days" "Lorem Ipsum"
            , BallotOption 64564746345 "42 releases of 8 days" "Lorem Ipsum"
            , BallotOption 87967875645 "16 releases of 42 days" "Lorem Ipsum"
            , BallotOption 23457478556 "4 releases of 84 days" "Lorem Ipsum"
            ]
      )
    , ( 34574567233
      , Ballot "Another Vote 2"
            "Some very important details"
            1712000000000
            1712200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 898732464567
      , Ballot "Another Vote 3"
            "Sounds like a good idea to me!"
            1412000000000
            1412100000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )

    --    Democracy 1 Ballots
    , ( 4357435345
      , Ballot "Ballot 1"
            "Lorem Ipsum"
            1512000000000
            1612200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 4367845333
      , Ballot "Ballot 2"
            "Lorem Ipsum"
            1612000000000
            1612200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 7896767563
      , Ballot "Ballot 3"
            "Lorem Ipsum"
            1512000000000
            1512100000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )

    --    Democracy 2 Ballots
    , ( 9065445766
      , Ballot "Ballot 4"
            "Lorem Ipsum"
            1612000000000
            1612200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 8654355233
      , Ballot "Ballot 5"
            "Lorem Ipsum"
            1512000000000
            1512200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 3578876545
      , Ballot "Ballot 6"
            "Lorem Ipsum"
            1512000000000
            1512200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )

    --    Democracy 3 Ballots
    , ( 9069546534
      , Ballot "Ballot 7"
            "Lorem Ipsum"
            1512000000000
            1612200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )
    , ( 7342132479
      , Ballot "Ballot 8"
            "Lorem Ipsum"
            1512000000000
            1512200000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )

    --    Democracy 4 Ballots
    , ( 8956378645
      , Ballot "Ballot 9"
            "Lorem Ipsum"
            1511900000000
            1512000000000
            [ BallotOption 53674567345 "Option 1" "Lorem Ipsum"
            , BallotOption 67845784356 "Option 2" "Lorem Ipsum"
            , BallotOption 89432575544 "Option 3" "Lorem Ipsum"
            , BallotOption 75684568455 "Option 4" "Lorem Ipsum"
            ]
      )

    --    Democracy 5 Ballots
    --    Flux Democracy Ballots
    --    , ( 8678457457, Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" 100 200 [] )
    ]


members : List ( MemberId, Member )
members =
    [ ( 68457345353, Member "John" "Howard" [ 3623456347, 3456346785 ] [] )
    , ( 57657954674, Member "Kim" "Beazley" [ 3623456347 ] [] )
    , ( 95434678684, Member "Julia" "Gillard" [ 3623456347 ] [] )
    , ( 89679067456, Member "Kevin" "Rudd" [ 3456346785 ] [] )
    , ( 76543578984, Member "Tony" "Abbott" [ 3456346785 ] [] )
    ]


type alias MemberId =
    Int


type alias Member =
    { firstName : String
    , lastName : String
    , democracies : List DemocracyId
    , results : List VoteResultId
    }


type alias VoteResultId =
    Int


adminToggleId =
    245748734253
