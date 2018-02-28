module Views.PetitionsV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Dict
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (card, formatNumber, getSupport, para, relativeTime)
import Models exposing (Model)
import Models.Petition exposing (Petition, PetitionId)
import Msgs exposing (..)
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(AlignR, BoldT, GreenT, PetitionGreen))
import Time exposing (Time)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


submitToBoard =
    15000


obligatoryVote =
    30000


petitionsV : Model -> SvView
petitionsV model =
    ( empty
    , header
    , body model
    )


header : SvHeader
header =
    ( []
    , [ text "Petitions" ]
    , []
    )


body : Model -> SvElement
body model =
    let
        petitions =
            List.sortBy (\( key, value ) -> value.finish) <| Dict.toList model.petitions

        currentPetitions =
            List.filter (\( key, value ) -> value.finish >= model.now) petitions

        pastPetitions =
            List.reverse <| List.filter (\( key, value ) -> value.finish < model.now) petitions
    in
    column NilS
        [ spacing (scaled 4) ]
        [ row NilS
            [ spacing (scaled 4) ]
            [ card <|
                column NilS
                    [ spacing (scaled 2) ]
                    [ el SubH [] (text "Commuinty Petitions")
                    , para [] "Token holders are able to make proposals to submit petitions to the board. To be submitted, these peitions have to be backed up by other users. You can create a petition yourself, or give support to petitions started by other users below."
                    ]
            , card <|
                column NilS
                    [ spacing (scaled 2) ]
                    [ el SubH [] (text "Create a Petition")
                    , para [] "Do you have a proposal you would like the board to consider? Create a petition, gain enough support from other users and your petition will be submitted to the board for review."
                    , btn [ PriBtn ] (text "Create Petition")
                    ]
            ]
        , card <|
            column NilS
                [ spacing (scaled 2) ]
                [ el SubH [] (text "Open Petitions")
                , column NilS [] <| List.map (currentListItem model) currentPetitions
                ]
        , card <|
            column NilS
                [ spacing (scaled 2) ]
                [ el SubH [] (text "Past Petitions")
                , column NilS [] <| List.map (pastListItem model) pastPetitions
                ]
        ]


currentListItem : Model -> ( PetitionId, Petition ) -> SvElement
currentListItem model ( petId, { name, desc, start, finish, support } ) =
    let
        supportButton =
            if getSupport petId model then
                [ el NilS [ height fill ] empty
                , btn [ Attr alignRight, Click <| CRUD <| UpdateSupport ( petId, False ) ] (text "Remove support ✖")
                , btn [ PriBtn, VSmall, Disabled True ] (text "You Supported This")
                ]
            else
                [ el NilS [ height fill ] empty
                , btn [ PriBtn, VSmall, Click <| CRUD <| UpdateSupport ( petId, True ) ] (text "Give Support")
                ]
    in
    column PetitionList
        [ spacing (scaled 1), padding (scaled 2) ]
        [ row NilS
            [ spread ]
            [ el SubSubH [] (text name)
            , para [ vary AlignR True ] <| "Closes in " ++ relativeTime finish model
            ]
        , row NilS
            [ spacing (scaled 4) ]
            [ column NilS
                [ spacing (scaled 2) ]
                [ paragraph ParaS [] [ text desc, btn [ Text ] (text " View full petition details >") ]
                , progressBar support
                ]
            , column NilS
                [ minWidth (px 160), spacing (scaled 1) ]
                supportButton
            ]
        ]


pastListItem : Model -> ( PetitionId, Petition ) -> SvElement
pastListItem model ( petId, { name, desc, start, finish, support } ) =
    let
        successText =
            if support < submitToBoard then
                "Unsuccessful Petition"
            else
                "Successful Petition"
    in
    column PetitionList
        [ spacing (scaled 1), padding (scaled 2) ]
        [ row NilS
            [ spread ]
            [ el SubSubH [] (text name)
            , para [] <| successText
            ]
        , row NilS
            [ spacing (scaled 4) ]
            [ column NilS
                [ spacing (scaled 2) ]
                [ paragraph ParaS [] [ text desc, btn [ Text ] (text " View full petition details >") ]
                , progressBar support
                ]
            , column NilS
                [ minWidth (px 150) ]
                [ el NilS [ height fill ] empty
                , btn [ PriBtn, VSmall, Disabled True ] (text "Petition Closed")
                ]
            ]
        ]


progressBar : Int -> SvElement
progressBar support =
    let
        gotSupport =
            support >= submitToBoard

        doubleSupport =
            support >= obligatoryVote

        addTick bool str =
            if bool then
                "✓ " ++ str
            else
                str
    in
    column NilS
        [ width fill, spacing (scaled 2) ]
        [ row NilS
            [ spacing (scaled 1) ]
            [ para [ width fill, vary BoldT True ] <| formatNumber support ++ " / " ++ formatNumber submitToBoard ++ " support received"
            , para [ vary GreenT gotSupport ] <| addTick gotSupport "Submitted to board"
            , para [ width fill, vary GreenT doubleSupport, vary AlignR True ] <| addTick doubleSupport "Obligatory Vote"
            ]
        , row NilS
            []
            [ el PetitionBarLeft
                [ height (px 5)
                , width (percent (min (toFloat support / obligatoryVote * 100) 100))
                , vary PetitionGreen gotSupport
                ]
                empty
            , el PetitionBarRight [ height (px 5), width fill ] empty
            ]
            |> within
                [ row NilS
                    [ width fill ]
                    [ el PetitionBarTick [ height (px 12), width fill ] empty
                    , el PetitionBarTick [ height (px 12), width fill ] empty
                    ]
                ]
        ]
