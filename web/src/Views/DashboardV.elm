module Views.DashboardV exposing (..)

import Components.CardElevation exposing (elevation)
import Dict
import Helpers exposing (getBallot)
import Html exposing (Html, a, div, img, span, text)
import Html.Attributes exposing (class, href)
import Material.Card as Card
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Typography as Typo
import Models exposing (Model)
import Msgs exposing (MouseState(..), Msg(NavigateTo, SetElevation))


dashboardV : Model -> Html Msg
dashboardV model =
    let
        showRecentBallot ballots =
            case List.head ballots of
                Nothing ->
                    []

                Just ballotId ->
                    let
                        ballot =
                            getBallot ballotId model
                    in
                    [ Card.actions [ Card.border ]
                        [ text ballot.name
                        , styled span
                            [ cs "tr pa2 absolute bottom-0 right-0"
                            , Typo.caption
                            ]
                            [ text ballot.finish ]
                        ]
                    ]

        democracyCard ( id, { name, desc, ballots } ) =
            a [ href <| "#d/" ++ toString id, class "link black" ]
                [ Card.view
                    ([ cs "ma4"
                     , css "width" "auto"
                     ]
                        ++ elevation id model
                    )
                  <|
                    [ Card.title [] [ text name ]
                    , Card.text [] [ text desc ]
                    ]
                        ++ showRecentBallot ballots
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
                        [ Options.onClick <| NavigateTo "#create-democracy"
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
