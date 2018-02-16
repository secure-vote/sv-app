module Msgs exposing (..)

import Element.Input exposing (SelectMsg, SelectWith)
import Models.Ballot exposing (Ballot, BallotId, BallotState)
import Models.Democracy exposing (DelegateState, Democracy, DemocracyId)
import Models.Vote exposing (Vote, VoteId, VoteState)
import Routes exposing (DialogRoute, Route)
import Time exposing (Time)


type Msg
    = NoOp
    | Tick Time
    | SetDialog String (DialogRoute Msg)
    | HideDialog
    | Nav NavMsg
    | SetField SetFieldMsg
    | Select String (SelectMsg DurationType)
    | SetState SetStateMsg
    | CRUD CRUDMsg
    | Debug String
      --     Port Msgs
    | ToBc ToBlockchainMsg
    | FromBc FromBlockchainMsg
    | ToLs ToLocalStorageMsg
    | FromLs FromLocalStorageMsg
      --    Helper Msgs
    | MultiMsg (List Msg)
    | ChainMsgs (List Msg)


type NavMsg
    = NBack
    | NHome
    | NTo Route
    | NBackTo Route


type SetFieldMsg
    = SText String String
    | SInt String Int
    | SFloat String Float
    | SSelect String (SelectWith DurationType Msg)


type SetStateMsg
    = SVote VoteState ( VoteId, Vote )
    | SBallot BallotState ( BallotId, Ballot )
    | SDelegate DelegateState ( DemocracyId, Democracy )


type CRUDMsg
    = CreateVote ( VoteId, Vote )
    | CreateBallot DemocracyId ( BallotId, Ballot )
    | EditBallot ( BallotId, Ballot )
    | DeleteBallot BallotId
    | AddDelegate String ( DemocracyId, Democracy )
    | RemoveDelegate ( DemocracyId, Democracy )


type ToBlockchainMsg
    = BcSend BcRequest
    | BcGet String


type FromBlockchainMsg
    = BcReceipt ( String, String )
    | BcConfirm String
    | BcReceive String


type ToLocalStorageMsg
    = LsWrite { key : String, value : String }
    | LsRead String


type FromLocalStorageMsg
    = LsReceive { key : String, value : String }


type alias BcRequest =
    { name : String
    , payload : String
    , onReceipt : Msg
    , onConfirmation : Msg
    }


type DurationType
    = Day
    | Week
    | Month
