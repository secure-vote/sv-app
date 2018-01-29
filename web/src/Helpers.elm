module Helpers exposing (..)

import Date
import Dict
import Element exposing (Attribute, column, el, paragraph, row, text)
import Element.Attributes exposing (center, fillPortion, maxWidth, paddingRight, percent, px, spacing, width)
import Maybe.Extra exposing ((?))
import Models exposing (Member, Model)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg)
import Styles.Styles exposing (SvClass(NilS, ParaS))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation)
import Time exposing (Time)
import Views.ViewHelpers exposing (SvElement)


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


getField : String -> Model -> String
getField name model =
    Dict.get name model.fields ? ""


getIntField : Int -> Model -> Int
getIntField id model =
    Dict.get id model.intFields ? 0


getFloatField : Int -> Model -> Float
getFloatField id model =
    Dict.get id model.floatFields ? 0



-- Deprecated
--getAdminToggle : Model -> Bool
--getAdminToggle model =
--    Dict.get adminToggleId model.boolFields ? False


relativeTime : Time -> Model -> String
relativeTime time model =
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


readableTime : Time -> String
readableTime time =
    let
        date =
            Date.fromTime time

        addZero num =
            if num < 10 then
                "0" ++ toString num
            else
                toString num
    in
    (toString <| Date.dayOfWeek date)
        ++ ", "
        ++ (toString <| Date.day date)
        ++ " "
        ++ (toString <| Date.month date)
        ++ " "
        ++ (toString <| Date.year date)
        ++ " - "
        ++ (addZero <| Date.hour date)
        ++ ":"
        ++ (addZero <| Date.minute date)
        ++ ":"
        ++ (addZero <| Date.second date)
        ++ " UTC"


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


para : List (Attribute Variation Msg) -> String -> SvElement
para attrs txt =
    paragraph ParaS attrs [ text txt ]


dubCol : List SvElement -> List SvElement -> SvElement
dubCol col1 col2 =
    row NilS
        []
        [ column NilS [ width (percent 40) ] [ column NilS [ spacing (scaled 2) ] col1 ]
        , column NilS [ width (percent 60), center ] [ column NilS [ maxWidth (px 416), spacing (scaled 2) ] col2 ]
        ]
