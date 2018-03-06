module Components.IssueCard exposing (..)

import Components.Icons exposing (IconSize(I24), mkIcon)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Helpers exposing (checkAlreadyVoted, getBallot, getResultPercent, getVoteFromBallot, para, relativeTime)
import List exposing (filter, head, maximum)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (BallotId, BallotState(..))
import Models.Vote exposing (VoteState(VotePending))
import Msgs exposing (..)
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

        vote =
            getVoteFromBallot ballotId model

        ballotDone =
            ballot.finish < model.now

        isPending =
            List.member ballot.state [ BallotPendingCreation, BallotPendingEdits, BallotPendingDeletion ] || vote.state == VotePending

        state =
            if ballotDone then
                IssuePast
            else if isPending then
                IssuePending
            else if ballot.start > model.now then
                IssueFuture
            else if checkAlreadyVoted ballotId model then
                IssueDone
            else
                IssueVoteNow

        struct =
            let
                relStart =
                    relativeTime ballot.start model

                relFinish =
                    relativeTime ballot.finish model

                resultsR =
                    Nav <| NTo <| ResultsR ballotId

                voteR =
                    Nav <| NTo <| VoteR ballotId
            in
            case state of
                IssuePast ->
                    { icon = "clipboard-text"
                    , time = "Closed " ++ relFinish ++ " ago"
                    , status = "View Results"
                    , msg = resultsR
                    }

                IssueFuture ->
                    { icon = "circle-outline"
                    , time = "Opens in " ++ relStart
                    , status = "Upcoming"
                    , msg = voteR
                    }

                IssueDone ->
                    { icon = "check-circle-outline"
                    , time = "Closes in " ++ relFinish
                    , status = "Vote received"
                    , msg = voteR
                    }

                IssuePending ->
                    { icon = "google-circles-communities"
                    , time = "Closes in " ++ relFinish
                    , status = "Vote pending"
                    , msg = voteR
                    }

                IssueVoteNow ->
                    { icon = "alert-circle-outline"
                    , time = "Closes in " ++ relFinish
                    , status = "Vote now"
                    , msg = voteR
                    }

        --        TODO: Style this better
        pendingText =
            case ballot.state of
                BallotPendingCreation ->
                    " (Waiting to be created on blockchain)"

                BallotPendingEdits ->
                    " (Waiting to be edited on blockchain)"

                BallotPendingDeletion ->
                    " (Waiting to be deleted from blockchain)"

                _ ->
                    ""

        statusColor =
            vary (IssueStatusMod state) True

        issueCardStatus =
            vary (IssueCardMod state) (state == IssueVoteNow)

        icon =
            el IssueStatusS [ verticalCenter, statusColor ] (mkIcon struct.icon I24)

        title =
            el SubSubH [] (text <| ballot.name ++ pendingText)

        body =
            para [] ballot.desc

        status =
            column CardFooter
                [ verticalSpread, spacing (scaled 1) ]
                [ el IssueStatusS [ statusColor ] (text struct.status)
                , para [] struct.time
                ]
    in
    row IssueCard
        [ onClick struct.msg, issueCardStatus, padding (scaled 1), spread ]
        [ row NilS
            [ spacing (scaled 1) ]
            [ icon
            , column NilS
                [ spacing (scaled 1) ]
                [ title
                , body
                ]
            ]
        , status
        ]
