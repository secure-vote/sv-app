module Views.DemocracyV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.CardElevation exposing (elevation)
import Date
import Helpers exposing (getAdminToggle, getBallot, getDemocracy, getMembers, getTab)
import Html exposing (Html, a, div, h1, img, span, text)
import Html.Attributes exposing (class, href)
import Material.Card as Card
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (cs, css, styled)
import Material.Table as Table
import Material.Tabs as Tabs
import Material.Typography as Typo
import Models exposing (Model)
import Models.Democracy exposing (DemocracyId)
import Msgs exposing (Msg(Mdl, NavigateTo, SetDialog, SetField, SetIntField))
import Routes exposing (DialogRoute(DemocracyInfoD, MemberInviteD))


tabId : Int
tabId =
    325645232456


type BallotStatus
    = Past
    | Current
    | Future


democracyV : DemocracyId -> Model -> Html Msg
democracyV id model =
    let
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
    in
    Tabs.render Mdl
        [ 0 ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab <| SetIntField tabId
        , Tabs.activeTab <| getTab tabId model
        ]
        ([ Tabs.label
            [ Options.center ]
            [ Icon.i "check_box"
            , Options.span [ css "width" "4px" ] []
            , text "Votes"
            ]
         , Tabs.label
            [ Options.center ]
            [ Icon.i "history"
            , Options.span [ css "width" "4px" ] []
            , text "Past"
            ]
         ]
            ++ adminOptions
        )
        [ case getTab tabId model of
            0 ->
                ballotList Current id model

            1 ->
                ballotList Past id model

            2 ->
                memberList id model

            _ ->
                h1 [ class "red" ] [ text "Not Found" ]
        ]


democracyH : DemocracyId -> Model -> List (Html Msg)
democracyH id model =
    let
        democracy =
            getDemocracy id model

        adminOptions =
            if getAdminToggle model then
                [ Layout.link []
                    [ btn 56657685674 model [ Icon, Attr (class "sv-button-large"), Link ("#create-vote/" ++ toString id) False ] [ Icon.view "add_circle_outline" [ Icon.size36 ] ] ]
                ]
            else
                []
    in
    [ Layout.title [] [ text democracy.name ]
    , Layout.spacer
    , Layout.navigation []
        ([ Layout.link []
            [ btn 2345785562 model [ Icon, Attr (class "sv-button-large"), OpenDialog, Click (SetDialog "Democracy Info" <| DemocracyInfoD democracy.desc) ] [ Icon.view "info_outline" [ Icon.size36 ] ] ]
         ]
            ++ adminOptions
        )
    ]


ballotList : BallotStatus -> DemocracyId -> Model -> Html Msg
ballotList status id model =
    let
        democracy =
            getDemocracy id model

        ballots =
            List.filter checkStatus democracy.ballots

        checkStatus id =
            case status of
                Past ->
                    (getBallot id model).finish < model.now

                _ ->
                    (getBallot id model).finish > model.now

        ballotCard ballotId =
            let
                ballot =
                    getBallot ballotId model
            in
            a [ href <| "#v/" ++ toString ballotId, class "link black" ]
                [ Card.view
                    ([ cs "ma4"
                     , css "width" "auto"
                     ]
                        ++ elevation ballotId model
                    )
                    [ Card.title [] [ text ballot.name ]
                    , Card.text [ cs "tl" ]
                        [ text ballot.desc
                        , styled span
                            [ cs "tr pa2 absolute bottom-0 right-0"
                            , Typo.caption
                            ]
                            [ text <| toString <| Date.fromTime ballot.finish ]
                        ]
                    ]
                ]
    in
    div [ class "tc" ]
        [ div [] <|
            if List.isEmpty ballots then
                case status of
                    Past ->
                        [ text "There are no past ballots" ]

                    _ ->
                        [ text "There are no current or future ballots" ]
            else
                List.map ballotCard ballots
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
                    [ btn 2345785562 model [ SecBtn, OpenDialog, Click (SetDialog "Invite Members" <| MemberInviteD) ] [ text "Invite +" ]
                    ]
                ]
            ]
        , Table.tbody [] <| List.map listItem <| getMembers id model
        ]
