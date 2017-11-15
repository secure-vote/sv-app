module Routes exposing (..)

import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)


type Route
    = DashboardR
    | DemocracyListR
    | DemocracyR DemocracyId
    | VoteR BallotId
    | NotFoundRoute


type DialogRoute msg
    = VoteConfirmationD
    | BallotInfoD String
    | BallotOptionD String
    | DemocracyInfoD String
    | NotFoundD
