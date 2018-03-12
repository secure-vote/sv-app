module SecureVote.SPAs.LilGov.Models exposing (..)

import Components.Navigation exposing (NavModel, initNavModel)
import Dict exposing (Dict)
import Element.Input as Input exposing (SelectMsg, SelectWith)
import Json.Decode exposing (Value)
import Models.Ballot exposing (Ballot, BallotId, BallotOption, BallotState(BallotConfirmed))
import Models.Democracy exposing (Delegate, DelegateState(Inactive), Democracy, DemocracyId)
import Models.Petition exposing (Petition, PetitionId)
import Models.Vote exposing (Vote, VoteId)
import SecureVote.SPAs.LilGov.Msgs exposing (..)
import SecureVote.SPAs.LilGov.Routes exposing (DialogRoute(NotFoundD), LilGovRoute)
import Styles.Styles exposing (StyleOption(SvStyle, SwmStyle))
import Time exposing (Time)


type alias Model =
    { navModel : NavModel LilGovRoute
    , now : Time
    }


initModel : LilGovRoute -> Flags -> Model
initModel initRoute flags =
    { navModel = initNavModel initRoute
    , now = 0
    }


type alias Flags =
    {}
