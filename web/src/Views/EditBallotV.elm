module Views.EditBallotV exposing (..)

import Components.BallotFields exposing (ballotFieldIds, ballotFieldsV, ballotOptionFieldIds, checkAllFieldsValid, saveBallot)
import Components.Btn exposing (BtnProps(..), btn)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (dubCol, findDemocracy, genDropDown, genNewId, getBallot, getDemocracy, getDuration, getField, getIntField, getSelectField, para, timeToDateString)
import Maybe exposing (andThen)
import Models exposing (Model)
import Models.Ballot exposing (..)
import Msgs exposing (DurationType(Day, Month), Msg(..))
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
                [ EditBallot <| saveBallot ballotId model
                , SetBallotState BallotSending ballotTuple
                , BlockchainSend
                    { name = "new-ballot"
                    , payload = "Awesome new Vote!"
                    , onReceipt = onReceiptMsg
                    , onConfirmation = onConfirmationMsg
                    }
                ]

        onReceiptMsg =
            MultiMsg
                [ NavigateBackTo <| VoteR ballotId
                , SetBallotState BallotPendingEdits ballotTuple
                ]

        onConfirmationMsg =
            SetBallotState BallotConfirmed ballotTuple
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
            [ SetField (optField num).name ballotOption.name
            , SetField (optField num).desc ballotOption.desc
            ]

        ( durationVal, durationType ) =
            getDuration ballot.start ballot.finish
    in
    MultiMsg <|
        [ SetField fields.name ballot.name
        , SetField fields.desc ballot.desc

        --            TODO: Implement date fields.
        , SetField fields.start <| timeToDateString ballot.start

        --        , SetField ballotFieldIds.finish <| toString ballot.finish
        , SetField fields.durationVal (toString durationVal)
        , SetSelectField fields.durationType <| genDropDown fields.durationType (Just durationType)
        , SetIntField fields.extraBalOpts <| numBallotOptions - 2
        ]
            ++ (List.foldr (++) [] <|
                    List.map2 ballotOptionMsgs ballot.ballotOptions <|
                        List.range 0 (numBallotOptions - 1)
               )
