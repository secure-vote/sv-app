module SecureVote.SPAs.LilGov.Helpers exposing (..)

import Dict
import Element.Input as Input exposing (SelectWith, dropMenu)
import Maybe.Extra exposing ((?))
import Models.Ballot exposing (Ballot, BallotId, BallotState(BallotNone))
import Models.Democracy exposing (Delegate, DelegateState(Inactive), Democracy, DemocracyId)
import Models.Petition exposing (PetitionId)
import Models.Vote exposing (Vote, VoteId, VoteState(VoteNone))
import SecureVote.SPAs.LilGov.Models exposing (Member, Model, lSKeys)
import SecureVote.SPAs.LilGov.Msgs exposing (BcRequest, DurationType, Msg(NoOp, Select))


a =
    1



--{-| Check if a vote exists in model.votes or not.
---}
--checkAlreadyVoted : BallotId -> Model -> Bool
--checkAlreadyVoted ballotId model =
--    let
--        containsBallot vote =
--            ballotId == vote.ballotId
--    in
--    not <| List.isEmpty <| List.filter containsBallot <| Dict.values model.votes
--
--
--getDemocracy : DemocracyId -> Model -> Democracy
--getDemocracy democId model =
--    Dict.get democId model.democracies ? Democracy "Missing Democracy" "" "" [] (Delegate "" Inactive)
--
--
--getBallot : BallotId -> Model -> Ballot
--getBallot ballotId model =
--    Dict.get ballotId model.ballots ? Ballot "Missing Ballot" "" 0 0 [] BallotNone
--
--
--getVote : VoteId -> Model -> Vote
--getVote voteId model =
--    Dict.get voteId model.votes ? Vote 0 [] VoteNone
--
--
--getVoteFromBallot : BallotId -> Model -> Vote
--getVoteFromBallot ballotId model =
--    let
--        containsBallot vote =
--            ballotId == vote.ballotId
--    in
--    List.head (List.filter containsBallot <| Dict.values model.votes) ? Vote 0 [] VoteNone
--
--
--getMembers : DemocracyId -> Model -> List Member
--getMembers id model =
--    let
--        filter member =
--            if List.member id member.democracies then
--                True
--            else
--                False
--    in
--    List.filter filter <| Dict.values model.members
--
--
--getSupport : PetitionId -> Model -> Bool
--getSupport petId model =
--    Dict.get petId model.support ? False
--
--
--getField : String -> Model -> String
--getField name model =
--    Dict.get name model.fields ? ""
--
--
--getIntField : String -> Model -> Int
--getIntField id model =
--    Dict.get id model.intFields ? 0
--
--
--getFloatField : String -> Model -> Float
--getFloatField id model =
--    Dict.get id model.floatFields ? 0
--
--
--getSelectField : String -> Model -> SelectWith DurationType Msg
--getSelectField id model =
--    Dict.get id model.selectFields ? genDropDown id Nothing
--
--
--genDropDown : String -> Maybe DurationType -> SelectWith DurationType Msg
--genDropDown id opt =
--    Input.dropMenu opt (Select id)
--
--
--getTx : String -> Model -> BcRequest
--getTx refId model =
--    Dict.get refId model.txReceipts ? BcRequest "Missing Transaction" "" NoOp NoOp
--
--
--getDebugLog : Model -> String
--getDebugLog model =
--    Dict.get lSKeys.debugLog model.localStorage ? ""
