module Helpers exposing (..)

import Dict
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg(SetField))


getDemocracy : DemocracyId -> Model -> Democracy
getDemocracy id model =
    Dict.get id model.democracies ? Democracy "" "" "" []


getBallot : BallotId -> Model -> Ballot
getBallot id model =
    Dict.get id model.ballots ? Ballot "" "" "" "" []


getTab : Int -> Model -> Int
getTab id model =
    Result.withDefault 0 <| String.toInt <| Dict.get id model.fields ? "0"


setTab : Int -> Int -> Msg
setTab id value =
    SetField id <| toString value
