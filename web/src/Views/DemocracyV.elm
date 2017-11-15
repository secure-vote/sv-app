module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.CardElevation as CardElevation
import Helpers exposing (getBallot, getDemocracy)
import Html exposing (Html, a, div, img, span, text)
import Html.Attributes exposing (class, href)
import Material.Card as Card
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Typography as Typo
import Models exposing (Model)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(SetDialog))
import Routes exposing (DialogRoute(DemocracyInfoD))


democracyV : DemocracyId -> Model -> Html Msg
democracyV id model =
    let
        democracy =
            getDemocracy id model

        ballotCard ballotId =
            let
                ballot =
                    getBallot ballotId model
            in
            a [ href <| "#v/" ++ toString ballotId, class "link black" ]
                [ Card.view
                    ([ cs "ma4"
                     , css "width" "auto"
                     ]
                        ++ CardElevation.opts ballotId model
                    )
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
                ]
    in
    div [ class "tc" ]
        [ div [] <| List.map ballotCard democracy.ballots
        , btn 348739845 model [ SecBtn ] [ text "Previous Votes" ]
        ]


democracyH : DemocracyId -> Model -> List (Html Msg)
democracyH id model =
    let
        democracy =
            getDemocracy id model
    in
    [ Layout.title [] [ text democracy.name ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link []
            [ btn 2345785562 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Democracy Info" <| DemocracyInfoD democracy.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
        ]
    ]
