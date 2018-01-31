module Views.EditBallotV exposing (..)

import Components.BallotFields exposing (ballotFieldIds, ballotFields, ballotOptionFieldIds, saveBallot)
import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Dict
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (dubCol, findDemocracy, genNewId, getBallot, getDemocracy, getField, getIntField, para)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotFieldIds, BallotId, BallotOption, BallotOptionFieldIds)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, MultiMsg, NavigateBack, NavigateBackTo, SetDialog, SetField, SetIntField))
import Result as Result
import Routes exposing (DialogRoute(BallotDeleteConfirmD), Route(DemocracyR))
import Styles.Styles exposing (SvClass(NilS, SubH))
import Styles.Swarm exposing (scaled)
import Tuple exposing (first)
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
        [ ballotFields ballotId model
        , updateBallot ballotId model
        ]


updateBallot : BallotId -> Model -> SvElement
updateBallot ballotId model =
    let
        democId =
            first <| findDemocracy ballotId model

        completeMsg =
            MultiMsg
                [ CreateBallot <| saveBallot ballotId model
                , NavigateBackTo <| DemocracyR democId
                ]
    in
    --    TODO: Replace placeholder text
    dubCol
        [ el SubH [] (text "Complete")
        , para [] "Your ballot, <ballot name>, will commence on the <date> at <time>. The ballot will run for <duration> and is made up of <number of options> options."
        , btn [ PriBtn, Small, Click completeMsg ] (text "Save ballot")
        ]
        []


populateFromModel : BallotId -> Ballot -> Msg
populateFromModel ballotId ballot =
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
    in
    MultiMsg <|
        [ SetField fields.name ballot.name
        , SetField fields.desc ballot.desc

        --            TODO: Implement date fields.
        --        , SetField ballotFieldIds.start <| toString ballot.start
        --        , SetField ballotFieldIds.finish <| toString ballot.finish
        , SetIntField fields.extraBalOpts <| numBallotOptions - 2
        ]
            ++ (List.foldr (++) [] <|
                    List.map2 ballotOptionMsgs ballot.ballotOptions <|
                        List.range 0 (numBallotOptions - 1)
               )
