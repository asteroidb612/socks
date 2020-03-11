module Backend exposing (..)

import Dict exposing (Dict)
import Html
import Lamdera exposing (ClientId, SessionId)
import Set
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
    ( { socks = Dict.fromList [ ( "drew", 0 ), ( "chris", 0 ) ], clients = Set.empty, message = "Test" }
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
            ( { model | clients = Set.insert clientId model.clients }, Lamdera.sendToFrontend clientId (SetSocks model.socks) )

        SaveSocks socks ->
            let
                otherClients =
                    model.clients
                        -- "/=" means "!=" not sure why
                        |> Set.filter (\x -> x /= clientId)
                        |> Set.toList

                broadcastFromClientId id =
                    Lamdera.sendToFrontend id (SetSocks socks)
            in
            ( model, List.map broadcastFromClientId otherClients |> Cmd.batch )
