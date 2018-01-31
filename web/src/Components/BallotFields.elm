module Components.BallotFields exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Components.TextF exposing (textF)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (dubCol, genNewId, getDemocracy, getField, getIntField, para)
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotFieldIds, BallotId, BallotOption, BallotOptionFieldIds)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, MultiMsg, NavigateBack, NavigateBackTo, SetField, SetIntField))
import Styles.Styles exposing (SvClass(NilS, SubH, SubSubH, VoteList))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


-- TODO: Add validation to all text fields etc.
-- TODO: Check that vote is not in the past


ballotFieldIds : BallotId -> BallotFieldIds
ballotFieldIds ballotId =
    { name = "ballot-name-tf-" ++ toString ballotId
    , desc = "ballot-description-tf-" ++ toString ballotId
    , startDate = "ballot-start-date-tf-" ++ toString ballotId
    , startTime = "ballot-start-date-tf-" ++ toString ballotId
    , durVal = "ballot-duration-value-tf-" ++ toString ballotId
    , durType = "ballot-duration-type-tf-" ++ toString ballotId
    , extraBalOpts = "ballot-num-extra-options-id-" ++ toString ballotId
    }


ballotOptionFieldIds : BallotId -> Int -> BallotOptionFieldIds
ballotOptionFieldIds ballotId num =
    { name = "ballot-option-name-tf-" ++ toString ballotId ++ "-" ++ toString num
    , desc = "ballot-option-description-tf-" ++ toString ballotId ++ "-" ++ toString num
    }


ballotFields : BallotId -> Model -> SvElement
ballotFields ballotId model =
    let
        field =
            ballotFieldIds ballotId
    in
    column NilS
        [ spacing (scaled 4) ]
        [ dubCol
            [ el SubH [] (text "Ballot Name")
            , para [] "Give your ballot a name, this will be the title that voters will see in the ballot list and also take prominent position on the voting screen."
            ]
            [ textF field.name "Ballot Name" [] model
            ]
        , dubCol
            [ el SubH [] (text "Start Date")
            , para [] "Set the start date and time for your ballot to open. Please note that times are based on Pacific Standard Time (UTC-08:00)."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ mkIcon "calendar-range" I24
                , textF field.startDate "Select Date" [] model
                , mkIcon "clock" I24
                , textF field.startTime "Start Time" [] model
                ]
            ]
        , dubCol
            [ el SubH [] (text "Ballot Duration")
            , para [] "Set the duration of the ballot. This is the time the ballot will be open for voting from the given start date above."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ textF field.durVal "1" [] model
                , textF field.durType "Week(s)" [] model
                ]
            , el NilS [ width fill ] (text " ")
            ]
        , dubCol
            [ el SubH [] (text "Description")
            , para [] "Provide a description of the ballot, the purpose of the vote, what it will impact and how the decision will be made. Etc..."
            ]
            [ textF field.desc "Description" [] model
            ]
        , ballotOptions ballotId model
        ]


ballotOptions : BallotId -> Model -> SvElement
ballotOptions ballotId model =
    let
        field =
            ballotFieldIds ballotId

        optField =
            ballotOptionFieldIds ballotId

        numBallotOptions =
            List.range 0 <| getIntField field.extraBalOpts model + 1

        addBallotOption =
            SetIntField field.extraBalOpts <| getIntField field.extraBalOpts model + 1

        removeBallotOption =
            SetIntField field.extraBalOpts <| getIntField field.extraBalOpts model - 1

        showRemoveOption =
            if getIntField field.extraBalOpts model < 1 then
                empty
            else
                btn [ PriBtn, Small, Click removeBallotOption ] (text "- Remove an option")

        allBallotOptions =
            List.map ballotOptionView numBallotOptions

        ballotOptionView x =
            column VoteList
                [ paddingBottom (scaled 2) ]
                [ el NilS [ paddingXY 0 10 ] (text <| "Option " ++ (toString <| x + 1))
                , dubCol
                    -- [ el NilS [ paddingXY 0 10 ] (text <| "Option " ++ indexStr)
                    [ el SubSubH [] (text "Name")
                    , textF (optField x).name "Option Name" [] model
                    ]
                    -- [ btn [ Attr alignRight ] (text "x Remove Option")
                    [ el SubSubH [] (text "Description")
                    , textF (optField x).desc "Description" [] model
                    ]
                ]
    in
    column NilS
        [ spacing (scaled 2) ]
        [ el SubH [] (text "Ballot Options")
        , column NilS [] allBallotOptions
        , row NilS
            [ spacing (scaled 2) ]
            [ btn [ PriBtn, Small, Click addBallotOption ] (text "+ Add another option")
            , showRemoveOption
            ]
        ]


saveBallot : BallotId -> Model -> ( BallotId, Ballot )
saveBallot ballotId model =
    let
        fields =
            ballotFieldIds ballotId

        optField =
            ballotOptionFieldIds ballotId

        numBallotOptions =
            List.range 0 <| getIntField fields.extraBalOpts model + 1

        newBallotOption x =
            { id = ballotId + x + 1
            , name = getField (optField x).name model
            , desc = getField (optField x).desc model
            , result = Nothing
            }

        newBallot =
            { name = getField fields.name model
            , desc = getField fields.desc model

            --            TODO: Implement date fields.
            --            , start = Result.withDefault 0 <| String.toFloat <| getField ballotField.start model
            --            , finish = Result.withDefault 0 <| String.toFloat <| getField ballotField.finish model
            , start = 1510000000000
            , finish = 1520000000000
            , ballotOptions = List.map newBallotOption numBallotOptions
            }
    in
    ( ballotId, newBallot )



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