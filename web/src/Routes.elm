module Routes exposing (..)

import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)


type Route
    = DashboardR
    | DemocracyListR
    | DemocracyR DemocracyId
    | VoteR BallotId
    | ResultsR BallotId
    | CreateDemocracyR
    | CreateVoteR DemocracyId
    | NotFoundRoute


type DialogRoute msg
    = VoteConfirmationD
    | BallotInfoD String
    | BallotOptionD String
    | DemocracyInfoD String
    | UserInfoD
    | MemberInviteD
    | NotFoundD
