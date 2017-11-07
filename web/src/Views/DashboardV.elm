module Views.DashboardV exposing (..)

import Html exposing (Html, div, img, span, text)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Options exposing (cs, styled)
import Material.Typography as Typo
import Models exposing (Model)
import Msgs exposing (Msg(Mdl))


dashboardV : Html Msg
dashboardV =
    let
        content =
            div [] <| List.map democracyCard democracies

        showRecentBallot ballots =
            case List.head ballots of
                Nothing ->
                    []

                Just ballot ->
                    [ Card.actions [ Card.border ]
                        [ text ballot.name
                        , styled span
                            [ cs "tr pa2 absolute bottom-0 right-0"
                            , Typo.caption
                            ]
                            [ text ballot.finish ]
                        ]
                    ]

        democracyCard { name, desc, ballots } =
            Card.view
                [ Elevation.e4, cs "ma3" ]
            <|
                [ Card.title [] [ text name ]
                , Card.text [] [ text desc ]
                ]
                    ++ showRecentBallot ballots
    in
    content


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
