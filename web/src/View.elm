module View exposing (..)

import Html exposing (Html, div, hr, img, text)
import Html.Attributes exposing (class, src, style)
import Material.Card as Card
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css)
import Models exposing (Model)
import Msgs exposing (Msg(Mdl))


view : Model -> Html Msg
view model =
    let
        logo =
            img [ src "/web/img/securevote-logo-side.svg", style [ ( "max-width", "55%" ) ] ] []

        header =
            [ Layout.row []
                [ Layout.title [] [ logo ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link [] [ Icon.view "account_circle" [ Icon.size48 ] ]
                    ]
                ]
            ]

        content =
            [ Layout.row [ cs "ph2" ]
                [ Layout.title [] [ text "Your Democracies" ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link
                        [ Color.text Color.black
                        , cs "ba br-pill"
                        ]
                        [ text "Join"
                        , Icon.i "add"
                        ]
                    ]
                ]
            , hr [] []
            , div [] <| List.map democracyCard democracies
            ]

        showRecentBallot ballots =
            if List.isEmpty ballots then
                [ Card.actions [] [ text (List.head ballots).name ] ]
            else
                []

        democracyCard { name, desc, ballots } =
            Card.view
                [ Elevation.e4
                , cs "ma3"
                ]
                [ Card.title [] [ text name ]
                , Card.text [] [ text desc ]
                ]
                ++ showRecentBallot ballots
    in
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.fixedDrawer
        ]
        { header = header
        , drawer = []
        , tabs = ( [], [] )
        , main = content
        }


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


democracies =
    [ Democracy "Swarm Fund" "Cooperative Ownership Platform for Real Assets" [ Ballot "Token Release Schedule" "This vote is to determine the release schedule of the SWM Token" "100" "200" ]
    , Democracy "Flux (AUS Federal Parliament)" "Flux is your way to participate directly in Australian Federal Parliament" [ Ballot "Same Sex Marriage" "Should the law be changed to allow same-sex couples to marry" "100" "200" ]
    ]
