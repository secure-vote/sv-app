module Components.IssueCard exposing (..)

import Color exposing (rgb)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (checkAlreadyVoted, getBallot, getResultPercent, readableTime)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Msgs exposing (Msg(NavigateTo))
import Routes exposing (Route(..))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (IssueCardStatus(..), Variation(..))
import Views.ViewHelpers exposing (SvElement)


issueCard : Model -> BallotId -> SvElement
issueCard model ballotId =
    let
        ballot =
            getBallot ballotId model

        ballotDone =
            ballot.finish < model.now

        clickMsg =
            if ballotDone then
                NavigateTo <| ResultsR ballotId
            else
                NavigateTo <| VoteR ballotId

        cardColor =
            if ballotDone then
                vary (IssueCardMod IssuePast) True
            else if ballot.start > model.now then
                vary (IssueCardMod VoteFuture) True
            else if checkAlreadyVoted ballotId model then
                vary (IssueCardMod VoteDone) True
            else
                vary (IssueCardMod VoteWaiting) True

        voteStatus =
            if ballotDone then
                ""
            else if checkAlreadyVoted ballotId model then
                "✅ You have voted in this ballot"
            else
                "❗ You have not voted in this ballot yet"

        resultString { name, result } =
            name ++ " - " ++ toString (getResultPercent ballot <| result ? 0) ++ "%, "

        displayResults =
            "Results: " ++ (List.foldr (++) "" <| List.map resultString ballot.ballotOptions)

        title =
            let
                textExtra =
                    if ballotDone then
                        ""
                    else
                        "🔴 "
            in
            el SubSubH [ paddingBottom (scaled 1) ] (text <| textExtra ++ ballot.name)

        body =
            let
                results =
                    if ballotDone then
                        el IssueCardResults [] (text displayResults)
                    else
                        empty
            in
            column NilS [ spacing <| scaled 1 ] [ el NilS [] <| text ballot.desc, results ]

        timeText =
            if ballotDone then
                "Vote closed " ++ readableTime ballot.finish model ++ " ago"
            else
                "Vote closes in " ++ readableTime ballot.finish model

        footer =
            row CardFooter
                [ spread, padding (scaled 1) ]
                [ el NilS [ alignLeft ] (text voteStatus)
                , el NilS
                    [ alignRight ]
                    (text timeText)
                ]
    in
    column IssueCard
        [ onClick clickMsg, cardColor ]
        [ column NilS
            [ padding <| scaled 1 ]
            [ title
            , body
            ]
        , footer
        ]



-- # FROM ONGOING ISSUES - should only show admin options for future ballots
-- alternatively the admin options for ongoing ballots should only ever be a stop button
--
--
--                adminOptions =
--                    let
--                        multiMsg =
--                            MultiMsg
--                                [ populateFromModel ballotId model
--                                , NavigateTo <| EditVoteR ballotId
--                                ]
--                    in
--                    if getAdminToggle model then
--                        [ div [ class "pa2 absolute top-0 right-0" ]
--                            [ btn 84345845675 model [ Icon, Click multiMsg ] [ Icon.i "edit" ]
--                            ]
--                        ]
--                    else
--                        []
