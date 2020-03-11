module Backend exposing (..)

import Dict exposing (Dict)
import Html
import Lamdera exposing (ClientId, SessionId)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( Dict.fromList []
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        SayHello ->
            ( { model | clients = Set.insert clientId model.clients }, Cmd.none )

        SaveSocks socks ->
            let
                otherClients =
                    -- "/=" means "!=" not sure why
                    Set.filter (\x -> x /= clientId) numbers
            in
            ( socks, Lamdera.sendToFrontend (BroadcastSocks socks) )
