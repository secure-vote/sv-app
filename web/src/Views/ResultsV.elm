module Views.ResultsV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Helpers exposing (getBallot, getResultPercent)
import Html exposing (Html, div, h2, table, td, text, tr)
import Html.Attributes exposing (class, style)
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options exposing (cs, styled)
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Msgs exposing (Msg(SetDialog))
import Plot as Plot
import Routes exposing (DialogRoute(BallotInfoD))


resultsV : BallotId -> Model -> Html Msg
resultsV id model =
    let
        ballot =
            getBallot id model

        tableRow ( desc, value ) =
            tr []
                [ td [ class "b tr" ] [ text <| desc ++ ": " ]
                , td [ class "", style [ ( "word-wrap", "break-word" ) ] ] [ text <| toString value ]
                , td [ class "tl" ] [ text <| "(" ++ (toString <| getResultPercent ballot value) ++ "%)" ]
                ]

        getResults { name, result } =
            ( name
            , result ? 0
              -- Error
            )

        plotGroup ( desc, value ) =
            Plot.group desc [ value ]
    in
    div [ class "ma4" ]
        [ styled h2 [ Typo.headline ] [ text "Results:" ]
        , table [ class "ba pa3 mt2" ] <|
            List.map
                tableRow
            <|
                List.map
                    getResults
                    ballot.ballotOptions
        , div [ class "w-90 w-50-l" ]
            [ Plot.viewBars
                (Plot.groups <| List.map plotGroup)
                (List.map getResults ballot.ballotOptions)
            ]
        ]


resultsH : BallotId -> Model -> List (Html Msg)
resultsH id model =
    let
        ballot =
            getBallot id model
    in
    [ Layout.title [] [ text ballot.name ]
    , Layout.spacer
    , Layout.navigation []
        [ Layout.link []
            [ btn 2345785562 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Ballot Info" <| BallotInfoD ballot.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
        ]
    ]
