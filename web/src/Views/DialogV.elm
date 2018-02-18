module Views.DialogV exposing (..)

import Components.Btn exposing (BtnProps(Click, Disabled, PriBtn, SecBtn), btn)
import Element exposing (column, el, html, paragraph, row, table, text)
import Element.Attributes exposing (alignRight, center, class, height, padding, px, spacing)
import Helpers exposing (findDemocracy, getBallot, getFloatField, getVote, para)
import List exposing (foldr, map)
import Models exposing (Model)
import Models.Ballot exposing (..)
import Models.Vote exposing (..)
import Msgs exposing (..)
import Routes exposing (Route(DemocracyR))
import Styles.Styles exposing (SvClass(Heading, NilS, SubH, SubSubH))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, cssSpinner)
import Views.VoteV exposing (getSliderValue)


subhead : String -> SvElement
subhead s =
    el SubH [] (text s)


subsubhead : String -> SvElement
subsubhead s =
    el SubSubH [] (text s)


voteConfirmDialogV : ( VoteId, Vote ) -> Model -> SvElement
voteConfirmDialogV ( voteId, vote ) model =
    let
        ballot =
            getBallot vote.ballotId model

        democracyId =
            Tuple.first <| findDemocracy vote.ballotId model

        names item =
            para [] item.name

        values item =
            para [] <| toString <| getSliderValue item.id model

        isDisabled =
            not <| (getVote voteId model).state == VoteInitial

        createVoteMsg =
            MultiMsg
                [ CRUD <| CreateVote ( voteId, vote )
                , SetState <| SVote VoteSending ( voteId, vote )
                , ToBc <|
                    BcSend
                        { name = "new-vote"
                        , payload = "Awesome new Vote!"
                        , onReceipt = onReceiptMsg
                        , onConfirmation = onConfirmationMsg
                        }
                ]

        onReceiptMsg =
            MultiMsg
                [ Nav <| NBackTo <| DemocracyR democracyId
                , SetState <| SVote VotePending ( voteId, vote )
                , HideDialog
                ]

        onConfirmationMsg =
            SetState <| SVote VoteConfirmed ( voteId, vote )
    in
    column NilS
        [ spacing (scaled 2) ]
        [ para [] "Please confirm that your vote details below are correct."
        , table NilS [ spacing (scaled 2), padding (scaled 2) ] <| [ map names ballot.ballotOptions, map values ballot.ballotOptions ]
        , row NilS
            [ spacing (scaled 2) ]
            [ btn [ SecBtn, Click HideDialog, Disabled isDisabled ] (text "Close")
            , btn [ PriBtn, Click createVoteMsg, Disabled isDisabled ] (text "Yes")
            ]
        ]


ballotDeleteConfirmDialogV : BallotId -> Model -> SvElement
ballotDeleteConfirmDialogV ballotId model =
    let
        ballot =
            getBallot ballotId model

        democracyId =
            Tuple.first <| findDemocracy ballotId model

        deleteBallotMsg =
            MultiMsg
                [ SetState <| SBallot BallotSending ( ballotId, ballot )
                , ToBc <|
                    BcSend
                        { name = "delete-ballot"
                        , payload = "Goodbye"
                        , onReceipt = onReceiptMsg
                        , onConfirmation = onConfirmationMsg
                        }
                ]

        onReceiptMsg =
            MultiMsg
                [ Nav <| NBackTo <| DemocracyR democracyId
                , SetState <| SBallot BallotPendingDeletion ( ballotId, ballot )
                , HideDialog
                ]

        onConfirmationMsg =
            CRUD <| DeleteBallot ballotId
    in
    column NilS
        [ spacing (scaled 2) ]
        [ para [] <| "Are you sure you want to delete " ++ ballot.name
        , row NilS
            [ spacing (scaled 2) ]
            [ btn [ SecBtn, Click HideDialog ] (text "Cancel")
            , btn [ PriBtn, Click deleteBallotMsg ] (text "Delete")
            ]
        ]


ballotInfoDialogV : String -> SvElement
ballotInfoDialogV desc =
    column NilS [] [ para [] desc ]


ballotOptionDialogV : String -> SvElement
ballotOptionDialogV desc =
    para [] desc


democracyInfoDialogV : String -> SvElement
democracyInfoDialogV desc =
    para [] desc


userInfoDialogV : Model -> SvElement
userInfoDialogV model =
    para [] "Lorem Ipsum"


howToVoteV : SvElement
howToVoteV =
    let
        rangeVotingCopy =
            [ "Each vote consists of a choosing a score within the range -3 to +3. "
            , "+3 indicates best option and -3 indicates the worst option. "
            , "When the voting has finished, all votes are weighted and summed, and the option with the highest weighted score wins. "
            ]

        submitVoteCopy =
            [ "Once you have finished selecting values for your vote options, your ballot will begin processing and validation. "
            , "When the process is complete you will be able to validate the integrity of your ballot if you wish. "
            ]
    in
    column NilS
        [ spacing (scaled 1) ]
        [ el SubSubH [] (text "How to use Range Voting")
        , table NilS [ spacing (scaled 1), padding (scaled 1) ] <| [ map (\a -> text "•") rangeVotingCopy, map (para []) rangeVotingCopy ]
        , el SubSubH [] (text "Submitting your vote")
        , para [ padding (scaled 1) ] <| foldr (++) "" submitVoteCopy
        , el SubSubH [] (text "How to audit your vote")
        , para [ padding (scaled 1) ] <| foldr (++) "" submitVoteCopy
        ]



--    Deprecated
--    html <|
--            Toggles.switch Mdl
--                [ adminToggleId ]
--                model.mdl
--                [ Options.onToggle <| ToggleBoolField adminToggleId
--                , Toggles.ripple
--                , Toggles.value <| getAdminToggle model
--                ]
--                [ H.text "Admin User" ]
-- Not in use
--memberInviteDialogV : Model -> SvElement
--memberInviteDialogV model =
--    column NilS
--        []
--        [ text "Invite via email"
--        , html <| textF 788765454534 "Seperate addresses with a coma" [] model
--        , text "Or Upload a CSV"
--        , html <| btn 4356373453 model [ SecBtn, Attr (HA.class "db") ] [ H.text "Choose a file" ]
--        ]
