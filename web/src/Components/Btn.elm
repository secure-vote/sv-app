module Components.Btn exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Msgs exposing (Msg)
import Styles.Styles exposing (SvClass(BtnS, NilS))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(..))
import Views.ViewHelpers exposing (SvAttribute, SvElement)


type BtnProps
    = PriBtn
    | SecBtn
    | Text
    | Small
    | VSmall
    | Click Msg
    | Disabled Bool
    | Warning
    | BtnNop -- doesn't do anything
    | Attr SvAttribute


btn : List BtnProps -> SvElement -> SvElement
btn props inner =
    let
        btnPropToAttr prop =
            case prop of
                PriBtn ->
                    [ vary BtnPri True, class "btn" ]

                --                    [ class "btn", padding (scaled 1) ]
                SecBtn ->
                    [ vary BtnSec True, class "btn-secondary" ]

                --                    [ class "btn-secondary", padding (scaled 1) ]
                Text ->
                    [ vary BtnText True ]

                Small ->
                    [ class "btn-outer--small" ]

                VSmall ->
                    [ vary BtnSmall True ]

                Click msg ->
                    [ onClick msg ]

                -- TODO: Btn is not safely disabled. Can be removed with Dev Tools
                Disabled bool ->
                    if bool then
                        [ attribute "disabled" "disabled" ]
                    else
                        []

                Warning ->
                    [ vary BtnWarning True ]

                BtnNop ->
                    []

                Attr attr ->
                    [ attr ]

        f btnProp attrs =
            attrs ++ btnPropToAttr btnProp

        attrs =
            List.foldl f [] props
    in
    button BtnS attrs inner



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
