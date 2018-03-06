module Styles.Styles exposing (..)

import Style exposing (Style, StyleSheet)
import Styles.Variations exposing (Variation)


type StyleOption
    = SwmStyle
    | SvStyle



--type SvClass a


type SvClass
    = Body
    | HeaderStyle
    | Heading
    | MenuBarHeading
    | SubH
    | SubSubH
    | FooterText
    | BigText
    | Grey
      -- MAX STYLES
    | ResultsBarGraph
    | ResultsSummary
    | ResultsColumn
    | DataParam
    | ParaS
    | SpinnerS
    | Notify
      -- END MAX
    | RegText
    | Error
    | TabRow
    | TabBtn
    | IssueList
    | IssueCard
    | IssueStatusS
    | IssueCardResults
    | CardFooter
    | VoteList
    | PetitionList
    | PetitionBarLeft
    | PetitionBarRight
    | PetitionBarTick
    | DialogBackdrop
    | DialogStyle
      -- TOM STYLES
    | BtnS
    | InputS
    | AdminBoxS
    | CardS
    | Slider
    | SliderBackground
    | SliderLabel
      -- END TOM
    | NilS



--    | FSty a --^ Foreign Style


commonStyles : List (Style SvClass Variation)
commonStyles =
    []
