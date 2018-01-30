module Components.BallotFields exposing (..)

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


-- TODO: Add validation to all text fields etc.
-- TODO: Check that vote is not in the past


ballotFieldIds : BallotFieldIds
ballotFieldIds =
    { name = "ballot-name-tf"
    , desc = "ballot-description-tf"
    , startDate = "ballot-start-date-tf"
    , startTime = "ballot-start-date-tf"
    , durVal = "ballot-duration-value-tf"
    , durType = "ballot-duration-type-tf"
    , numOpts = "num-ballot-options-id"
    }


ballotOptionFieldIds : Int -> BallotOptionFieldIds
ballotOptionFieldIds num =
    { name = "ballot-option-name-tf-" ++ toString num
    , desc = "ballot-option-description-tf-" ++ toString num
    }


ballotFields : Model -> SvElement
ballotFields model =
    column NilS
        [ spacing (scaled 4) ]
        [ dubCol
            [ el SubH [] (text "Ballot Name")
            , para [] "Give your ballot a name, this will be the title that voters will see in the ballot list and also take prominent position on the voting screen."
            ]
            [ textF ballotFieldIds.name "Ballot Name" model
            ]
        , dubCol
            [ el SubH [] (text "Start Date")
            , para [] "Set the start date and time for your ballot to open. Please note that times are based on Pacific Standard Time (UTC-08:00)."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ mkIcon "calendar-range" I24
                , textF ballotFieldIds.startDate "Select Date" model
                , mkIcon "clock" I24
                , textF ballotFieldIds.startTime "Start Time" model
                ]
            ]
        , dubCol
            [ el SubH [] (text "Ballot Duration")
            , para [] "Set the duration of the ballot. This is the time the ballot will be open for voting from the given start date above."
            ]
            [ row NilS
                [ spacing (scaled 2) ]
                [ textF ballotFieldIds.durVal "1" model
                , textF ballotFieldIds.durType "Week(s)" model
                ]
            , el NilS [ width fill ] (text " ")
            ]
        , dubCol
            [ el SubH [] (text "Description")
            , para [] "Provide a description of the ballot, the purpose of the vote, what it will impact and how the decision will be made. Etc..."
            ]
            [ textF ballotFieldIds.desc "Description" model
            ]
        , ballotOptions model
        ]


ballotOptions : Model -> SvElement
ballotOptions model =
    let
        numBallotOptions =
            List.range 0 <| getIntField ballotFieldIds.numOpts model + 1

        addBallotOption =
            SetIntField ballotFieldIds.numOpts <| getIntField ballotFieldIds.numOpts model + 1

        removeBallotOption =
            SetIntField ballotFieldIds.numOpts <| getIntField ballotFieldIds.numOpts model - 1

        showRemoveOption =
            if getIntField ballotFieldIds.numOpts model < 1 then
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
                    , textF (ballotOptionFieldIds x).name "Option Name" model
                    ]
                    -- [ btn [ Attr alignRight ] (text "x Remove Option")
                    [ el SubSubH [] (text "Description")
                    , textF (ballotOptionFieldIds x).desc "Description" model
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
