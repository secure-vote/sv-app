module Views.CreateBallotV exposing (..)

import Components.BallotFields exposing (ballotFieldIds, ballotFields, ballotOptionFieldIds)
import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Components.TextF exposing (textF)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (dubCol, genNewId, getDemocracy, getField, getIntField, para)
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotFieldIds, BallotId, BallotOption, BallotOptionFieldIds)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, MultiMsg, NavigateBack, NavigateBackTo, SetField, SetIntField))
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
    column NilS
        [ spacing (scaled 4) ]
        [ ballotFields model
        , createNewBallot democId model
        ]


createNewBallot : DemocracyId -> Model -> SvElement
createNewBallot democId model =
    let
        democracy =
            getDemocracy democId model

        ballotId =
            genNewId democId <| List.length democracy.ballots

        numBallotOptions =
            List.range 0 <| getIntField ballotFieldIds.numOpts model + 1

        newBallotOption x =
            { id = ballotId + x + 1
            , name = getField (ballotOptionFieldIds x).name model
            , desc = getField (ballotOptionFieldIds x).desc model
            , result = Nothing
            }

        newBallot =
            { name = getField ballotFieldIds.name model
            , desc = getField ballotFieldIds.desc model

            --            TODO: Implement date fields.
            --            , start = Result.withDefault 0 <| String.toFloat <| getField ballotField.start model
            --            , finish = Result.withDefault 0 <| String.toFloat <| getField ballotField.finish model
            , start = 1510000000000
            , finish = 1520000000000
            , ballotOptions = List.map newBallotOption numBallotOptions
            }

        completeMsg =
            MultiMsg
                [ CreateBallot newBallot ballotId
                , AddBallotToDemocracy ballotId democId
                , NavigateBackTo <| DemocracyR democId
                ]
    in
    --    TODO: Replace placeholder text
    dubCol
        [ el SubH [] (text "Complete")
        , para [] "Your ballot, <ballot name>, will commence on the <date> at <time>. The ballot will run for <duration> and is made up of <number of options> options."
        , btn [ PriBtn, Small, Click completeMsg ] (text "Create new ballot")
        ]
        []



--
--        errorTimeFormat timeId =
--            Textf.error "Please enter an Epoch time"
--                |> Options.when
--                    (case String.toInt (Dict.get timeId model.fields ? "0") of
--                        Err err ->
--                            True
--
--                        Ok val ->
--                            False
--                    )
--
