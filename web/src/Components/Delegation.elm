module Components.Delegation exposing (..)

import Components.Btn exposing (BtnProps(Click, Disabled, PriBtn, Warning), btn)
import Components.TextF exposing (textF)
import Element exposing (el, text)
import Helpers exposing (dubCol, getField, para)
import Models exposing (Model)
import Msgs exposing (DelegationState(..), Msg(MultiMsg, Send, SetDelegate, SetDelegationState, SetField))
import Styles.Styles exposing (SvClass(Grey, NilS, SubH))
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
            , textF delegateTextFId "Enter Voter ID" [] model
            , btn [ PriBtn, Click (MultiMsg [ SetDelegate (getField delegateTextFId model), SetDelegationState Pending, Send ( "delegate", "test tx" ) ]) ] (text "Nominate Delegate")
            ]

        delegationPending =
            [ el SubH [] (text "Delegation Pending")
            , para [] "Vote delegation is currently pending whilst the transaction is written into the blockchain"
            , el Grey [] (text <| "#" ++ getField delegateTextFId model)
            , btn [ PriBtn, Disabled True ] (text "Delegation Pending...")
            ]

        delegationActive =
            [ el SubH [] (text "Delegation Active")
            , para [] "Vote delegation is currently active, your votes are being delegated to:"
            , el Grey [] (text <| "#" ++ getField delegateTextFId model)
            , btn [ PriBtn, Warning, Click (MultiMsg [ SetDelegate "", SetField delegateTextFId "", SetDelegationState Inactive ]) ] (text "Cancel Vote delegation")
            ]

        leftCol =
            [ el SubH [] (text "Vote Delegation")
            , para [] "You can choose to delegate your votes for this fund to another user, which means your tokens will automatically go towards the preferences of your nomination"
            ]

        rightCol =
            case model.delegationState of
                Inactive ->
                    delegationInactive

                Pending ->
                    delegationPending

                Active ->
                    delegationActive
    in
    dubCol leftCol rightCol
