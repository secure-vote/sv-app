module Routes exposing (..)

import Components.Navigation exposing (CommonRoute)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)
import Models.Vote exposing (Vote, VoteId)
import SecureVote.SPAs.LilGov.Routes exposing (LilGovRoute)


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
    | LGR LilGovRoute
    | CR CommonRoute
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
