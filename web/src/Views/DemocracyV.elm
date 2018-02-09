module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(Click, PriBtn, Small), btn)
import Components.Delegation exposing (delegationV)
import Components.IssueCard exposing (issueCard)
import Dict exposing (toList)
import Element exposing (Element, column, el, empty, html, row, text)
import Element.Attributes exposing (alignBottom, center, class, fill, padding, paddingTop, paddingXY, percent, spacing, spread, vary, verticalCenter, width)
import Helpers exposing (checkAlreadyVoted, dubCol, genNewId, getBallot, getDemocracy, getIntField, getMembers, getResultPercent, para, relativeTime)
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotId)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg(NavigateTo))
import Routes exposing (Route(CreateBallotR))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvAttribute, SvElement, SvHeader, SvView, notFoundView)


democracyV : DemocracyId -> Model -> SvView
democracyV democId model =
    let
        democracy =
            getDemocracy democId model

        ballots =
            List.filter ballotInDemocracy (toList model.ballots)

        ballotInDemocracy ( ballotId, ballot ) =
            List.member ballotId democracy.ballots
    in
    ( admin democId
    , header model
    , body ( democId, democracy ) ballots model
    )



-- TODO: Only show admin box when admin flag is true


admin : DemocracyId -> SvElement
admin democId =
    column AdminBoxS
        [ spacing (scaled 1), padding (scaled 4) ]
        [ el SubH [] (text "Welcome, Admin")
        , para [ width (percent 40) ] "As a project administrator you can create a new ballot below, or click on an individual ballot if you wish to edit or delete it."
        , btn [ PriBtn, Small, Click (NavigateTo (CreateBallotR democId)) ] (text "Create new ballot")
        ]


header : Model -> SvHeader
header model =
    ( []
    , [ text model.singleDemocName ]
    , []
    )


body : ( DemocracyId, Democracy ) -> List ( BallotId, Ballot ) -> Model -> SvElement
body ( democId, democracy ) ballots model =
    column IssueList
        [ spacing (scaled 3) ]
        [ el SubH [] (text "Open Ballots")
        , currentBallotList ballots model
        , el SubH [] (text "Upcoming Ballots")
        , futureBallotList ballots model
        , el SubH [] (text "Past Ballots")
        , pastBallotList ballots model
        , delegationV ( democId, democracy ) model
        ]


issueListSpacing : SvAttribute
issueListSpacing =
    spacing <| scaled 2


currentBallotList : List ( BallotId, Ballot ) -> Model -> SvElement
currentBallotList ballots model =
    let
        filteredBallots =
            List.sortWith compareFinish <| List.filter filterStatus ballots

        compareFinish ( ballotAId, ballotA ) ( ballotBId, ballotB ) =
            compare ballotA.finish ballotB.finish

        filterStatus ( ballotId, ballot ) =
            ballot.finish > model.now && ballot.start <= model.now

        ballotCard ( ballotId, ballot ) =
            issueCard model ballotId
    in
    column IssueList
        [ issueListSpacing ]
    <|
        if List.isEmpty filteredBallots then
            [ text "There are no current ballots" ]
        else
            List.map ballotCard filteredBallots


futureBallotList : List ( BallotId, Ballot ) -> Model -> SvElement
futureBallotList ballots model =
    let
        filteredBallots =
            List.sortWith checkStart <| List.filter filterStatus ballots

        checkStart ( ballotAId, ballotA ) ( ballotBId, ballotB ) =
            compare ballotA.start ballotB.start

        filterStatus ( ballotId, ballot ) =
            ballot.finish > model.now && ballot.start >= model.now

        ballotCard ( ballotId, ballot ) =
            issueCard model ballotId
    in
    column IssueList
        [ issueListSpacing ]
    <|
        if List.isEmpty filteredBallots then
            [ text "There are no upcoming ballots" ]
        else
            List.map ballotCard filteredBallots


pastBallotList : List ( BallotId, Ballot ) -> Model -> SvElement
pastBallotList ballots model =
    let
        filteredBallots =
            List.sortWith compareFinish <| List.filter filterStatus ballots

        compareFinish ( ballotAId, ballotA ) ( ballotBId, ballotB ) =
            compare ballotB.finish ballotA.finish

        filterStatus ( ballotId, ballot ) =
            ballot.finish < model.now

        ballotCard ( ballotId, ballot ) =
            issueCard model ballotId
    in
    column IssueList
        [ issueListSpacing ]
    <|
        if List.isEmpty filteredBallots then
            [ text "There are no past ballots" ]
        else
            List.map ballotCard filteredBallots



-- # EXCLUDE MEMBER LIST FOR NOW
--memberList : DemocracyId -> Model -> Html Msg
--memberList id model =
--    let
--        listItem { firstName, lastName } =
--            Table.tr []
--                [ Table.td [ cs "tl" ] [ H.text <| firstName ++ " " ++ lastName ]
--                , Table.td [] [ Icon.i "edit" ]
--                ]
--    in
--    Table.table [ cs "w-100" ]
--        [ Table.thead []
--            [ Table.tr []
--                [ Table.th [ cs "tl" ] [ H.text "Name" ]
--                , Table.th []
--                    [ btn 945674563456 model [ SecBtn, OpenDialog, Click (SetDialog "Invite Members" <| MemberInviteD) ] [ H.text "Invite +" ]
--                    ]
--                ]
--            ]
--        , Table.tbody [] <| List.map listItem <| getMembers id model
--        ]
