module Views.CreateBallotV exposing (..)

import Components.BallotFields exposing (ballotFieldIds, ballotFields, ballotOptionFieldIds, saveBallot)
import Components.Btn exposing (BtnProps(..), btn)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (dubCol, genNewId, getDemocracy, getField, getIntField, para)
import Models exposing (Model)
import Models.Ballot exposing (..)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg(CreateBallot, MultiMsg, NavigateBack, NavigateBackTo, NoOp, Send, SetBallotState, SetField, SetIntField))
import Routes exposing (Route(DemocracyR))
import Styles.Styles exposing (SvClass(NilS, SubH, SubSubH, VoteList))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


createBallotV : DemocracyId -> Model -> SvView
createBallotV democId model =
    ( empty
    , header
    , body democId model
    )


header : SvHeader
header =
    ( []
    , [ text "Create a ballot" ]
    , []
    )


body : DemocracyId -> Model -> SvElement
body democId model =
    let
        democracy =
            getDemocracy democId model

        ballotId =
            genNewId democId <| List.length democracy.ballots
    in
    column NilS
        [ spacing (scaled 4) ]
        [ ballotFields ballotId model
        , createNewBallot democId ballotId model
        ]


createNewBallot : DemocracyId -> BallotId -> Model -> SvElement
createNewBallot democId ballotId model =
    let
        ballotTuple =
            saveBallot ballotId model

        createBallotMsg =
            MultiMsg
                [ CreateBallot democId ballotTuple
                , SetBallotState BallotSending ballotTuple
                , Send
                    { name = "new-ballot"
                    , payload = "Awesome new Vote!"
                    , onReceipt = onReceiptMsg
                    , onConfirmation = onConfirmationMsg
                    }
                ]

        onReceiptMsg =
            MultiMsg
                [ NavigateBackTo <| DemocracyR democId
                , SetBallotState BallotPendingCreation ballotTuple
                ]

        onConfirmationMsg =
            SetBallotState BallotConfirmed ballotTuple
    in
    --    TODO: Replace placeholder text
    dubCol
        [ el SubH [] (text "Complete")
        , para [] "Your ballot, <ballot name>, will commence on the <date> at <time>. The ballot will run for <duration> and is made up of <number of options> options."
        , btn [ PriBtn, Small, Click createBallotMsg ] (text "Create new ballot")
        ]
        []
