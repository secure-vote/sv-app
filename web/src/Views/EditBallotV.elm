module Views.EditBallotV exposing (..)

import Components.BallotFields exposing (ballotFieldIds, ballotFieldsV, ballotOptionFieldIds, checkAllFieldsValid, saveBallot)
import Components.Btn exposing (BtnProps(..), btn)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (card, dubCol, findDemocracy, genDropDown, genNewId, getBallot, getDemocracy, getDuration, getField, getIntField, getSelectField, para, timeToDateString)
import Maybe exposing (andThen)
import Models exposing (Model)
import Models.Ballot exposing (..)
import Msgs exposing (..)
import Routes exposing (DialogRoute(BallotDeleteConfirmD), Route(DemocracyR, VoteR))
import Styles.Styles exposing (SvClass(NilS, SubH))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


editBallotV : BallotId -> Model -> SvView
editBallotV ballotId model =
    ( empty
    , header
    , body ballotId model
    )


header : SvHeader
header =
    ( []
    , [ text "Edit ballot" ]
    , []
    )


body : BallotId -> Model -> SvElement
body ballotId model =
    card <|
        column NilS
            [ spacing (scaled 4) ]
            [ ballotFieldsV ballotId model
            , updateBallot ballotId model
            ]


updateBallot : BallotId -> Model -> SvElement
updateBallot ballotId model =
    let
        ballotTuple =
            saveBallot ballotId model

        editBallotMsg =
            MultiMsg
                [ CRUD <| EditBallot <| saveBallot ballotId model
                , SetState <| SBallot BallotSending ballotTuple
                , ToBc <|
                    BcSend
                        { name = "new-ballot"
                        , payload = "Awesome new Vote!"
                        , onReceipt = onReceiptMsg
                        , onConfirmation = onConfirmationMsg
                        }
                ]

        onReceiptMsg =
            MultiMsg
                [ Nav <| NBackTo <| VoteR ballotId
                , SetState <| SBallot BallotPendingEdits ballotTuple
                ]

        onConfirmationMsg =
            SetState <| SBallot BallotConfirmed ballotTuple
    in
    --    TODO: Replace placeholder text
    dubCol
        [ el SubH [] (text "Complete")
        , para [] "Your ballot, <ballot name>, will commence on the <date> at <time>. The ballot will run for <duration> and is made up of <number of options> options."
        , btn [ PriBtn, Small, Click editBallotMsg, Disabled (checkAllFieldsValid ballotId model) ] (text "Save ballot")
        ]
        []


populateFromModel : ( BallotId, Ballot ) -> Model -> Msg
populateFromModel ( ballotId, ballot ) model =
    let
        fields =
            ballotFieldIds ballotId

        optField =
            ballotOptionFieldIds ballotId

        numBallotOptions =
            List.length ballot.ballotOptions

        ballotOptionMsgs ballotOption num =
            [ SetField <| SText (optField num).name ballotOption.name
            , SetField <| SText (optField num).desc ballotOption.desc
            ]

        ( durationVal, durationType ) =
            getDuration ballot.start ballot.finish
    in
    MultiMsg <|
        [ SetField <| SText fields.name ballot.name
        , SetField <| SText fields.desc ballot.desc

        --            TODO: Implement date fields.
        , SetField <| SText fields.start <| timeToDateString ballot.start

        --        , SetTextField ballotFieldIds.finish <| toString ballot.finish
        , SetField <| SText fields.durationVal (toString durationVal)
        , SetField <| SSelect fields.durationType <| genDropDown fields.durationType (Just durationType)
        , SetField <| SInt fields.extraBalOpts <| numBallotOptions - 2
        ]
            ++ (List.foldr (++) [] <|
                    List.map2 ballotOptionMsgs ballot.ballotOptions <|
                        List.range 0 (numBallotOptions - 1)
               )
