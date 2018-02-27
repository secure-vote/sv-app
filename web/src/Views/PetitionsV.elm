module Views.PetitionsV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (card, formatNumber, para, relativeTime)
import Models exposing (Model)
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(AlignR, BoldT, GreenT, PetitionGreen))
import Time exposing (Time)
import Views.ViewHelpers exposing (SvElement, SvHeader, SvView)


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
        currentPetitions =
            List.sortBy .finish <| List.filter (\{ finish } -> finish >= model.now) petitions

        pastPetitions =
            List.reverse <| List.sortBy .finish <| List.filter (\{ finish } -> finish < model.now) petitions
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


currentListItem : Model -> Petition -> SvElement
currentListItem model { name, desc, start, finish, support } =
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
                [ minWidth (px 150) ]
                [ el NilS [ height fill ] empty
                , btn [ PriBtn, VSmall ] (text "Give Support")
                ]
            ]
        ]


pastListItem : Model -> Petition -> SvElement
pastListItem model { name, desc, start, finish, support } =
    let
        successText =
            if support < 15000 then
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
            support >= 15000

        doubleSupport =
            support >= 30000

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
            [ para [ width fill, vary BoldT True ] <| formatNumber support ++ " / 15,000 support received"
            , para [ vary GreenT gotSupport ] <| addTick gotSupport "Submitted to board"
            , para [ width fill, vary GreenT doubleSupport, vary AlignR True ] <| addTick doubleSupport "Obligatory Vote"
            ]
        , row NilS
            []
            [ el PetitionBarLeft
                [ height (px 5)
                , width (percent (min (toFloat support / 300) 100))
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


petitions =
    [ Petition "Remove H. Harold from the foundation board" "Ballot description, Lorem ipsum dolor sit amet, ei qui dicant sanctus detracto, vim homero meliore ei. Cu pro putant audire, accusam elaboraret eu sea, at congue nemore quo." 1519708000000 1522708000000 8560
    , Petition "Advertise the Swarm fund on television" "Ballot description, Lorem ipsum dolor sit amet, ei qui dicant sanctus detracto, vim homero meliore ei. Cu pro putant audire, accusam elaboraret eu sea, at congue nemore quo." 1519708000000 1526708000000 32120
    , Petition "Raise additional funds" "Ballot description, Lorem ipsum dolor sit amet, ei qui dicant sanctus detracto, vim homero meliore ei. Cu pro putant audire, accusam elaboraret eu sea, at congue nemore quo." 1519708000000 1524708000000 16503
    , Petition "Liquidate the fund to invest in Doge" "Ballot description, Lorem ipsum dolor sit amet, ei qui dicant sanctus detracto, vim homero meliore ei. Cu pro putant audire, accusam elaboraret eu sea, at congue nemore quo." 1519608000000 1519708000000 1000
    , Petition "Petition Title" "Ballot description, Lorem ipsum dolor sit amet, ei qui dicant sanctus detracto, vim homero meliore ei. Cu pro putant audire, accusam elaboraret eu sea, at congue nemore quo." 1517708000000 1518708000000 16503
    ]


type alias Petition =
    { name : String
    , desc : String
    , start : Time
    , finish : Time
    , support : Int
    }
