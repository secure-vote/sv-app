module Helpers exposing (..)

import Dict
import Maybe.Extra exposing ((?))
import Models exposing (Member, Model, adminToggleId)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Time


getDemocracy : DemocracyId -> Model -> Democracy
getDemocracy id model =
    Dict.get id model.democracies ? Democracy "" "" "" []


getBallot : BallotId -> Model -> Ballot
getBallot id model =
    Dict.get id model.ballots ? Ballot "" "" 0 0 []


getTab : Int -> Model -> Int
getTab id model =
    Dict.get id model.intFields ? 0


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


getAdminToggle : Model -> Bool
getAdminToggle model =
    Dict.get adminToggleId model.boolFields ? False


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
    else if Time.inHours difference > 30 * 24 then
        (toString <| floor <| Time.inHours difference / 24 / 30) ++ " months"
    else
        "error reading number"
