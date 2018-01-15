module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.CardElevation exposing (elevation)
import Components.Icons exposing (IconSize(I18), mkIcon, mkIconWLabel)
import Components.Tabs exposing (mkTabBtn, mkTabRow)
import Element exposing (Element, button, column, html, row)
import Element.Attributes exposing (center, padding, paddingTop, spacing, verticalCenter)
import Element.Events exposing (onClick)
import Helpers exposing (findVoteExists, genNewId, getAdminToggle, getBallot, getDemocracy, getIntField, getMembers, getResultPercent, readableTime)
import Html exposing (Html, a, div, h1, img, span, text)
import Html.Attributes exposing (class, href)
import Material.Card as Card
import Material.Color as Color
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Table as Table
import Material.Tabs as Tabs
import Material.Typography as Typo
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(Mdl, MultiMsg, NavigateTo, SetDialog, SetField, SetIntField))
import Routes exposing (DialogRoute(DemocracyInfoD, MemberInviteD), Route(CreateVoteR, EditVoteR, ResultsR, VoteR))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation)
import Views.EditBallotV exposing (populateFromModel)
import Views.ViewHelpers exposing (SvElement, notFoundView)


type BallotStatus
    = Past
    | Current
    | Future


democracyV : DemocracyId -> Model -> SvElement
democracyV democId model =
    let
        democracy =
            getDemocracy democId model

        tabGroupId =
            genNewId democId 3

        adminOptions =
            if getAdminToggle model then
                [ Tabs.label
                    [ Options.center ]
                    [ Icon.i "group"
                    , Options.span [ css "width" "4px" ] []
                    , text "Members"
                    ]
                ]
            else
                []

        tabs =
            [ { id = 0
              , elem = mkIconWLabel "Votes" "checkbox-marked" I18
              , view = mainVotesV model democId
              }
            , { id = 1
              , elem = mkIconWLabel "Past" "history" I18
              , view = pastVotesV model democId
              }
            ]

        activeTab =
            getIntField tabGroupId model

        tabRow tabs =
            mkTabRow model
                (\i -> i == activeTab)
                (SetIntField tabGroupId)
                tabs

        tabContent tabs =
            List.head (List.filter (\{ id } -> id == activeTab) tabs)
                |> Maybe.map .view
                |> Maybe.withDefault notFoundView
    in
    column NilS
        []
        [ tabRow tabs
        , tabContent tabs
        ]



--        ([ Tabs.label
--
--         , Tabs.label
--
--         ]
--            ++ adminOptions
--        )
--        ([]
--            ++ (case getIntField tabId model of
--                    0 ->
--                        [ currentBallotList democracy.ballots model
--                        , futureBallotList democracy.ballots model
--                        ]
--
--                    1 ->
--                        [ pastBallotList democracy.ballots model ]
--
--                    2 ->
--                        [ memberList democracyId model ]
--
--                    _ ->
--                        [ h1 [ class "red" ] [ text "Not Found" ] ]
--               )
--        )


democracyH : DemocracyId -> Model -> List (Html Msg)
democracyH democracyId model =
    let
        democracy =
            getDemocracy democracyId model

        adminOptions =
            if getAdminToggle model then
                [ Layout.link []
                    [ btn 56657685674 model [ Icon, Attr (class "sv-button-large"), Click <| NavigateTo <| CreateVoteR democracyId ] [ Icon.view "add_circle_outline" [ Icon.size36 ] ] ]
                ]
            else
                []
    in
    [ Layout.title [] [ text democracy.name ]
    , Layout.spacer
    , Layout.navigation []
        ([ Layout.link []
            [ btn 95679345644 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Democracy Info" <| DemocracyInfoD democracy.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
         ]
            ++ adminOptions
        )
    ]


mainVotesV : Model -> DemocracyId -> SvElement
mainVotesV model democId =
    let
        democracy =
            getDemocracy democId model
    in
    column IssueList
        []
        [ html <| currentBallotList democracy.ballots model
        , html <| futureBallotList democracy.ballots model
        ]


pastVotesV : Model -> DemocracyId -> SvElement
pastVotesV model democId =
    let
        democracy =
            getDemocracy democId model
    in
    column IssueList [] [ html <| pastBallotList democracy.ballots model ]


currentBallotList : List BallotId -> Model -> Html Msg
currentBallotList ballots model =
    let
        filteredBallots =
            List.sortWith compareFinish <| List.filter filterStatus ballots

        compareFinish a b =
            compare (getBallot a model).finish (getBallot b model).finish

        filterStatus id =
            (getBallot id model).finish > model.now && (getBallot id model).start <= model.now

        ballotCard ballotId =
            let
                ballot =
                    getBallot ballotId model

                cardColor =
                    if findVoteExists ballotId model then
                        Color.color Color.Amber Color.S50
                    else
                        Color.color Color.Amber Color.S300

                voteStatus =
                    if findVoteExists ballotId model then
                        "✅ You have voted in this ballot"
                    else
                        "❗ You have not voted in this ballot yet"

                adminOptions =
                    let
                        multiMsg =
                            MultiMsg
                                [ populateFromModel ballotId model
                                , NavigateTo <| EditVoteR ballotId
                                ]
                    in
                    if getAdminToggle model then
                        [ div [ class "pa2 absolute top-0 right-0" ]
                            [ btn 84345845675 model [ Icon, Click multiMsg ] [ Icon.i "edit" ]
                            ]
                        ]
                    else
                        []
            in
            Card.view
                ([ cs "ma4"
                 , css "width" "auto"
                 , Color.background cardColor
                 , Options.onClick <| NavigateTo <| VoteR ballotId
                 ]
                    ++ elevation ballotId model
                )
                [ Card.title [ cs "b" ] [ text <| "🔴 " ++ ballot.name ]
                , Card.text [ cs "tl" ]
                    [ text ballot.desc
                    , styled span
                        [ cs "tr pa2 absolute bottom-0 right-0"
                        , Typo.caption
                        ]
                        [ text <| "Vote closes in " ++ readableTime ballot.finish model ]
                    ]
                , Card.actions [ Card.border, cs "tl" ]
                    ([ styled span [ Typo.caption ] [ text voteStatus ]
                     ]
                        ++ adminOptions
                    )
                ]
    in
    div [ class "tc" ]
        [ div [] <|
            if List.isEmpty ballots then
                [ text "There are no current ballots" ]
            else
                List.map ballotCard filteredBallots
        ]


futureBallotList : List BallotId -> Model -> Html Msg
futureBallotList ballots model =
    let
        filteredBallots =
            List.sortWith checkStart <| List.filter filterStatus ballots

        checkStart a b =
            compare (getBallot a model).start (getBallot b model).start

        filterStatus id =
            (getBallot id model).finish > model.now && (getBallot id model).start >= model.now

        ballotCard ballotId =
            let
                ballot =
                    getBallot ballotId model

                adminOptions =
                    let
                        multiMsg =
                            MultiMsg
                                [ populateFromModel ballotId model
                                , NavigateTo <| EditVoteR ballotId
                                ]
                    in
                    if getAdminToggle model then
                        [ Card.actions []
                            [ div [ class "pa2 absolute top-0 right-0" ]
                                [ btn 678465546456 model [ Icon, Click multiMsg ] [ Icon.i "edit" ]
                                ]
                            ]
                        ]
                    else
                        []
            in
            Card.view
                ([ cs "ma4"
                 , css "width" "auto"
                 , Color.background (Color.color Color.Grey Color.S200)
                 , Options.onClick <| NavigateTo <| VoteR ballotId
                 ]
                    ++ elevation ballotId model
                )
                ([ Card.title [] [ text ballot.name ]
                 , Card.text [ cs "tl" ]
                    [ text ballot.desc
                    , styled span
                        [ cs "tr pa2 absolute bottom-0 right-0"
                        , Typo.caption
                        ]
                        [ text <| "Vote opens in " ++ readableTime ballot.start model ]
                    ]
                 ]
                    ++ adminOptions
                )
    in
    div [ class "tc" ]
        [ div [] <|
            if List.isEmpty ballots then
                [ text "There are no future ballots" ]
            else
                List.map ballotCard filteredBallots
        ]


pastBallotList : List BallotId -> Model -> Html Msg
pastBallotList ballots model =
    let
        filteredBallots =
            List.sortWith compareFinish <| List.filter filterStatus ballots

        compareFinish a b =
            compare (getBallot b model).finish (getBallot a model).finish

        filterStatus id =
            (getBallot id model).finish < model.now

        ballotCard ballotId =
            let
                ballot =
                    getBallot ballotId model

                resultString { name, result } =
                    name ++ " - " ++ toString (getResultPercent ballot <| result ? 0) ++ "%, "

                displayResults =
                    "Results: " ++ (List.foldr (++) "" <| List.map resultString ballot.ballotOptions)

                adminOptions =
                    let
                        multiMsg =
                            MultiMsg
                                [ populateFromModel ballotId model
                                , NavigateTo <| EditVoteR ballotId
                                ]
                    in
                    if getAdminToggle model then
                        [ Card.actions []
                            [ div [ class "pa2 absolute top-0 right-0" ]
                                [ btn 68456873456 model [ Icon, Click multiMsg ] [ Icon.i "edit" ]
                                ]
                            ]
                        ]
                    else
                        []
            in
            Card.view
                ([ cs "ma4"
                 , css "width" "auto"
                 , Color.background (Color.color Color.Grey Color.S200)
                 , Options.onClick <| NavigateTo <| ResultsR ballotId
                 ]
                    ++ elevation ballotId model
                )
                ([ Card.title [] [ text ballot.name ]
                 , Card.text [ cs "tl" ]
                    [ text displayResults
                    , styled span
                        [ cs "tr pa2 absolute bottom-0 right-0"
                        , Typo.caption
                        ]
                        [ text <| "Vote closed " ++ readableTime ballot.finish model ++ " ago" ]
                    ]
                 ]
                    ++ adminOptions
                )
    in
    div [ class "tc" ]
        [ div [] <|
            if List.isEmpty ballots then
                [ text "There are no past ballots" ]
            else
                List.map ballotCard filteredBallots
        ]


memberList : DemocracyId -> Model -> Html Msg
memberList id model =
    let
        listItem { firstName, lastName } =
            Table.tr []
                [ Table.td [ cs "tl" ] [ text <| firstName ++ " " ++ lastName ]
                , Table.td [] [ Icon.i "edit" ]
                ]
    in
    Table.table [ cs "w-100" ]
        [ Table.thead []
            [ Table.tr []
                [ Table.th [ cs "tl" ] [ text "Name" ]
                , Table.th []
                    [ btn 945674563456 model [ SecBtn, OpenDialog, Click (SetDialog "Invite Members" <| MemberInviteD) ] [ text "Invite +" ]
                    ]
                ]
            ]
        , Table.tbody [] <| List.map listItem <| getMembers id model
        ]
