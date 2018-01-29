module Components.Delegation exposing (..)

import Components.Btn exposing (BtnProps(Click, PriBtn, Warning), btn)
import Components.TextF exposing (textF)
import Element exposing (el, text)
import Helpers exposing (dubCol, getField, para)
import Models exposing (Model)
import Msgs exposing (DelegationState(..), Msg(MultiMsg, SetDelegate, SetDelegationState, SetField))
import Styles.Styles exposing (SvClass(SubH))
import Views.ViewHelpers exposing (SvElement)


delegateTextFId : String
delegateTextFId =
    "delegate-tf"


delegationV : Model -> SvElement
delegationV model =
    let
        delegationInactive =
            [ el SubH [] (text "Turn on Delegation")
            , para [] "Vote delegation is disabled. You can enable vote delegation by entering the Voter ID of your nominated delegate below."
            , textF delegateTextFId "Enter Voter ID" model
            , btn [ PriBtn, Click (MultiMsg [ SetDelegate (getField delegateTextFId model), SetDelegationState Active ]) ] (text "Nominate Delegate")
            ]

        delegationActive =
            [ el SubH [] (text "Delegation Active")
            , para [] "Vote delegation is currently active and your votes are being delegated to the user nominated below. You can disable delegation by using the button below."
            , textF delegateTextFId "Enter Voter ID" model
            , btn [ PriBtn, Warning, Click (MultiMsg [ SetDelegate "", SetField delegateTextFId "", SetDelegationState Inactive ]) ] (text "Turn off delegation")
            ]
    in
    dubCol
        [ el SubH [] (text "Vote Delegation")
        , para [] "You can choose to delegate your votes for this fund to another user, which means your tokens will automatically go towards the preferences of your nomination"
        ]
    <|
        case model.delegationState of
            Inactive ->
                delegationInactive

            Active ->
                delegationActive
