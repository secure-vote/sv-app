module Components.Delegation exposing (..)

import Components.Btn exposing (BtnProps(Click, Disabled, PriBtn, Warning), btn)
import Components.TextF as TF exposing (textF)
import Element exposing (el, text)
import Helpers exposing (dubCol, getField, para)
import Models exposing (Model)
import Models.Democracy exposing (DelegateState(..), Democracy, DemocracyId)
import Msgs exposing (Msg(AddDelegate, MultiMsg, RemoveDelegate, Send, SetDelegateState, SetField))
import Styles.Styles exposing (SvClass(Grey, NilS, SubH))
import Views.ViewHelpers exposing (SvElement)


delegateTextFId : DemocracyId -> String
delegateTextFId democId =
    "delegate-tf-" ++ toString democId


delegationV : ( DemocracyId, Democracy ) -> Model -> SvElement
delegationV ( democId, democracy ) model =
    let
        tfId =
            delegateTextFId democId

        setDelegateMsg =
            MultiMsg
                [ SetDelegateState Sending ( democId, democracy )
                , Send
                    { name = "new-delegate"
                    , payload = "placeholder-delegate-id"
                    , onReceipt = SetDelegateState Pending ( democId, democracy )
                    , onConfirmation = AddDelegate (getField tfId model) ( democId, democracy )
                    }
                ]

        removeDelegateMsg =
            MultiMsg
                [ SetDelegateState Sending ( democId, democracy )
                , Send
                    { name = "remove-delegate"
                    , payload = "placeholder-delegate-id"
                    , onReceipt = SetDelegateState Pending ( democId, democracy )
                    , onConfirmation =
                        MultiMsg
                            [ RemoveDelegate ( democId, democracy )
                            , SetField tfId ""
                            ]
                    }
                ]

        tfValidation =
            [ ( String.isEmpty (getField tfId model), "" ) ]

        delegationInactive =
            [ el SubH [] (text "Turn on Delegation")
            , para [] "Vote delegation is disabled. You can enable vote delegation by entering the Voter ID of your nominated delegate below."
            , textF model
                { id = tfId
                , type_ = TF.Text
                , label = "Enter Voter ID"
                , props = []
                , validation = tfValidation
                }
            , btn [ PriBtn, Click setDelegateMsg, Disabled (String.isEmpty (getField tfId model)) ] (text "Nominate Delegate")
            ]

        delegationSending =
            [ el SubH [] (text "Delegation Sending")
            , para [] "Vote delegation is being sent to the blockchain"
            , el Grey [] (text <| "#" ++ getField tfId model)
            , btn [ PriBtn, Disabled True ] (text "Delegation Sending...")
            ]

        delegationPending =
            [ el SubH [] (text "Delegation Pending")
            , para [] "Vote delegation is currently pending whilst the transaction is written into the blockchain"
            , el Grey [] (text <| "#" ++ getField tfId model)
            , btn [ PriBtn, Disabled True ] (text "Delegation Pending...")
            ]

        delegationActive =
            [ el SubH [] (text "Delegation Active")
            , para [] "Vote delegation is currently active, your votes are being delegated to:"
            , el Grey [] (text <| "#" ++ getField tfId model)
            , btn [ PriBtn, Warning, Click removeDelegateMsg ] (text "Cancel Vote delegation")
            ]

        leftCol =
            [ el SubH [] (text "Vote Delegation")
            , para [] "You can choose to delegate your votes for this fund to another user, which means your tokens will automatically go towards the preferences of your nomination"
            ]

        rightCol =
            case democracy.delegate.state of
                Inactive ->
                    delegationInactive

                Sending ->
                    delegationSending

                Pending ->
                    delegationPending

                Active ->
                    delegationActive
    in
    dubCol leftCol rightCol
