module Styles.Variations exposing (..)

import Color exposing (Color)


type Variation
    = TabBtnActive
    | NoTabRowBorder
    | IssueStatusMod IssueCardStatus
    | IssueCardMod IssueCardStatus
    | VarColor Color
    | BoldT
    | SmallT
    | GreenT
    | AlignR
    | BtnDisabled
    | BtnWarning
    | BtnSmall
    | BtnText
    | Caps
    | NGood
    | NBad
    | SliderGreen
    | SliderRed
    | PetitionGreen


type IssueCardStatus
    = IssueDone
    | IssuePending
    | IssueVoteNow
    | IssueFuture
    | IssuePast
