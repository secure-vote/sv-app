module Helpers exposing (..)

import Dict
import Maybe.Extra exposing ((?))
import Models exposing (Member, Model)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)


getDemocracy : DemocracyId -> Model -> Democracy
getDemocracy id model =
    Dict.get id model.democracies ? Democracy "" "" "" []


getBallot : BallotId -> Model -> Ballot
getBallot id model =
    Dict.get id model.ballots ? Ballot "" "" "" "" []


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
