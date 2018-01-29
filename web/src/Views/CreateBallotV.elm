module Views.CreateBallotV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Components.Icons exposing (IconSize(I24), mkIcon)
import Components.TextF exposing (textF)
import Dict
import Element exposing (..)
import Element.Attributes exposing (fill, spacing, width)
import Helpers exposing (dubCol, genNewId, getDemocracy, getField, getIntField, para)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotFieldIds, BallotId, BallotOption, BallotOptionFieldIds)
import Models.Democracy exposing (Democracy, DemocracyId)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, MultiMsg, NavigateBack, NavigateBackTo, SetField, SetIntField))
import Result as Result
import Routes exposing (Route(DemocracyR))
import Styles.Styles exposing (SvClass(NilS, SubH, SubSubH))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


createBallotV : DemocracyId -> Model -> SvView
createBallotV democId model =
    let
        democracy =
            getDemocracy democId model
    in
    ( empty
    , header
    , body democId model
    )



-- TODO: Add validation to all text fields etc.
-- TODO: Check that vote is not in the past
--ballotFieldIds : BallotId -> BallotFieldIds
--ballotFieldIds ballotId =
--    let
--        idG x =
--            genNewId ballotId x
--    in
--    { name = idG 1
--    , desc = idG 2
--    , start = idG 3
--    , finish = idG 4
--    , numOpts = idG 5
--    }
--
--
--ballotOptionFieldIds : BallotId -> Int -> BallotOptionFieldIds
--ballotOptionFieldIds ballotId num =
--    let
--        idG x =
--            genNewId ballotId <| 6 + num * 3 + x
--    in
--    { id = idG 0
--    , name = idG 1
--    , desc = idG 2
--    }


nameTextFId =
    "ballot-name-tf"


startDateTextFId =
    "ballot-start-date-tf"


startTimeTextFId =
    "ballot-start-time-tf"


durationValueTextFId =
    "ballot-duration-value-tf"


durationTypeTextFId =
    "ballot-duration-type-tf"


descriptionTextFId =
    "ballot-description-tf"


numBallotOptionsId =
    "num-ballot-options-id"


optionNameTextFId =
    "ballot-option-name-tf"


optionDescTextFId =
    "ballot-option-description-tf"


body : DemocracyId -> Model -> SvElement
body democracyId model =
    let
        democracy =
            getDemocracy democracyId model
    in
    column NilS
        [ spacing (scaled 4) ]
        [ dubCol
            [ el SubH [] (text "Ballot Name")
            , para [] "Give your ballot a name, this will be the title that voters will see in the ballot list and also take prominent position on the voting screen."
            ]
            [ textF nameTextFId "Ballot Name" model
            ]
        , dubCol
            [ el SubH [] (text "Start Date")
            , para [] "Set the start date and time for your ballot to open. Please note that times are based on Pacific Standard Time (UTC-08:00)."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ mkIcon "calendar-range" I24
                , textF durationValueTextFId "Select Date" model
                , mkIcon "clock" I24
                , textF durationTypeTextFId "Start Time" model
                ]
            ]
        , dubCol
            [ el SubH [] (text "Ballot Duration")
            , para [] "Set the duration of the ballot. This is the time the ballot will be open for voting from the given start date above."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ textF startDateTextFId "1" model
                , textF startTimeTextFId "Week(s)" model
                ]
            , el NilS [ width fill ] (text " ")
            ]
        , dubCol
            [ el SubH [] (text "Description")
            , para [] "Provide a description of the ballot, the purpose of the vote, what it will impact and how the decision will be made. Etc..."
            ]
            [ textF descriptionTextFId "Description" model
            ]
        , el SubH [] (text "Ballot Options")

        --        , column NilS [] (allBallotOptions model)
        ]



--allBallotOptions model =
--    let
--        numBallotOptions =
--            List.range 0 <| getIntField numBallotOptionsId model + 1
--
--        ballotOptionView x =
--            let
--                indexStr =
--                    toString <| x + 1
--            in
--            dubCol
--                [ text <| "Option " ++ indexStr
--                , el SubSubH [] (text "Name")
--                , textF (optionNameTextFId ++ indexStr) "Option Name"
--                ]
--                [ el SubSubH [] (text "Description")
--                , textF (optionDescTextFId ++ indexStr) "Description"
--                ]
--    in
--    List.map ballotOptionView numBallotOptions
--        ballotId =
--            genNewId democracyId <| List.length democracy.ballots
--
--        ballotField =
--            ballotFieldIds ballotId
--
--        ballotOptionField num =
--            ballotOptionFieldIds ballotId num
--
--        ballotOptionView x =
--            div [ class "ba pa3 ma3" ]
--                [ styled p [ Typo.subhead ] [ text <| "Option " ++ (toString <| x + 1) ]
--                , textF (ballotOptionField x).name "Name" [] model
--                , textF (ballotOptionField x).desc "Description" [ Textf.textarea ] model
--                ]
--
--        numBallotOptions =
--            List.range 0 <| getIntField ballotField.numOpts model + 1
--
--        allBallotOptions =
--            map ballotOptionView numBallotOptions
--
--        newBallotOption x =
--            { id = (ballotOptionField x).id
--            , name = getField (ballotOptionField x).name model
--            , desc = getField (ballotOptionField x).desc model
--            , result = Nothing
--            }
--
--        newBallot =
--            { name = getField ballotField.name model
--            , desc = getField ballotField.desc model
--            , start = Result.withDefault 0 <| String.toFloat <| getField ballotField.start model
--            , finish = Result.withDefault 0 <| String.toFloat <| getField ballotField.finish model
--            , ballotOptions = map newBallotOption numBallotOptions
--            }
--
--        completeMsg =
--            MultiMsg
--                [ CreateBallot newBallot ballotId
--                , AddBallotToDemocracy ballotId democracyId
--                , NavigateBackTo <| DemocracyR democracyId
--                , ShowToast <| newBallot.name ++ " has been created."
--                ]
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
--        removeDisabled =
--            if getIntField ballotField.numOpts model < 1 then
--                [ Disabled ]
--            else
--                []
--
--        addBallotOption =
--            SetIntField ballotField.numOpts <| getIntField ballotField.numOpts model + 1
--
--        removeBallotOption =
--            SetIntField ballotField.numOpts <| getIntField ballotField.numOpts model - 1
--    in
--    div [ class "pa4" ] <|
--        [ styled p [ Typo.subhead ] [ text "Ballot Details:" ]
--        , textF ballotField.name "Name" [] model
--        , textF ballotField.desc "Description" [ Textf.textarea ] model
--        , textF ballotField.start "Start Time" [ errorTimeFormat ballotField.start ] model
--        , textF ballotField.finish "Finish Time" [ errorTimeFormat ballotField.finish ] model
--        , styled p [ cs "mt4", Typo.subhead ] [ text "Ballot Options:" ]
--        ]
--            ++ allBallotOptions
--            ++ [ btn 574567456755 model [ Icon, Attr (class "sv-button-large dib"), Click addBallotOption ] [ Icon.view "add_circle_outline" [ Icon.size36 ] ]
--               , btn 347584445667 model ([ Icon, Attr (class "sv-button-large dib"), Click removeBallotOption ] ++ removeDisabled) [ Icon.view "remove_circle_outline" [ Icon.size36 ] ]
--               , div [ class "mt4" ]
--                    [ btn 97546756756 model [ SecBtn, Attr (class "ma3 dib"), Click NavigateBack ] [ text "Cancel" ]
--                    , btn 85687456456 model [ PriBtn, Attr (class "ma3 dib"), Click completeMsg ] [ text "Create" ]
--                    ]
--               ]


header : SvHeader
header =
    ( []
    , [ text <| "Create a ballot" ]
    , []
    )
