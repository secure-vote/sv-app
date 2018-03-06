module Routes exposing (..)

import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)
import Models.Vote exposing (Vote, VoteId)


type Route
    = DashboardR
    | DemocracyListR
    | DemocracyR DemocracyId
    | VoteR BallotId
    | ResultsR BallotId
    | CreateBallotR DemocracyId BallotId
    | EditBallotR BallotId
    | PetitionsR
    | DebugR
    | LoginR
    | NotFoundRoute


type DialogRoute msg
    = VoteConfirmationD ( VoteId, Vote )
    | BallotDeleteConfirmD BallotId
    | BallotInfoD String
    | BallotOptionD String
    | DemocracyInfoD String
    | UserInfoD
    | HowToVoteD
      --    | MemberInviteD
    | NotFoundD
