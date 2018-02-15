module Components.BallotFields exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Components.TextF as TF exposing (TextField, TfProps(..), textF)
import Date
import Dict exposing (Dict)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onInput)
import Element.Input as Input
import Helpers exposing (dubCol, durationToTime, genNewId, getBallot, getDemocracy, getField, getIntField, getSelectField, para, timeToDateString)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (..)
import Msgs exposing (..)
import Styles.Styles exposing (SvClass(NilS, SubH, SubSubH, VoteList))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


-- TODO: Add validation to all text fields etc.
-- TODO: Check that vote is not in the past


ballotFieldIds : BallotId -> BallotFieldIds
ballotFieldIds ballotId =
    { name = "ballot-name-tf-" ++ toString ballotId
    , desc = "ballot-description-tf-" ++ toString ballotId
    , start = "ballot-start-time-tf-" ++ toString ballotId
    , durationVal = "ballot-duration-value-tf-" ++ toString ballotId
    , durationType = "ballot-duration-type-tf-" ++ toString ballotId
    , extraBalOpts = "ballot-num-extra-options-id-" ++ toString ballotId
    }


ballotOptionFieldIds : BallotId -> Int -> BallotOptionFieldIds
ballotOptionFieldIds ballotId num =
    { name = "ballot-option-name-tf-" ++ toString ballotId ++ "-" ++ toString num
    , desc = "ballot-option-description-tf-" ++ toString ballotId ++ "-" ++ toString num
    }


textFields : Model -> BallotId -> Dict String TextField
textFields model ballotId =
    let
        field =
            ballotFieldIds ballotId

        optField =
            ballotOptionFieldIds ballotId

        value id =
            getField id model

        numBallotOptions =
            List.range 0 <| getIntField field.extraBalOpts model + 1

        --            Validations
        empty str =
            ( String.isEmpty str, "This Field is Required" )

        inPast date =
            ( Date.toTime (Result.withDefault (Date.fromTime model.now) (Date.fromString date)) < model.now, "Date must be in the future" )

        negative num =
            ( Result.withDefault 0 (String.toFloat num) <= 0, "Number must be positive" )

        --
        tf id type_ label validation =
            ( id
            , { id = id
              , type_ = type_
              , label = label
              , props = []
              , validation = List.map (\func -> func (value id)) validation
              }
            )

        getOptionFields num =
            [ tf (optField num).name TF.Text "Option Name" [ empty ]
            , tf (optField num).desc TF.Text "Description" [ empty ]
            ]
    in
    Dict.fromList <|
        [ tf field.name TF.Text "Ballot Name" [ empty ]
        , tf field.desc TF.Text "Description" [ empty ]
        , tf field.start TF.Date "Select Date" [ empty, inPast ]
        , tf field.durationVal TF.Number "Duration" [ empty, negative ]
        ]
            ++ List.concatMap getOptionFields numBallotOptions


blankTf =
    TextField "" TF.Text "" [] []


ballotFieldsV : BallotId -> Model -> SvElement
ballotFieldsV ballotId model =
    let
        field =
            ballotFieldIds ballotId

        tf name =
            textF model <| Dict.get name (textFields model ballotId) ? blankTf
    in
    column NilS
        [ spacing (scaled 4) ]
        [ dubCol
            [ el SubH [] (text "Ballot Name")
            , para [] "Give your ballot a name, this will be the title that voters will see in the ballot list and also take prominent position on the voting screen."
            ]
            [ tf field.name
            ]
        , dubCol
            [ el SubH [] (text "Start Date")
            , para [] "Set the start date and time for your ballot to open. Please note that times are based on Pacific Standard Time (UTC-08:00)."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ mkIcon "calendar-range" I24
                , tf field.start
                ]

            --                [ mkIcon "calendar-range" I24
            --                , textF field.startDate "Select Date" [ tfIsDisabled ballotId model, Date ] model
            --                , mkIcon "clock" I24
            --                , tf field.startTime "Start Time"
            --                ]
            ]
        , dubCol
            [ el SubH [] (text "Ballot Duration")
            , para [] "Set the duration of the ballot. This is the time the ballot will be open for voting from the given start date above."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ tf field.durationVal

                --                , tf field.durType "Week(s)"
                , Input.select NilS
                    [ padding 10
                    , spacing 20
                    , minWidth (px 100)
                    ]
                    { label = Input.hiddenLabel "Duration Type"
                    , with = getSelectField field.durationType model
                    , max = 5
                    , options = []
                    , menu =
                        Input.menuAbove NilS
                            []
                            [ Input.choice Day (text "Day(s)")
                            , Input.choice Week (text "Week(s)")
                            , Input.choice Month (text "Month(s)")
                            ]
                    }
                ]
            , el NilS [ width fill ] (text " ")
            ]
        , dubCol
            [ el SubH [] (text "Description")
            , para [] "Provide a description of the ballot, the purpose of the vote, what it will impact and how the decision will be made. Etc..."
            ]
            [ tf field.desc
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
            SetField <| SInt field.extraBalOpts <| getIntField field.extraBalOpts model + 1

        removeBallotOption =
            SetField <| SInt field.extraBalOpts <| getIntField field.extraBalOpts model - 1

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
                    , tf (optField x).name
                    ]
                    -- [ btn [ Attr alignRight ] (text "x Remove Option")
                    [ el SubSubH [] (text "Description")
                    , tf (optField x).desc
                    ]
                ]

        tf name =
            textF model <| Dict.get name (textFields model ballotId) ? blankTf
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

        startTime =
            Date.toTime <| Result.withDefault (Date.fromTime model.now) <| Date.fromString <| getField fields.start model

        durationValue =
            Result.withDefault 0 (String.toFloat (getField fields.durationVal model))

        durationType =
            Input.selected <| getSelectField fields.durationType model

        newBallotOption x =
            { id = ballotId + x + 1
            , name = getField (optField x).name model
            , desc = getField (optField x).desc model
            , result = Nothing
            }

        newBallot =
            { name = getField fields.name model
            , desc = getField fields.desc model
            , start = startTime
            , finish = startTime + durationToTime ( durationValue, durationType )
            , ballotOptions = List.map newBallotOption numBallotOptions
            , state = BallotInitial
            }
    in
    ( ballotId, newBallot )



-- TODO: This isn't working for Date and Number fields.


tfIsDisabled : BallotId -> Model -> TfProps
tfIsDisabled ballotId model =
    let
        ballot =
            getBallot ballotId model
    in
    TF.Disabled <| not <| ballot.state == BallotInitial || ballot.state == BallotConfirmed


checkAllFieldsValid : BallotId -> Model -> Bool
checkAllFieldsValid ballotId model =
    let
        getValidaiton ( id, tf ) =
            tf.validation
    in
    List.any Tuple.first (List.concatMap getValidaiton (Dict.toList (textFields model ballotId)))



--    List.any Tuple.first (List.concatMap (validation ballotId model) fields)
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
