module Views.DemocracyV exposing (..)

import Components.Delegation exposing (delegationV)
import Components.Icons exposing (IconSize(I18), mkIcon, mkIconWLabel)
import Components.IssueCard exposing (issueCard)
import Components.Tabs exposing (TabRec, mkTabBtn, mkTabRow)
import Element exposing (Element, column, el, html, row, text)
import Element.Attributes exposing (alignBottom, center, class, fill, padding, paddingTop, spacing, spread, vary, verticalCenter, width)
import Helpers exposing (checkAlreadyVoted, dubCol, genNewId, getBallot, getDemocracy, getIntField, getMembers, getResultPercent, para, relativeTime)
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(MultiMsg, NavigateTo, NoOp, SetDialog, SetField, SetIntField))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(NoTabRowBorder))
import Views.ViewHelpers exposing (SvElement, notFoundView)


democTabs : DemocracyId -> Model -> List TabRec
democTabs democId model =
    [ { id = 0
      , elem = mkIconWLabel "Current Votes" "checkbox-marked" I18
      , view = mainVotesV model democId
      }
    , { id = 1
      , elem = mkIconWLabel "Past Votes" "history" I18
      , view = pastVotesV model democId
      }
    ]


tabGroupId : DemocracyId -> Int
tabGroupId democId =
    genNewId democId 3


activeTab : DemocracyId -> Model -> Int
activeTab democId model =
    getIntField (tabGroupId democId) model


issueListSpacing =
    spacing <| scaled 2


democracyV : DemocracyId -> Model -> SvElement
democracyV democId model =
    let
        democracy =
            getDemocracy democId model

        --        adminOptions =
        --            if getAdminToggle model then
        --                [ Tabs.label
        --                    [ Options.center ]
        --                    [ Icon.i "group"
        --                    , Options.span [ css "width" "4px" ] []
        --                    , H.text "Members"
        --                    ]
        --                ]
        --            else
        --                []
        tabs =
            democTabs democId model

        tabContent tabs =
            List.head (List.filter (\{ id } -> id == activeTab democId model) tabs)
                |> Maybe.map .view
                |> Maybe.withDefault notFoundView
    in
    column NilS
        []
        [ tabContent tabs
        ]


democracyH : DemocracyId -> Model -> ( List SvElement, List SvElement, List SvElement )
democracyH democracyId model =
    let
        democracy =
            getDemocracy democracyId model

        --        adminOptions =
        --            if getAdminToggle model then
        --                [ Layout.link []
        --                    [ btn 56657685674 model [ Icon, Attr (class "sv-button-large"), Click <| NavigateTo <| CreateVoteR democracyId ] [ Icon.view "add_circle_outline" [ Icon.size36 ] ] ]
        --                ]
        --            else
        --                []
        tabs =
            democTabs democracyId model

        tabGId =
            tabGroupId democracyId

        tabRow tabs =
            mkTabRow
                (\i -> i == activeTab democracyId model)
                (SetIntField tabGId)
                tabs
                [ vary NoTabRowBorder True ]
    in
    ( []
    , [ text model.singleDemocName ]
    , [ tabRow tabs ]
    )



--    [ Layout.title [] [ text democracy.name ]
--    , Layout.spacer
--    , Layout.navigation []
--        ([ Layout.link []
--            [ btn 95679345644 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Democracy Info" <| DemocracyInfoD democracy.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
--         ]
--            ++ adminOptions
--        )
--    ]


mainVotesV : Model -> DemocracyId -> SvElement
mainVotesV model democId =
    let
        democracy =
            getDemocracy democId model
    in
    column IssueList
        [ spacing (scaled 3) ]
        [ el SubH [] (text "Open Ballots")
        , currentBallotList democracy.ballots model
        , el SubH [] (text "Upcoming Ballots")
        , futureBallotList democracy.ballots model
        , delegationV model
        ]


pastVotesV : Model -> DemocracyId -> SvElement
pastVotesV model democId =
    let
        democracy =
            getDemocracy democId model
    in
    column IssueList
        [ issueListSpacing ]
        [ el SubH [] (text "Past ballots")
        , pastBallotList democracy.ballots model
        ]


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
