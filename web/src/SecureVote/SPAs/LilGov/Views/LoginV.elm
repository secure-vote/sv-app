module SecureVote.SPAs.LilGov.Views.LoginV exposing (..)

import Components.Btn exposing (BtnProps(..), btn)
import Element exposing (..)
import Element.Attributes exposing (..)
import Models exposing (Model)
import Styles.Styles exposing (SvClass(NilS))
import Styles.Swarm exposing (scaled)
import Views.ViewHelpers exposing (SvElement, SvView)


loginV : Model -> SvView
loginV model =
    ( empty
    , ( [], [], [] )
    , body
    )


body : SvElement
body =
    column NilS
        [ center, spacingXY 0 (scaled 2), padding (scaled 2) ]
        [ image NilS [ paddingXY 0 (scaled 6) ] { src = "test", caption = "SecureVote Logo" }
        , btn [ PriBtn ] (text "Participate in a vote")
        , btn [ SecBtn ] (text "Create a vote")
        , btn [ Text ] (text "Been here before? Log in >")
        , el NilS [ alignBottom ] (text "© SecureVote 2018")
        ]
