module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Html exposing (Html, div, img, span, text)
import Html.Attributes exposing (class)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Typography as Typo
import Models exposing (Democracy, Model)
import Msgs exposing (Msg(MultiMsg, SetBallot, SetPage))
import Routes exposing (Route(VoteR))


democracyV : Model -> Html Msg
democracyV model =
    let
        ballotCard ballot =
            Card.view
                [ Elevation.e4
                , cs "ma4"
                , css "width" "auto"
                , Options.onClick (MultiMsg [ SetPage VoteR, SetBallot ballot ])
                ]
                [ Card.title [] [ text ballot.name ]
                , Card.text [ cs "tl" ]
                    [ text ballot.desc
                    , styled span
                        [ cs "tr pa2 absolute bottom-0 right-0"
                        , Typo.caption
                        ]
                        [ text ballot.finish ]
                    ]
                ]
    in
    div [ class "tc" ]
        [ div [] <| List.map ballotCard model.currentDemocracy.ballots
        , btn 348739845 model [ SecBtn ] [ text "Previous Votes" ]
        ]


democracyH : Model -> List (Html m)
democracyH model =
    [ Layout.title [] [ text model.currentDemocracy.name ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link []
            [ Icon.view "info_outline" [ Icon.size36 ]
            ]
        ]
    ]
