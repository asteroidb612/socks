module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Html
import Html.Events
import Lamdera
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key, socks = Nothing }, Lamdera.sendToBackend SayHello )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Cmd.batch [ Nav.pushUrl model.key (Url.toString url) ]
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        Increment sockWearer ->
            case model.socks of
                Nothing ->
                    ( model, Cmd.none )

                Just socks ->
                    let
                        newSocks =
                            Dict.update sockWearer (Maybe.map (\x -> x + 1)) socks
                    in
                    ( { model | socks = Just newSocks }, Lamdera.sendToBackend (SaveSocks newSocks) )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        SetSocks socks ->
            ( { model | socks = Just socks }, Cmd.none )


view model =
    { title = ""
    , body =
        [ Html.button [ Html.Events.onClick (Increment "chris") ] [ Html.text "Chris wears socks" ]
        , Html.button [ Html.Events.onClick (Increment "drew") ] [ Html.text "Drew wears socks" ]
        , case model.socks of
            Just socks ->
                Html.p [] <| [ Html.text <| "Drew and Chris have worn " ++ String.fromInt (Dict.values socks |> List.sum) ++ " pairs of socks" ]

            Nothing ->
                Html.p [] []
        ]
    }
