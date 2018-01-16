module Components.IssueCard exposing (..)

import Color exposing (rgb)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (checkAlreadyVoted, getBallot, readableTime)
import Models exposing (Model)
import Models.Ballot exposing (BallotId)
import Msgs exposing (Msg(NavigateTo))
import Routes exposing (Route(VoteR))
import Styles.Styles exposing (SvClass(..))
import Styles.Swarm exposing (scaled)
import Styles.Variations exposing (Variation(..))
import Views.ViewHelpers exposing (SvElement)


issueCard : Model -> BallotId -> SvElement
issueCard model ballotId =
    let
        clickMsg =
            NavigateTo <| VoteR ballotId

        ballot =
            getBallot ballotId model

        cardColor =
            if checkAlreadyVoted ballotId model then
                vary IssueCardVoteDone True
            else
                vary IssueCardVoteWaiting True

        voteStatus =
            if checkAlreadyVoted ballotId model then
                "✅ You have voted in this ballot"
            else
                "❗ You have not voted in this ballot yet"

        title =
            el SubH [] (text <| "🔴 " ++ ballot.name)

        body =
            text ballot.desc

        footer =
            row CardFooter
                [ spread ]
                [ el NilS [ alignLeft ] (text voteStatus)
                , el NilS
                    [ alignRight ]
                    (text <| "Vote closes in " ++ readableTime ballot.finish model)
                ]
    in
    column IssueCard
        [ padding <| scaled 1 ]
        [ title
        , body
        , footer
        ]



--
--
--                adminOptions =
--                    let
--                        multiMsg =
--                            MultiMsg
--                                [ populateFromModel ballotId model
--                                , NavigateTo <| EditVoteR ballotId
--                                ]
--                    in
--                    if getAdminToggle model then
--                        [ div [ class "pa2 absolute top-0 right-0" ]
--                            [ btn 84345845675 model [ Icon, Click multiMsg ] [ Icon.i "edit" ]
--                            ]
--                        ]
--                    else
--                        []
