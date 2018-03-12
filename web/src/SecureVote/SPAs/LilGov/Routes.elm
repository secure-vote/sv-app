module SecureVote.SPAs.LilGov.Routes exposing (..)

import Components.Navigation exposing (CommonRoute)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)
import Models.Vote exposing (Vote, VoteId)


type LilGovRoute
    = LoginR
    | Vote1AccessR
    | CR CommonRoute


type DialogRoute msg
    = NotFoundD
