module Helpers exposing (..)

import Date
import Dict
import Element exposing (Attribute, column, el, paragraph, row, text)
import Element.Attributes exposing (..)
import Element.Input as Input exposing (SelectMsg, SelectWith)
import Maybe.Extra exposing ((?))
import Models exposing (Member, Model, lSKeys)
import Models.Ballot exposing (Ballot, BallotId, BallotState(BallotNone))
import Models.Democracy exposing (Delegate, DelegateState(Inactive), Democracy, DemocracyId)
import Models.Vote exposing (Vote, VoteId, VoteState(VoteNone))
import Msgs exposing (..)
import String exposing (slice)
import Styles.Styles exposing (SvClass(CardS, NilS, ParaS))
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
    List.head (List.filter containsBallot <| Dict.toList model.democracies) ? ( 0, Democracy "Missing Democracy" "" "" [] (Delegate "" Inactive) )


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
getDemocracy democId model =
    Dict.get democId model.democracies ? Democracy "Missing Democracy" "" "" [] (Delegate "" Inactive)


getBallot : BallotId -> Model -> Ballot
getBallot ballotId model =
    Dict.get ballotId model.ballots ? Ballot "Missing Ballot" "" 0 0 [] BallotNone


getVote : VoteId -> Model -> Vote
getVote voteId model =
    Dict.get voteId model.votes ? Vote 0 [] VoteNone


getVoteFromBallot : BallotId -> Model -> Vote
getVoteFromBallot ballotId model =
    let
        containsBallot vote =
            ballotId == vote.ballotId
    in
    List.head (List.filter containsBallot <| Dict.values model.votes) ? Vote 0 [] VoteNone


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


getIntField : String -> Model -> Int
getIntField id model =
    Dict.get id model.intFields ? 0


getFloatField : String -> Model -> Float
getFloatField id model =
    Dict.get id model.floatFields ? 0


getSelectField : String -> Model -> SelectWith DurationType Msg
getSelectField id model =
    Dict.get id model.selectFields ? genDropDown id Nothing


genDropDown : String -> Maybe DurationType -> SelectWith DurationType Msg
genDropDown id opt =
    Input.dropMenu opt (Select id)


getTx : String -> Model -> BcRequest
getTx refId model =
    Dict.get refId model.txReceipts ? BcRequest "Missing Transaction" "" NoOp NoOp


getDebugLog : Model -> String
getDebugLog model =
    Dict.get lSKeys.debugLog model.localStorage ? ""


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



-- getDateString return format
-- "yyyy-MM-ddThh:mm"


timeToDateString : Time -> String
timeToDateString time =
    let
        date =
            Date.fromTime time

        addZero num =
            if num < 10 then
                "0" ++ toString num
            else
                toString num

        year =
            toString (Date.year date)

        month =
            case Date.month date of
                Date.Jan ->
                    "01"

                Date.Feb ->
                    "02"

                Date.Mar ->
                    "03"

                Date.Apr ->
                    "04"

                Date.May ->
                    "05"

                Date.Jun ->
                    "06"

                Date.Jul ->
                    "07"

                Date.Aug ->
                    "08"

                Date.Sep ->
                    "09"

                Date.Oct ->
                    "10"

                Date.Nov ->
                    "11"

                Date.Dec ->
                    "12"

        day =
            addZero (Date.day date)

        hour =
            addZero (Date.hour date)

        minute =
            addZero (Date.minute date)
    in
    year ++ "-" ++ month ++ "-" ++ day ++ "T" ++ hour ++ ":" ++ minute


oneDay =
    86400000


oneWeek =
    oneDay * 7


oneMonth =
    oneWeek * 4


getDuration : Time -> Time -> ( Float, DurationType )
getDuration start finish =
    let
        difference =
            finish - start
    in
    if ceiling difference % oneMonth == 0 then
        ( difference / oneMonth, Month )
    else if ceiling difference % oneWeek == 0 then
        ( difference / oneWeek, Week )
    else
        ( difference / oneDay, Day )


durationToTime : ( Float, Maybe DurationType ) -> Time
durationToTime ( durationValue, durationType ) =
    case durationType of
        Just Day ->
            oneDay * durationValue

        Just Week ->
            oneWeek * durationValue

        Just Month ->
            oneMonth * durationValue

        Nothing ->
            0



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
        , column NilS [ width (percent 60), center ] [ column NilS [ minWidth (px 360), maxWidth (px 416), spacing (scaled 2) ] col2 ]
        ]


card : SvElement -> SvElement
card inner =
    el CardS [ paddingXY (scaled 5) (scaled 3) ] inner
