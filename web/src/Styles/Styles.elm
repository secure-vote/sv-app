module Styles.Styles exposing (..)

import Style exposing (StyleSheet)


type StyleOption
    = SwmStyle
    | SvStyle


type SvClass
    = HeaderStyle
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
    | DialogBackdrop
    | DialogStyle
      -- TOM STYLES
    | BtnS
    | InputS
    | AdminBoxS
    | CardS
    | Slider
    | SliderBackground
      -- END TOM
    | NilS
