module SecureVote.SPAs.LilGov.Msgs exposing (..)

import Components.Navigation exposing (NavMsg)
import Element.Input exposing (SelectMsg, SelectWith)
import Models.Ballot exposing (Ballot, BallotId, BallotState)
import Models.Democracy exposing (DelegateState, Democracy, DemocracyId)
import Models.Petition exposing (PetitionId)
import Models.Vote exposing (Vote, VoteId, VoteState)
import SecureVote.SPAs.LilGov.Routes exposing (DialogRoute, LilGovRoute)
import Time exposing (Time)


type Msg
    = NoOp
    | Tick Time
    | Nav (NavMsg LilGovRoute)
