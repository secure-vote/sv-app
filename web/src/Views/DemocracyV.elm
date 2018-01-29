module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(PriBtn, Small), btn)
import Components.Delegation exposing (delegationV)
import Components.IssueCard exposing (issueCard)
import Element exposing (Element, column, el, empty, html, row, text)
import Element.Attributes exposing (alignBottom, center, class, fill, padding, paddingTop, paddingXY, percent, spacing, spread, vary, verticalCenter, width)
import Helpers exposing (checkAlreadyVoted, dubCol, genNewId, getBallot, getDemocracy, getIntField, getMembers, getResultPercent, para, relativeTime)
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView, notFoundView)


democracyV : DemocracyId -> Model -> SvView
democracyV democId model =
    let
        democracy =
            getDemocracy democId model
    in
    ( admin
    , header model
    , body democracy.ballots model
    )



-- TODO: Only show admin box when admin flag is true


admin : SvElement
admin =
    column AdminBoxS
        [ spacing (scaled 1), padding (scaled 4) ]
        [ el SubH [] (text "Welcome, Admin")
        , para [ width (percent 40) ] "As a project administrator you can create a new ballot below, or click on an individual ballot if you wish to edit or delete it."
        , btn [ PriBtn, Small ] (text "Create new ballot")
        ]


header : Model -> SvHeader
header model =
    ( []
    , [ text model.singleDemocName ]
    , []
    )


body : List BallotId -> Model -> SvElement
body ballots model =
    column IssueList
        [ spacing (scaled 3) ]
        [ el SubH [] (text "Open Ballots")
        , currentBallotList ballots model
        , el SubH [] (text "Upcoming Ballots")
        , futureBallotList ballots model
        , el SubH [] (text "Past Ballots")
        , pastBallotList ballots model
        , delegationV model
        ]


issueListSpacing =
    spacing <| scaled 2


currentBallotList : List BallotId -> Model -> SvElement
currentBallotList ballots model =
    let
        filteredBallots =
            List.sortWith compareFinish <| List.filter filterStatus ballots

        compareFinish a b =
            compare (getBallot a model).finish (getBallot b model).finish

        filterStatus id =
            (getBallot id model).finish > model.now && (getBallot id model).start <= model.now

        ballotCard ballotId =
            issueCard
                model
                ballotId
    in
    column IssueList
        [ issueListSpacing ]
    <|
        if List.isEmpty filteredBallots then
            [ el NilS [] (text "There are no current ballots") ]
        else
            List.map ballotCard filteredBallots


futureBallotList : List BallotId -> Model -> SvElement
futureBallotList ballots model =
    let
        filteredBallots =
            List.sortWith checkStart <| List.filter filterStatus ballots

        checkStart a b =
            compare (getBallot a model).start (getBallot b model).start

        filterStatus id =
            (getBallot id model).finish > model.now && (getBallot id model).start >= model.now

        ballotCard ballotId =
            issueCard model ballotId
    in
    column IssueList
        [ issueListSpacing ]
    <|
        if List.isEmpty filteredBallots then
            [ el SubH [] (text "There are no upcoming ballots") ]
        else
            List.map ballotCard filteredBallots


pastBallotList : List BallotId -> Model -> SvElement
pastBallotList ballots model =
    let
        filteredBallots =
            List.sortWith compareFinish <| List.filter filterStatus ballots

        compareFinish a b =
            compare (getBallot b model).finish (getBallot a model).finish

        filterStatus id =
            (getBallot id model).finish < model.now

        ballotCard ballotId =
            issueCard model ballotId
    in
    column IssueList
        [ issueListSpacing ]
    <|
        if List.isEmpty filteredBallots then
            [ el SubH [] (text "There are no past ballots") ]
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
