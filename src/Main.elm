port module Main exposing (main)

-- Main.elm

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url


-- main =


-- MAIN

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }
    





-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  , timer : String
  , timerCount : Int
  }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url "" 0, Cmd.none )


-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | TimerRefreshed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )
    TimerRefreshed s -> ( { model | timer = s, timerCount = model.timerCount + 1 }, Cmd.none)



-- SUBSCRIPTIONS

port refreshTimer : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ refreshTimer TimerRefreshed
  ]


-- VIEW


view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
    [ div [class "columns"]
      [ div [class "column", class "is-one-quarter"] [aside [class "menu"] [sideLinks model]]
    
      , div [class "column"] [mainView model]
      ]
    ]
  }

mainView : Model -> Html msg
mainView model =
  main_ []
    [ p [] [ text "The current URL is: "
           , b [] [ text (Url.toString model.url) ]
           ]
    , p [] [ text <| "[" ++ String.fromInt model.timerCount ++ "] "
           , text model.timer
           ]
    ]
sideLinks : Model -> Html msg
sideLinks model =
  let vl = viewLink model
  in
    div []
    [ ul [class "menu-list"]
      [ vl "/home"
      , vl "/profile"
      , vl "/reviews/the-century-of-the-self"
      , vl "/reviews/public-opinion"
      , vl "/reviews/shah-of-shahs"
      ]
    ]

viewLink : Model -> String -> Html msg
viewLink model path =
  let isActive =
        if model.url.path == path
        then [class "is-active"]
        else []
  in
    li [] [ a ([ href path ] ++ isActive) [ text path ] ]
  