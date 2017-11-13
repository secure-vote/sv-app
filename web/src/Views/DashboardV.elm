module Views.DashboardV exposing (..)

import Dict
import Html exposing (Html, div, img, span, text)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Msgs exposing (MouseState(..), Msg(MultiMsg, SetDemocracy, SetElevation, SetPage))
import Routes exposing (Route(DemocracyListR, DemocracyR))


dashboardV : Model -> Html Msg
dashboardV model =
    let
        elevation id =
            case Dict.get id model.elevations ? MouseUp of
                MouseUp ->
                    Elevation.e4

                MouseDown ->
                    Elevation.e2

                MouseOver ->
                    Elevation.e8

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

        democracyCard ( id, { name, desc, ballots } ) =
            Card.view
                [ elevation id
                , Options.onMouseOver (SetElevation id MouseOver)
                , Options.onMouseDown (SetElevation id MouseDown)
                , Options.onMouseLeave (SetElevation id MouseUp)
                , Options.onMouseUp (SetElevation id MouseOver)
                , Options.onClick (MultiMsg [ SetPage DemocracyR, SetDemocracy id ])
                , Elevation.transition 50
                , cs "ma4"
                , css "width" "auto"
                ]
            <|
                [ Card.title [] [ text name ]
                , Card.text [] [ text desc ]
                ]
                    ++ showRecentBallot ballots
    in
    div [] <| List.map democracyCard <| Dict.toList model.democracies


dashboardH : List (Html Msg)
dashboardH =
    [ Layout.title [] [ text "Your Democracies" ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link
            [ Options.onClick <| SetPage DemocracyListR
            , cs "ba br-pill"
            ]
            [ text "Join"
            , Icon.i "add"
            ]
        ]
    ]
