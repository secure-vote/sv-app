module Views.EditBallotV exposing (..)

import Components.BallotFields exposing (ballotFieldIds, ballotFields, ballotOptionFieldIds)
import Components.Btn exposing (BtnProps(..), btn)
import Components.TextF exposing (textF)
import Dict
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (findDemocracy, genNewId, getBallot, getDemocracy, getField, getIntField)
import List exposing (foldr, length, map, map2, range)
import Maybe.Extra exposing ((?))
import Models exposing (Model)
import Models.Ballot exposing (Ballot, BallotFieldIds, BallotId, BallotOption, BallotOptionFieldIds)
import Msgs exposing (Msg(AddBallotToDemocracy, CreateBallot, MultiMsg, NavigateBack, NavigateBackTo, SetDialog, SetField, SetIntField))
import Result as Result
import Routes exposing (DialogRoute(BallotDeleteConfirmD), Route(DemocracyR))
import Styles.Styles exposing (SvClass(NilS))
import Styles.Swarm exposing (scaled)
import Tuple exposing (first)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


editBallotV : BallotId -> Model -> SvView
editBallotV ballotId model =
    ( empty
    , header
    , body model
    )


header : SvHeader
header =
    ( []
    , [ text "Edit ballot" ]
    , []
    )


body : Model -> SvElement
body model =
    column NilS
        [ spacing (scaled 4) ]
        [ ballotFields model
        ]



--
--    let
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
--            range 0 <| max (getIntField ballotField.numOpts model - 1) 1
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
--        democracyId =
--            first <| findDemocracy ballotId model
--
--        completeMsg =
--            MultiMsg
--                [ CreateBallot newBallot ballotId
--                , NavigateBackTo <| DemocracyR democracyId
--                , ShowToast <| "Your changes to " ++ newBallot.name ++ " have been saved."
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
--                    [ btn 97546756756 model [ SecBtn, Attr (class "ma3 dib"), Click <| NavigateBackTo <| DemocracyR democracyId ] [ text "Cancel" ]
--                    , btn 85687456456 model [ PriBtn, Attr (class "ma3 dib"), Click completeMsg ] [ text "Save" ]
--                    , btn 85687456456 model [ SecBtn, Attr (class "ma3 dib btn-warning fr"), OpenDialog, Click (SetDialog "Ballot Deletion Confirmation" (BallotDeleteConfirmD ballotId)) ] [ text "Delete" ]
--                    ]
--               ]
--populateFromModel : BallotId -> Model -> Msg
--populateFromModel ballotId model =
--    let
--        ballotField =
--            ballotFieldIds ballotId
--
--        ballotOptionField num =
--            ballotOptionFieldIds ballotId num
--
--        ballot =
--            getBallot ballotId model
--
--        numBallotOptions =
--            length ballot.ballotOptions
--
--        ballotOptionMsgs ballotOption num =
--            [ SetField (ballotOptionField num).name ballotOption.name
--            , SetField (ballotOptionField num).desc ballotOption.desc
--            ]
--    in
--    MultiMsg <|
--        [ SetField ballotField.name ballot.name
--        , SetField ballotField.desc ballot.desc
--        , SetField ballotField.start <| toString ballot.start
--        , SetField ballotField.finish <| toString ballot.finish
--        , SetIntField ballotField.numOpts numBallotOptions
--        ]
--            ++ (foldr (++) [] <|
--                    map2 ballotOptionMsgs ballot.ballotOptions <|
--                        range 0 (numBallotOptions - 1)
--               )
