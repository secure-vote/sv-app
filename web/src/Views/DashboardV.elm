module Views.DashboardV exposing (..)

import Html exposing (Html, div, img, span, text)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, styled)
import Material.Typography as Typo
import Models exposing (Model)
import Msgs exposing (Msg)


dashboardV : Model -> Html Msg
dashboardV model =
    let
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
                [ Elevation.e4
                , cs "ma4"
                , css "width" "auto"
                ]
            <|
                [ Card.title [] [ text name ]
                , Card.text [] [ text desc ]
                ]
                    ++ showRecentBallot ballots
    in
    div [] <| List.map democracyCard model.democracies


dashboardH : List (Html m)
dashboardH =
    [ Layout.title [] [ text "Your Democracies" ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link [ cs "ba br-pill" ]
            [ text "Join"
            , Icon.i "add"
            ]
        ]
    ]
