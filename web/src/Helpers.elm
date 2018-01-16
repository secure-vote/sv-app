module Helpers exposing (..)

import Dict
import Maybe.Extra exposing ((?))
import Models exposing (Member, Model, adminToggleId)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Time exposing (Time)


findDemocracy : BallotId -> Model -> ( DemocracyId, Democracy )
findDemocracy ballotId model =
    let
        containsBallot ( democracyId, democracy ) =
            List.member ballotId democracy.ballots
    in
    List.head (List.filter containsBallot <| Dict.toList model.democracies) ? ( 0, Democracy "Missing Democracy" "" "" [] )


{-| Check if a vote exists in model.votes or not.
-}
checkAlreadyVoted : BallotId -> Model -> Bool
checkAlreadyVoted ballotId model =
    let
        containsBallot vote =
            ballotId == vote.ballotId
    in
    not <| List.isEmpty <| List.filter containsBallot <| Dict.values model.votes


getDemocracy : DemocracyId -> Model -> Democracy
getDemocracy id model =
    Dict.get id model.democracies ? Democracy "Missing Democracy" "" "" []


getBallot : BallotId -> Model -> Ballot
getBallot id model =
    Dict.get id model.ballots ? Ballot "Missing Ballot" "" 0 0 []


getMembers : DemocracyId -> Model -> List Member
getMembers id model =
    let
        filter member =
            if List.member id member.democracies then
                True
            else
                False
    in
    List.filter filter <| Dict.values model.members


getField : Int -> Model -> String
getField id model =
    Dict.get id model.fields ? ""


getIntField : Int -> Model -> Int
getIntField id model =
    Dict.get id model.intFields ? 0


getFloatField : Int -> Model -> Float
getFloatField id model =
    Dict.get id model.floatFields ? 0


getAdminToggle : Model -> Bool
getAdminToggle model =
    Dict.get adminToggleId model.boolFields ? False


readableTime : Time -> Model -> String
readableTime time model =
    let
        difference =
            abs <| time - model.now
    in
    if Time.inSeconds difference < 120 && Time.inSeconds difference > 0 then
        (toString <| floor <| Time.inSeconds difference) ++ " seconds"
    else if Time.inMinutes difference < 120 && Time.inMinutes difference > 1 then
        (toString <| floor <| Time.inMinutes difference) ++ " minutes"
    else if Time.inHours difference < 48 && Time.inHours difference > 1 then
        (toString <| floor <| Time.inHours difference) ++ " hours"
    else if Time.inHours difference < 60 * 24 && Time.inHours difference > 24 then
        (toString <| floor <| Time.inHours difference / 24) ++ " days"
    else if Time.inHours difference < 730 * 24 && Time.inHours difference > 30 * 24 then
        (toString <| floor <| Time.inHours difference / 24 / 30) ++ " months"
    else if Time.inHours difference > 365 * 24 then
        (toString <| floor <| Time.inHours difference / 24 / 365) ++ " years"
    else
        "error reading number"


getResultPercent : Ballot -> Float -> Int
getResultPercent ballot value =
    let
        getResults { result } =
            abs <| result ? 0
    in
    round <| value * 100 / (List.sum <| List.map getResults ballot.ballotOptions)



{- | Generate a new id based on a previous id and nonce; possibly wraps due to JS integer limitations -}


genNewId : Int -> Int -> Int
genNewId parentId nonce =
    1033 * (parentId + nonce * 17)
