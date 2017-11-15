module Helpers exposing (..)

import Dict
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)


getDemocracy : DemocracyId -> Model -> Democracy
getDemocracy id model =
    Dict.get id model.democracies ? Democracy "" "" "" []


getBallot : BallotId -> Model -> Ballot
getBallot id model =
    Dict.get id model.ballots ? Ballot "" "" "" "" []
