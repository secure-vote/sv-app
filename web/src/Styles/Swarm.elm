module Styles.Swarm exposing (..)

import Color exposing (black, darkGray, gray, lightCharcoal, lightGray, lightOrange, orange, red, rgb, rgba, white)
import Style exposing (..)
import Style.Border as Bdr exposing (bottom, solid)
import Style.Color as C exposing (background)
import Style.Font as Font exposing (..)
import Style.Scale as Scale
import Style.Shadow as Shadow
import Style.Transition as T
import Styles.Styles exposing (SvClass(..))
import Styles.Variations exposing (IssueCardStatus(..), Variation(..))


scaled =
    Scale.modular 10 1.618


{-| Highlight Color: #fb9823
-}
swmHltColor =
    rgb 251 152 35


swmOkColor =
    rgb 63 165 149


swmCardHltColor =
    rgb 254 234 210


swmPendColor =
    rgb 255 202 144


swmGreyColor =
    rgb 161 161 161


swmLightGreyColor =
    rgb 216 216 216


swmDarkGreyColor =
    rgb 55 58 61


swmErrColor =
    rgb 194 36 59


textVariations =
    [ variation (VarColor red) [ C.text red ]
    , variation BoldT [ Font.bold ]
    , variation Caps
        [ uppercase
        ]
    , variation SmallFont
        [ Font.size 11
        ]
    ]


headingCommon =
    [ weight 300 ] ++ textVariations


bgLightGrey =
    rgb 247 247 247


bgHltSec =
    lightOrange


bgHltPri =
    rgb 230 180 150


bgShadow =
    rgba 10 10 10 0.5


shadowSmall =
    Shadow.box
        { offset = ( 0, 1 )
        , size = 1
        , blur = 2
        , color = Color.gray
        }



--        box-shadow: 0 3px 10px 0 rgba(0,0,0,0.5);


shadowLarge =
    Shadow.box
        { offset = ( 0, 3 )
        , size = 0
        , blur = 10
        , color = rgba 0 0 0 0.5
        }


bottomBorder =
    [ Bdr.bottom 1.0
    , solid
    , C.border <| rgb 233 233 233
    ]


swmStylesheet : StyleSheet SvClass Variation
swmStylesheet =
    styleSheet
        [ style NilS []
        , style HeaderStyle
            bottomBorder
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
            , Font.weight 400
            ]
                ++ textVariations
        , style FooterText
            [ Font.weight 400
            , Font.size 13
            ]
        , style Grey
            [ C.text lightCharcoal
            ]
        , style Error
            [ Font.size <| scaled 4
            , C.text red
            ]
        , style MenuBarHeading <|
            [ Font.size <| scaled 3
            ]
                ++ headingCommon
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
        , style IssueCard <|
            [ cursor "pointer"
            , T.all
            , variation (IssueCardMod IssueVoteNow)
                [ background swmCardHltColor
                ]
            ]
                ++ bottomBorder
        , style IssueStatusS
            [ variation (IssueStatusMod IssueDone)
                [ C.text swmOkColor
                ]
            , variation (IssueStatusMod IssuePending)
                [ C.text swmPendColor
                ]
            , variation (IssueStatusMod IssueVoteNow)
                [ C.text swmHltColor
                ]
            , variation (IssueStatusMod IssueFuture)
                [ C.text swmGreyColor ]
            , variation (IssueStatusMod IssuePast)
                [ C.text swmGreyColor ]
            ]
        , style CardFooter
            [ Font.alignRight
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
            bottomBorder
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
            [ variation BtnDisabled
                [ cursor "not-allowed"
                ]
            , variation BtnWarning
                [ background swmErrColor
                ]
            , variation BtnSmall
                [ prop "width" "initial"
                , prop "flex" "none"
                ]
            ]
        , style InputS
            [ prop "pointer-events" "auto"
            , Font.size 16
            ]
        , style AdminBoxS
            []
        , style CardS
            [ background white
            , shadowLarge
            ]
        , style ParaS <|
            [ prop "white-space" "pre-wrap"
            , Font.weight 300
            ]
                ++ textVariations
        , style Notify
            [ Bdr.all 1.0
            , solid
            , C.border swmGreyColor
            , C.text white
            , Font.center
            , variation NGood
                [ background swmOkColor
                , C.text white
                , Bdr.all 0
                ]
            , variation NBad
                [ background swmErrColor
                , C.text white
                , Bdr.all 0
                ]
            ]
        , style Slider
            [ prop "margin-top" "3px"
            ]
        , style SliderBackground
            [ background swmLightGreyColor
            , Bdr.all 1.0
            , solid
            , C.border swmGreyColor
            , variation SliderGreen
                [ background swmOkColor
                ]
            , variation SliderRed
                [ background swmErrColor
                ]
            ]
        , style SliderLabel
            [ background swmDarkGreyColor
            , C.text white
            , Font.size 12
            , Bdr.rounded 8
            ]
        ]
