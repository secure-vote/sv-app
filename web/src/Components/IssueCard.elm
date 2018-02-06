module Components.IssueCard exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (checkAlreadyVoted, getBallot, getResultPercent, para, relativeTime)
import List exposing (filter, head, maximum)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (BallotId, BallotState(..))
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

        resultString { name, result } =
            name ++ " - " ++ toString (getResultPercent ballot <| result ? 0) ++ "%, "

        --      [TS] Pretty messy, will probably need a refactor.
        --      Also, Just picks the first result in a tie.
        showWinningBallot =
            case head (filter (\{ result } -> result == maximum (List.map (\{ result } -> result ? 0) ballot.ballotOptions)) ballot.ballotOptions) of
                Just winningBallot ->
                    winningBallot.name

                Nothing ->
                    "No Winner"

        displayResults =
            "Winning Result: " ++ showWinningBallot

        voteStatus =
            if ballotDone then
                displayResults
            else if ballot.start > model.now then
                "This ballot is not open yet"
            else if checkAlreadyVoted ballotId model then
                "You have voted in this ballot"
            else
                "You have not voted in this ballot yet"

        --        TODO: Style this better
        titleText name =
            case ballot.state of
                BallotPendingCreation ->
                    name ++ " (Waiting to be created on blockchain)"

                BallotPendingEdits ->
                    name ++ " (Waiting to be edited on blockchain)"

                BallotPendingDeletion ->
                    name ++ " (Waiting to be deleted from blockchain)"

                _ ->
                    name

        title =
            el SubSubH [ paddingBottom (scaled 1) ] (text <| titleText ballot.name)

        body =
            column NilS
                [ spacing <| scaled 1 ]
                [ para [] ballot.desc ]

        timeText =
            if ballotDone then
                "Vote closed " ++ relativeTime ballot.finish model ++ " ago"
            else if ballot.start > model.now then
                "Vote opens in " ++ relativeTime ballot.start model
            else
                "Vote closes in " ++ relativeTime ballot.finish model

        footer =
            row CardFooter
                [ spread, padding (scaled 1), cardColor ]
                [ el NilS [ alignLeft ] (para [ vary Caps True, vary SmallFont True, verticalCenter ] voteStatus)
                , el NilS
                    [ alignRight ]
                    (para [] timeText)
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
