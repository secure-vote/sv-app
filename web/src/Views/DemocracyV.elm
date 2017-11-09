module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Html exposing (Html, div, img, span, text)
import Html.Attributes exposing (class)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, css, styled)
import Material.Typography as Typo
import Models exposing (Democracy, Model)
import Msgs exposing (Msg)


democracyV : Democracy -> Model -> Html Msg
democracyV democracy model =
    let
        democracyCard { name, desc, finish } =
            Card.view
                [ Elevation.e4
                , cs "ma4"
                , css "width" "auto"
                ]
                [ Card.title [] [ text name ]
                , Card.text [ cs "tl" ]
                    [ text desc
                    , styled span
                        [ cs "tr pa2 absolute bottom-0 right-0"
                        , Typo.caption
                        ]
                        [ text finish ]
                    ]
                ]
    in
    div [ class "tc" ]
        [ div [] <| List.map democracyCard democracy.ballots
        , btn 348739845 model [ SecBtn ] [ text "Previous Votes" ]
        ]


democracyH : Democracy -> List (Html m)
democracyH democracy =
    [ Layout.title [] [ text democracy.name ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link []
            [ Icon.view "info_outline" [ Icon.size36 ]
            ]
        ]
    ]
