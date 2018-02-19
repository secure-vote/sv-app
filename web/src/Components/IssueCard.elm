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
            ballot.state
                == BallotPendingCreation
                || ballot.state
                == BallotPendingEdits
                || ballot.state
                == BallotPendingDeletion
                || vote.state
                == VotePending

        state =
            if ballotDone then
                IssuePast
            else if ballot.start > model.now then
                IssueFuture
            else if isPending then
                IssuePending
            else if checkAlreadyVoted ballotId model then
                IssueDone
            else
                IssueVoteNow

        struct =
            case state of
                IssuePast ->
                    { icon = "clipboard-text"
                    , time = "Closed " ++ relativeTime ballot.finish model ++ " ago"
                    , status = "View Results"
                    , msg = Nav <| NTo <| ResultsR ballotId
                    }

                IssueFuture ->
                    { icon = "circle-outline"
                    , time = "Opens in " ++ relativeTime ballot.start model
                    , status = "Upcoming"
                    , msg = Nav <| NTo <| VoteR ballotId
                    }

                IssueDone ->
                    { icon = "check-circle-outline"
                    , time = "Closes in " ++ relativeTime ballot.finish model
                    , status = "Vote received"
                    , msg = Nav <| NTo <| VoteR ballotId
                    }

                IssuePending ->
                    { icon = "google-circles-communities"
                    , time = "Closes in " ++ relativeTime ballot.finish model
                    , status = "Vote pending"
                    , msg = Nav <| NTo <| VoteR ballotId
                    }

                IssueVoteNow ->
                    { icon = "alert-circle-outline"
                    , time = "Closes in " ++ relativeTime ballot.finish model
                    , status = "Vote now"
                    , msg = Nav <| NTo <| VoteR ballotId
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
