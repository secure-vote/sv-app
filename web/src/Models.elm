module Models exposing (..)

import Dict exposing (Dict)
import Material
import Material.Snackbar
import Models.Ballot exposing (Ballot, BallotId, BallotOption, Vote, VoteConfirmStatus(AwaitingConfirmation), VoteId, VoteOption)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (MouseState, Msg)
import Routes exposing (DialogRoute(NotFoundD), Route(DashboardR, DemocracyR))
import Styles.Styles exposing (StyleOption(SvStyle, SwmStyle))
import Time exposing (Time)


type alias Model =
    { mdl : Material.Model
    , democracies : Dict DemocracyId Democracy
    , ballots : Dict BallotId Ballot
    , votes : Dict VoteId Vote
    , members : Dict MemberId Member
    , showDialog : Bool
    , dialogHtml : { title : String, route : DialogRoute Msg }
    , voteConfirmStatus : VoteConfirmStatus
    , routeStack : List Route
    , fields : Dict Int String
    , intFields : Dict Int Int
    , floatFields : Dict Int Float
    , boolFields : Dict Int Bool
    , elevations : Dict Int MouseState
    , snack : Material.Snackbar.Model String
    , now : Time
    , isLoading : Bool
    , isDemocracyLevel : Bool
    , globalStyle : StyleOption
    , singleDemocName : String
    }


initModel : Model
initModel =
    { mdl = Material.model
    , democracies = Dict.fromList democracies
    , ballots = Dict.fromList ballots
    , members = Dict.fromList members
    , votes = Dict.fromList votes
    , showDialog = False
    , dialogHtml = { title = "", route = NotFoundD }
    , voteConfirmStatus = AwaitingConfirmation
    , routeStack = [ DashboardR ]
    , fields = Dict.empty
    , intFields = Dict.empty
    , floatFields = Dict.empty
    , boolFields = Dict.empty
    , elevations = Dict.empty
    , snack = Material.Snackbar.model
    , now = 0
    , isLoading = True
    , isDemocracyLevel = False
    , globalStyle = SvStyle
    , singleDemocName = ""
    }


initModelWithFlags : Flags -> Model
initModelWithFlags flags =
    { mdl = Material.model
    , democracies = Dict.fromList democracies
    , ballots = Dict.fromList ballots
    , members = Dict.fromList members
    , votes = Dict.fromList votes
    , showDialog = False
    , dialogHtml = { title = "", route = NotFoundD }
    , voteConfirmStatus = AwaitingConfirmation
    , routeStack = [ DemocracyR flags.democracyId ]
    , fields = Dict.empty
    , intFields = Dict.empty
    , floatFields = Dict.empty
    , boolFields = Dict.empty
    , elevations = Dict.empty
    , snack = Material.Snackbar.model
    , now = 0
    , isLoading = True
    , isDemocracyLevel = True
    , globalStyle = SwmStyle
    , singleDemocName = flags.singleDemocName
    }


type alias Flags =
    { votingPrivKey : String
    , democracyId : Int
    , admin : Bool
    , singleDemocName : String
    }


democracies : List ( comparable, Democracy )
democracies =
    [ ( 31
      , Democracy
            "Swarm Fund"
            "Cooperative Ownership Platform for Real Assets"
            "web/img/SwarmFund.svg"
            [ 1234531245, 6345745845, 4578267564, 5745672345, 34574567233, 898732464567 ]
      )
    , ( 37, Democracy "Democracy 1" "Lorem Ipsum" "" [ 4357435345, 4367845333, 7896767563 ] )
    , ( 41, Democracy "Democracy 2" "Lorem Ipsum" "" [ 9065445766, 8654355233, 3578876545 ] )
    , ( 43, Democracy "Democracy 3" "Lorem Ipsum" "" [ 9069546534, 7342132479 ] )
    , ( 47, Democracy "Democracy 4" "Lorem Ipsum" "" [ 8956378645 ] )
    , ( 53, Democracy "Democracy 5" "Lorem Ipsum" "" [] )

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
            1517707141000
            [ BallotOption 12341234123 "8 releases of 42 days" "Lorem Ipsum" Nothing
            , BallotOption 64564746345 "42 releases of 8 days" "Lorem Ipsum" Nothing
            , BallotOption 87967875645 "16 releases of 42 days" "Lorem Ipsum" Nothing
            , BallotOption 23457478556 "4 releases of 84 days" "Lorem Ipsum" Nothing
            ]
      )
    , ( 6345745845
      , Ballot "Another Important Vote"
            "Some very important details"
            1552000000000
            1612200000000
            [ BallotOption 835957160 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 425037868 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 935616461 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 571023541 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 4578267564
      , Ballot "Should Everyone Get Free Money?"
            "Sounds like a good idea to me!"
            1512000000000
            1512100000000
            [ BallotOption 140807079 "Option 1" "Lorem Ipsum" <| Just 56
            , BallotOption 185109319 "Option 2" "Lorem Ipsum" <| Just 3
            , BallotOption 411788625 "Option 3" "Lorem Ipsum" <| Just -45
            , BallotOption 541178496 "Option 4" "Lorem Ipsum" <| Just 28
            ]
      )
    , ( 5745672345
      , Ballot "Another Vote"
            "Lorem Ipsum"
            1512000000000
            1712200000000
            [ BallotOption 930099084 "8 releases of 42 days" "Lorem Ipsum" Nothing
            , BallotOption 207817966 "42 releases of 8 days" "Lorem Ipsum" Nothing
            , BallotOption 823702175 "16 releases of 42 days" "Lorem Ipsum" Nothing
            , BallotOption 508428413 "4 releases of 84 days" "Lorem Ipsum" Nothing
            ]
      )
    , ( 34574567233
      , Ballot "Another Vote 2"
            "Some very important details"
            1612000000000
            1712200000000
            [ BallotOption 821621025 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 784842911 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 466772458 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 347005445 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 898732464567
      , Ballot "Another Vote 3"
            "Sounds like a good idea to me!"
            1412000000000
            1412100000000
            [ BallotOption 663625795 "Option 1" "Lorem Ipsum" <| Just 4
            , BallotOption 640544893 "Option 2" "Lorem Ipsum" <| Just 6
            , BallotOption 401833762 "Option 3" "Lorem Ipsum" <| Just 2
            , BallotOption 900899269 "Option 4" "Lorem Ipsum" <| Just 7
            ]
      )

    --    Democracy 1 Ballots
    , ( 4357435345
      , Ballot "Ballot 1"
            "Lorem Ipsum"
            1512000000000
            1612200000000
            [ BallotOption 224275794 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 478275981 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 541189738 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 486581765 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 4367845333
      , Ballot "Ballot 2"
            "Lorem Ipsum"
            1612000000000
            1612200000000
            [ BallotOption 538092582 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 559408735 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 490932278 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 647860056 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 7896767563
      , Ballot "Ballot 3"
            "Lorem Ipsum"
            1512000000000
            1512100000000
            [ BallotOption 709173604 "Option 1" "Lorem Ipsum" <| Just 1
            , BallotOption 206973721 "Option 2" "Lorem Ipsum" <| Just 0
            , BallotOption 141835804 "Option 3" "Lorem Ipsum" <| Just 0
            , BallotOption 813648825 "Option 4" "Lorem Ipsum" <| Just 4
            ]
      )

    --    Democracy 2 Ballots
    , ( 9065445766
      , Ballot "Ballot 4"
            "Lorem Ipsum"
            1612000000000
            1612200000000
            [ BallotOption 316654166 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 312499893 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 385986258 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 149124977 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 8654355233
      , Ballot "Ballot 5"
            "Lorem Ipsum"
            1512000000000
            1512200000000
            [ BallotOption 599409902 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 815947266 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 928514180 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 378184496 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 3578876545
      , Ballot "Ballot 6"
            "Lorem Ipsum"
            1512000000000
            1512200000000
            [ BallotOption 499458533 "Option 1" "Lorem Ipsum" <| Just 43
            , BallotOption 931278671 "Option 2" "Lorem Ipsum" <| Just 43
            , BallotOption 544083422 "Option 3" "Lorem Ipsum" <| Just 34
            , BallotOption 442394343 "Option 4" "Lorem Ipsum" <| Just 13
            ]
      )

    --    Democracy 3 Ballots
    , ( 9069546534
      , Ballot "Ballot 7"
            "Lorem Ipsum"
            1512000000000
            1612200000000
            [ BallotOption 409173097 "Option 1" "Lorem Ipsum" Nothing
            , BallotOption 114144673 "Option 2" "Lorem Ipsum" Nothing
            , BallotOption 669948220 "Option 3" "Lorem Ipsum" Nothing
            , BallotOption 912386093 "Option 4" "Lorem Ipsum" Nothing
            ]
      )
    , ( 7342132479
      , Ballot "Ballot 8"
            "Lorem Ipsum"
            1512000000000
            1512200000000
            [ BallotOption 698581880 "Option 1" "Lorem Ipsum" <| Just 4
            , BallotOption 246697343 "Option 2" "Lorem Ipsum" <| Just 43
            , BallotOption 292648287 "Option 3" "Lorem Ipsum" <| Just 1
            , BallotOption 951412388 "Option 4" "Lorem Ipsum" <| Just 43
            ]
      )

    --    Democracy 4 Ballots
    , ( 8956378645
      , Ballot "Ballot 9"
            "Lorem Ipsum"
            1511900000000
            1512000000000
            [ BallotOption 666944030 "Option 1" "Lorem Ipsum" <| Just 64
            , BallotOption 278272143 "Option 2" "Lorem Ipsum" <| Just 34
            , BallotOption 177875907 "Option 3" "Lorem Ipsum" <| Just 65
            , BallotOption 597943144 "Option 4" "Lorem Ipsum" <| Just 86
            ]
      )

    --    Democracy 5 Ballots
    --    Flux Democracy Ballots
    --    , ( 8678457457, Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" 100 200 [] )
    ]


votes : List ( VoteId, Vote )
votes =
    [--    ( 63634563243
     --      , Vote 1234531245
     --            [ VoteOption 12341234123 2
     --            , VoteOption 64564746345 -3
     --            , VoteOption 87967875645 0
     --            , VoteOption 23457478556 3
     --            ]
     --      )
    ]


members : List ( MemberId, Member )
members =
    [ ( 68457345353, Member "John" "Howard" [ 3623456347, 3456346785 ] )
    , ( 57657954674, Member "Kim" "Beazley" [ 3623456347 ] )
    , ( 95434678684, Member "Julia" "Gillard" [ 3623456347 ] )
    , ( 89679067456, Member "Kevin" "Rudd" [ 3456346785 ] )
    , ( 76543578984, Member "Tony" "Abbott" [ 3456346785 ] )
    ]


type alias MemberId =
    Int


type alias Member =
    { firstName : String
    , lastName : String
    , democracies : List DemocracyId
    }


adminToggleId : Int
adminToggleId =
    245748734253


type alias BallotCategory =
    -- ( Name, Parent ) --
    ( String, String )


ballotCategories : List BallotCategory
ballotCategories =
    [ ( "Financial", "SwarmFoundation" )
    , ( "Budgeting", "Financial" )
    , ( "Projects", "SwarmFoundation" )
    , ( "GreenLighting", "Projects" )
    ]
