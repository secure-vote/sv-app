module Views.ResultsV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24, I36), mkIcon)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (getBallot, getResultPercent)
import Html as H exposing (Html, div, h2, p, table, td, tr)
import Html.Attributes exposing (style)
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
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(BoldT))
import Tuple exposing (first, second)
import Views.ViewHelpers exposing (SvElement)


resultsV : BallotId -> Model -> SvElement
resultsV id model =
    let
        ballot =
            getBallot id model

        --        tableRow ( desc, value ) =
        --            tr []
        --                [ td [ class "b tr" ] [ H.text <| desc ++ ": " ]
        --                , td [ class "", style [ ( "word-wrap", "break-word" ) ] ] [ H.text <| toString value ]
        --                , td [ class "tl" ] [ H.text <| "(" ++ (toString <| getResultPercent ballot value) ++ "%)" ]
        --                ]
        getResults { name, result } =
            ( name
            , result ? 0
              -- Error
            )

        resTableSpacing =
            spacing 3

        optColGen extraAttrs =
            column ResultsColumn <| [ resTableSpacing, paddingRight (scaled 1) ] ++ extraAttrs

        genVotesPct =
            el NilS [ vary BoldT True ] << text << toString << getResultPercent ballot << second

        genResName =
            text << first

        genVotesN =
            text << toString << second

        optNamesCol =
            optColGen [] <|
                [ el SubSubH [] <| text "Option Name" ]
                    ++ List.map (genResName << getResults) ballot.ballotOptions

        optVotesCol =
            optColGen [ alignRight ] <|
                [ el SubSubH [] <| text "# Votes" ]
                    ++ List.map (genVotesN << getResults) ballot.ballotOptions

        optPctCol =
            optColGen [] <| List.map (genVotesPct << getResults) ballot.ballotOptions

        results =
            row ResultsSummary
                [ padding 10, spacing (scaled 1) ]
                [ optNamesCol
                , optVotesCol

                {- , optPctCol -}
                ]

        plotGroup ( desc, value ) =
            Plot.group desc [ value ]

        resultsGraph =
            el ResultsBarGraph
                []
                (html <|
                    Plot.viewBars
                        (Plot.groups <| List.map plotGroup)
                        (List.map getResults ballot.ballotOptions)
                )
    in
    column NilS
        []
        [ el SubSubH [] <| text "Description:"
        , el NilS [ paddingBottom (scaled 1) ] <| text ballot.desc
        , column NilS
            [ paddingBottom (scaled 1) ]
            [ row NilS [] <| [ bold "Start Time: ", text <| toString ballot.start ]
            , row NilS [] <| [ bold "End Time: ", text <| toString ballot.finish ]
            ]
        , el SubH [ paddingBottom (scaled 1) ] <| text "Results"
        , results
        , resultsGraph
        ]



--        div
--        [ class "ma4" ]
--        [ p [] [ H.text ballot.desc ]
--        , p [] [ H.text <| "Start Time: " ++ toString ballot.start ]
--        , p [] [ H.text <| "Finish Time: " ++ toString ballot.finish ]
--        , styled h2 [ Typo.headline ] [ H.text "Results:" ]
--        , table [ class "ba pa3 mt2" ] <|
--            List.map
--                tableRow
--            <|
--                List.map
--                    getResults
--                    ballot.ballotOptions
--        , div [ class "w-90 w-50-l" ]
--            [
--            ]
--        ]


resultsH : BallotId -> Model -> ( List SvElement, List SvElement, List SvElement )
resultsH id model =
    let
        ballot =
            getBallot id model

        clickMsg =
            onClick <| SetDialog "Ballot Info" <| BallotInfoD ballot.desc
    in
    ( [], [ text ballot.name ], [ button NilS [ clickMsg ] <| mkIcon "information-outline" I24 ] )



--    [ Layout.title [] [ H.text ballot.name ]
--    , Layout.spacer
--    , Layout.navigation []
--        [ Layout.link []
--            [ btn 2345785562 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Ballot Info" <| BallotInfoD ballot.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
--        ]
--    ]
