module Styles.Swarm exposing (..)

import Color exposing (black, darkGray, gray, lightGray, lightOrange, orange, red, rgb, rgba, white)
import Element exposing (sub)
import Element.Attributes exposing (class, height, px)
import Style exposing (..)
import Style.Border as Bdr exposing (bottom, solid)
import Style.Color as C exposing (background)
import Style.Font as Font exposing (..)
import Style.Scale as Scale
import Style.Shadow as Shadow
import Style.Transition exposing (transitions)
import Styles.Styles exposing (SvClass(..))
import Styles.Variations exposing (IssueCardStatus(..), Variation(..))
import Time exposing (millisecond)


scaled =
    Scale.modular 10 1.618


{-| Highlight Color: #fb9823
-}
swmHltColor =
    rgb 251 152 35


swmOkColor =
    rgb 63 165 149


textColorVars =
    [ variation (VarColor red) [ C.text red ], variation BoldT [ Font.bold ] ]


headingCommon =
    [ weight 300 ] ++ textColorVars


bgHltSec =
    lightOrange


bgHltPri =
    rgb 230 180 150


bgShadow =
    rgba 10 10 10 0.5


swmStylesheet : StyleSheet SvClass Variation
swmStylesheet =
    styleSheet
        [ style NilS []
        , style HeaderStyle
            [ bottom 1.0
            , solid
            , C.border lightGray
            ]
        , style Heading <|
            [ Font.size <| scaled 4
            ]
                ++ headingCommon
        , style SubH <|
            [ Font.size <| scaled 3
            ]
                ++ headingCommon
        , style SubSubH <|
            [ Font.size <| scaled 2
            ]
                ++ headingCommon
        , style FooterText
            [ Font.weight 400
            , Font.size 13
            ]
        , style Error
            [ Font.size <| scaled 4
            , C.text red
            ]
        , style MenuBarHeading
            [ Font.size <| scaled 3
            ]
        , style TabRow
            [ bottom 1.0
            , solid
            , C.border lightGray
            , variation NoTabRowBorder
                [ bottom 0 ]
            ]
        , style TabBtn
            [ Font.size 15
            , bottom 1.0
            , solid
            , C.border <| rgba 0 0 0 0
            , variation TabBtnActive
                [ C.border <| swmHltColor
                ]

            --            , variation TabBtnActive
            --                [ pseudo "after"
            --                    [ prop "width" "100%"
            --                    , background swmHltColor
            --                    ]
            --                ]
            --            , pseudo "after"
            --                [ prop "display" "block"
            --                , background <| rgba 0 0 0 0
            --                , prop "bottom" "0"
            --                , prop "content" " "
            --                , prop "height" "1px"
            --                , prop "position" "absolute"
            --                , prop "transition" "width .25s ease, background-color .25s ease"
            --                , prop "width" "0"
            --                , prop "left" "50%"
            --                , prop "transform" "translateX(-50%)"
            --                ]
            ]
        , style IssueCard
            [ Bdr.all 1.0
            , solid
            , C.border <| rgb 200 200 200
            , Shadow.glow gray 1.0
            , cursor "pointer"
            , variation (IssueCardMod VoteDone)
                [ background swmOkColor ]
            , variation (IssueCardMod VoteWaiting)
                [ background swmHltColor
                , C.text <| rgb 255 255 255
                ]
            , variation (IssueCardMod VoteFuture)
                [ background lightGray ]
            , variation (IssueCardMod IssuePast)
                [ background lightGray ]
            ]
        , style CardFooter
            [ Font.weight 400
            , Font.size 13
            , Bdr.top 1.0
            , solid
            , C.border <| rgb 180 180 180
            ]
        , style ResultsColumn
            [ Bdr.right 1.0
            , solid
            ]
        , style ResultsSummary
            [ Bdr.all 1.0
            , solid
            ]
        , style DataParam
            [ Font.typeface [ Font.monospace ]
            ]
        , style VoteList
            [ Bdr.bottom 1.0
            , solid
            , C.border <| rgb 180 180 180
            ]
        , style DialogBackdrop
            [ background bgShadow
            , Shadow.box
                { offset = ( 0, 0 )
                , size = 15
                , blur = 15
                , color = bgShadow
                }
            ]
        , style DialogStyle
            [ background white
            , Shadow.deep
            ]
        , style BtnS
            [ variation Disabled
                [ cursor "not-allowed"
                ]
            ]
        , style InputS
            [ prop "pointer-events" "auto"
            ]
        , style ParaS
            [ variation Caps
                [ uppercase
                ]
            , variation SmallFont
                [ Font.size 11
                ]
            ]
        ]
