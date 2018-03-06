module Styles.Variations exposing (..)

import Color exposing (Color)


type Variation
    = TabBtnActive
    | NoTabRowBorder
    | IssueStatusMod IssueCardStatus
    | IssueCardMod IssueCardStatus
    | VarColor Color
    | BoldT
    | BtnDisabled
    | BtnWarning
    | BtnSmall
    | Caps
    | SmallFont
    | NGood
    | NBad
    | SliderGreen
    | SliderRed


type IssueCardStatus
    = IssueDone
    | IssuePending
    | IssueVoteNow
    | IssueFuture
    | IssuePast
