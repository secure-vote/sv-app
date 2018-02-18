module Models exposing (..)

import Dict exposing (Dict)
import Element.Input as Input exposing (SelectMsg, SelectWith)
import Json.Decode exposing (Value)
import Models.Ballot exposing (Ballot, BallotId, BallotOption, BallotState(BallotConfirmed))
import Models.Democracy exposing (Delegate, DelegateState(Inactive), Democracy, DemocracyId)
import Models.Vote exposing (Vote, VoteId)
import Msgs exposing (..)
import Routes exposing (DialogRoute(NotFoundD), Route(DashboardR, DemocracyR))
import Styles.Styles exposing (StyleOption(SvStyle, SwmStyle))
import Time exposing (Time)


type alias Model =
    { democracies : Dict DemocracyId Democracy
    , ballots : Dict BallotId Ballot
    , votes : Dict VoteId Vote
    , members : Dict MemberId Member
    , showDialog : Bool
    , dialogHtml : { title : String, route : DialogRoute Msg }
    , localStorage : Dict String String
    , txReceipts : Dict String BcRequest
    , routeStack : List Route
    , fields : Dict String String
    , intFields : Dict String Int
    , floatFields : Dict String Float
    , boolFields : Dict String Bool
    , selectFields : Dict String (SelectWith DurationType Msg)
    , now : Time
    , isLoading : Bool
    , isDemocracyLevel : Bool
    , isAdmin : Bool
    , globalStyle : StyleOption
    , singleDemocName : String
    }


initModel : Model
initModel =
    { democracies = Dict.fromList democracies
    , ballots = Dict.fromList ballots
    , members = Dict.fromList members
    , votes = Dict.fromList votes
    , showDialog = False
    , dialogHtml = { title = "", route = NotFoundD }
    , localStorage = Dict.empty
    , txReceipts = Dict.empty
    , routeStack = [ DashboardR ]
    , fields = Dict.empty
    , intFields = Dict.empty
    , floatFields = Dict.empty
    , boolFields = Dict.empty
    , selectFields = Dict.empty
    , now = 0
    , isLoading = True
    , isDemocracyLevel = False
    , isAdmin = False
    , globalStyle = SvStyle
    , singleDemocName = ""
    }


initModelWithFlags : Flags -> Model
initModelWithFlags flags =
    { democracies = Dict.fromList democracies
    , ballots = Dict.fromList ballots
    , members = Dict.fromList members
    , votes = Dict.fromList votes
    , showDialog = False
    , dialogHtml = { title = "", route = NotFoundD }
    , localStorage = Dict.empty
    , txReceipts = Dict.empty
    , routeStack = [ DemocracyR flags.democracyId ]
    , fields = Dict.empty
    , intFields = Dict.empty
    , floatFields = Dict.empty
    , boolFields = Dict.empty
    , selectFields = Dict.empty
    , now = 0
    , isLoading = True
    , isDemocracyLevel = True
    , isAdmin = flags.admin
    , globalStyle = SwmStyle
    , singleDemocName = flags.singleDemocName
    }


type alias Flags =
    { votingPrivKey : String
    , democracyId : Int
    , admin : Bool
    , singleDemocName : String
    }


lSKeys =
    { debugLog = "debugLog" }


democracies : List ( comparable, Democracy )
democracies =
    [ ( 31
      , Democracy
            "Swarm Fund"
            "Cooperative Ownership Platform for Real Assets"
            "web/img/SwarmFund.svg"
            -- TODO: ballots should not be referred to by ID in democ
            -- TODO: rather ballots should be tagged with democs
            -- TODO: ideally this is through a map of DemocId -> BallotId
            -- TODO: or DemocId -> Ballot
            [ 1234531245, 6345745845, 394873947 ]
            (Delegate "" Inactive)
      )
    , ( 37, Democracy "Democracy 1" "Lorem Ipsum" "" [ 4357435345, 4367845333, 7896767563 ] (Delegate "" Inactive) )
    , ( 41, Democracy "Democracy 2" "Lorem Ipsum" "" [ 9065445766, 8654355233, 3578876545 ] (Delegate "" Inactive) )
    , ( 43, Democracy "Democracy 3" "Lorem Ipsum" "" [ 9069546534, 7342132479 ] (Delegate "" Inactive) )
    , ( 47, Democracy "Democracy 4" "Lorem Ipsum" "" [ 8956378645 ] (Delegate "" Inactive) )
    , ( 53, Democracy "Democracy 5" "Lorem Ipsum" "" [] (Delegate "" Inactive) )

    --    , ( 3456346785
    --      , Democracy
    --            "Flux (AUS Federal Parliament)"
    --            "Flux is your way to participate directly in Australian Federal Parliament"
    --            "web/img/Flux.svg"
    --            [ 8678457457 ]
    --      )
    ]



-- 1516290447 - 10:47am 18th - EST (US)


capRaiseDesc : String
capRaiseDesc =
    """This ballot is to determine if the fund should raise additional funds through an increase in the token supply."""


strategyDescription : String
strategyDescription =
    """This ballot is to determine the strategy of Phase 2. Options are either to expand hoizontally (geographically) or vertically (increased investment to existing sites)."""


continuationDescription : String
continuationDescription =
    """This ballot is the regular fund continuation ballot to determine if the fund will continue operation or wind down and distribute funds to syndicate participants."""



-- TODO: Organise ballots better; map from Democ -> Ballot
-- TODO: See TODOs in `democracies` for more.


ballots : List ( comparable, Ballot )
ballots =
    --    Swarm Fund Democracy Ballots
    [ ( 1234531245
      , Ballot "Capital Raise, round 2"
            capRaiseDesc
            {- 2 weeks in past -} 1515070400000
            1515595200000
            [ BallotOption 12341234123
                "No Raise"
                "Perform no capital raise, do not increase token supply."
                (Just -3588)
            , BallotOption 64564746345
                "Raise 50,000 SUN"
                "This increases the capital of the fund by 50,000 SUN and represents a 2% increase to the token supply. This is the minimum capital raise.  See `Documents` for more information including budget and strategy."
                (Just -1207)
            , BallotOption 87967875645
                "Raise 200,000 SUN"
                "This increases the capital of the fund by 200,000 SUN and represents an 8% increase to the token supply. See `Documents` for more information including budget and strategy."
                (Just 12437)
            , BallotOption 23457478556
                "Raise 500,000 SUN"
                "This increases the capital of the fund by 500,000 SUN and represents a 20% increase to the token supply. See `Documents` for more information including budget and strategy."
                (Just 2122)
            ]
            BallotConfirmed
      )
    , ( 6345745845
      , Ballot "Strategy Phase 2"
            strategyDescription
            {- now -} 1516004800000
            1520004800000
            [ BallotOption 835957160
                "Purchase new property in Brazil"
                "This option for phase 2 will result in approx 200,000 SUN invested into new property aquisitions in San Palo and Rio de Janeiro. See `Documents` for more information."
                Nothing
            , BallotOption 425037868
                "Purchase new property in Czech Republic"
                "This option for phase 2 will result in approx 200,000 SUN invested into new property aquisitions in Prauge and surrounding areas. See `Documents` for more information."
                Nothing
            , BallotOption 935616461
                "Increase property holding in Seoul"
                "This option for phase 2 will result in approx 200,000 SUN invested into new property aquisitions in Soul and surrounding areas. See `Documents` for more information."
                Nothing
            , BallotOption 571023541
                "Increase property holding in Detroit"
                "This option for phase 2 will result in approx 200,000 SUN invested into new property aquisitions in Detroit and surrounding areas. See `Documents` for more information."
                Nothing
            ]
            BallotConfirmed
      )
    , ( 394873947
      , Ballot "Yearly Fund Continuation"
            continuationDescription
            {- July 1 2018 -} 1530403200000
            1531008000000
            [ BallotOption 83534987160
                "Wind Down Fund"
                "This option will result in the fund ceasing operations, liquidating assets, and distributing the result between all investors."
                Nothing
            , BallotOption 3498733466
                "Contiue Operations"
                "This option will result in the fund continuing operations."
                Nothing
            ]
            BallotConfirmed
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



-- Deprecated
--adminToggleId : Int
--adminToggleId =
--    245748734253
-- Not yet in use.


type alias BallotCategory =
    -- ( Name, Parent ) --
    ( String, String )



-- Not yet in use.


ballotCategories : List BallotCategory
ballotCategories =
    [ ( "Financial", "SwarmFoundation" )
    , ( "Budgeting", "Financial" )
    , ( "Projects", "SwarmFoundation" )
    , ( "GreenLighting", "Projects" )
    ]
