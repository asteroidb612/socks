module Evergreen.Type.V1 exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Lamdera
import Set exposing (Set)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , socks : Socks
    }


type alias Socks =
    Dict.Dict String Int


type alias BackendModel =
    { socks : Socks
    , clients : Set Lamdera.ClientId
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | Increment String


type ToBackend
    = SayHello
    | SaveSocks Socks


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
    | BroadcastSocks Socks
