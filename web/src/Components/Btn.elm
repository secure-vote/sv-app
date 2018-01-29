module Components.Btn exposing (..)

import Element exposing (Attribute, button, text)
import Element.Attributes exposing (attribute, class, padding, vary)
import Element.Events exposing (onClick)
import Msgs exposing (Msg)
import Styles.Styles exposing (SvClass(BtnS, NilS))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(NBad))
import Views.ViewHelpers exposing (SvAttribute, SvElement)


type BtnProps
    = PriBtn
    | SecBtn
    | Small
    | Click Msg
    | Disabled
    | Warning
    | BtnNop -- doesn't do anything
    | Attr SvAttribute


btn : List BtnProps -> SvElement -> SvElement
btn props inner =
    let
        btnPropToAttr prop =
            case prop of
                PriBtn ->
                    [ class "btn" ]

                SecBtn ->
                    [ class "btn-secondary" ]

                Small ->
                    [ class "btn-outer--small" ]

                Click msg ->
                    [ onClick msg ]

                Disabled ->
                    [ attribute "disabled" "disabled" ]

                Warning ->
                    [ vary NBad True ]

                BtnNop ->
                    []

                Attr attr ->
                    [ attr ]

        f btnProp attrs =
            attrs ++ btnPropToAttr btnProp

        attrs =
            List.foldl f [] props
    in
    button BtnS ([ padding (scaled 1) ] ++ attrs) inner



--  Material Button
--
--btn : Int -> Model -> List BtnProps -> List (Html Msg) -> Html Msg
--btn id model props inner =
--    let
--        btnPropToAttr prop =
--            case prop of
--                PriBtn ->
--                    ( [], [ Button.colored, Button.raised, Button.ripple ] )
--
--                SecBtn ->
--                    ( [], [ Button.plain, Button.raised, Button.ripple ] )
--
--                Flat ->
--                    ( [], [ Button.flat, Button.ripple ] )
--
--                Icon ->
--                    ( [], [ Button.icon ] )
--
--                Click msg ->
--                    ( [], [ Options.onClick msg ] )
--
--                Link url openNewTab ->
--                    let
--                        newTab =
--                            if openNewTab then
--                                [ Options.attribute <| target "_blank" ]
--                            else
--                                []
--                    in
--                    ( [], [ Button.link url ] ++ newTab )
--
--                Disabled ->
--                    ( [], [ Button.disabled ] )
--
--                BtnNop ->
--                    ( [], [] )
--
--                OpenDialog ->
--                    ( [], [ Dialog.openOn "click" ] )
--
--                CloseDialog ->
--                    ( [], [ Dialog.closeOn "click" ] )
--
--                Opt opt ->
--                    ( [], [ opt ] )
--
--                Attr attr ->
--                    ( [ attr ], [] )
--
--        f btnProp ( attrs, opts ) =
--            let
--                ( newAttrs, newOpts ) =
--                    btnPropToAttr btnProp
--            in
--            ( attrs ++ newAttrs, opts ++ newOpts )
--
--        ( attrs, opts ) =
--            List.foldl f ( [], [] ) props
--    in
--    div attrs
--        [ Button.render Mdl [ id ] model.mdl opts inner
--        ]
