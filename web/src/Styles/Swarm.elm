module Styles.Swarm exposing (..)

import Color exposing (black, darkGray, gray, lightGray, lightOrange, orange, red, rgb, rgba)
import Style exposing (..)
import Style.Border as Bdr exposing (bottom, solid)
import Style.Color as C exposing (background)
import Style.Font as Font exposing (bold)
import Style.Scale as Scale
import Style.Shadow as Shadow
import Styles.Styles exposing (SvClass(..))
import Styles.Variations exposing (IssueCardStatus(..), Variation(..))


scaled =
    Scale.modular 10 1.618


swmHltColor =
    orange


textColorVars =
    [ variation (VarColor red) [ C.text red ] ]


headingCommon =
    [ bold ] ++ textColorVars


bgHltSec =
    lightOrange


bgHltPri =
    rgb 230 180 150


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
            [ Font.size 24
            , bottom 1.0
            , solid
            , C.border <| rgba 0 0 0 0
            , variation TabBtnActive
                [ bottom 1.0
                , solid
                , C.border swmHltColor
                ]
            ]
        , style IssueCard
            [ Bdr.all 1.0
            , solid
            , C.border <| rgb 200 200 200
            , Shadow.glow gray 1.0
            , variation (IssueCardMod VoteDone)
                [ background bgHltSec ]
            , variation (IssueCardMod VoteWaiting)
                [ background bgHltPri ]
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
        ]
