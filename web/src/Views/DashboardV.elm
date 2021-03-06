module Views.DashboardV exposing (..)

import Components.CardElevation exposing (elevation)
import Date
import Dict
import Helpers exposing (getBallot)
import Html exposing (Html, a, div, img, span, text)
import Material.Card as Card
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Typography as Typo
import Models exposing (Model)
import Msgs exposing (MouseState(..), Msg(NavigateTo, SetElevation))
import Routes exposing (Route(CreateDemocracyR, DemocracyR))


dashboardV : Model -> Html Msg
dashboardV model =
    let
        showRecentBallot ballots =
            case List.head ballots of
                Nothing ->
                    [ text "No Upcoming or Recent Votes" ]

                Just ballotId ->
                    let
                        ballot =
                            getBallot ballotId model
                    in
                    [ text ballot.name
                    , styled span
                        [ cs "tr pa2 absolute bottom-0 right-0"
                        , Typo.caption
                        ]
                        [ text <| toString <| Date.fromTime ballot.finish ]
                    ]

        democracyCard ( id, { name, desc, ballots } ) =
            Card.view
                ([ cs "ma4"
                 , css "width" "auto"
                 , Options.onClick <| NavigateTo <| DemocracyR id
                 ]
                    ++ elevation id model
                )
            <|
                [ Card.title [] [ text name ]
                , Card.text [] [ text desc ]
                , Card.actions [ Card.border ]
                    ([] ++ showRecentBallot ballots)
                ]
    in
    div [] <| List.map democracyCard <| Dict.toList model.democracies


dashboardH : Model -> List (Html Msg)
dashboardH model =
    let
        adminOptions =
            if model.isAdmin then
                [ Layout.spacer
                , Layout.navigation []
                    [ Layout.link
                        [ Options.onClick <| NavigateTo CreateDemocracyR
                        , cs "ba br-pill"
                        ]
                        [ text "New"
                        , Icon.i "add"
                        ]
                    ]
                ]
            else
                []
    in
    [ Layout.title [] [ text "Your Democracies" ] ]
        ++ adminOptions
