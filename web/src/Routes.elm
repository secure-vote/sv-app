module Routes exposing (..)

import Models.Ballot exposing (BallotId, Vote, VoteId)
import Models.Democracy exposing (DemocracyId)


type Route
    = DashboardR
    | DemocracyListR
    | DemocracyR DemocracyId
    | VoteR BallotId
    | ResultsR BallotId
    | CreateDemocracyR
    | CreateVoteR DemocracyId
    | EditVoteR BallotId
    | NotFoundRoute


type DialogRoute msg
    = VoteConfirmationD Vote VoteId
    | BallotDeleteConfirmD BallotId
    | BallotInfoD String
    | BallotOptionD String
    | DemocracyInfoD String
    | UserInfoD
    | HowToVoteD
      --    | MemberInviteD
    | NotFoundD
