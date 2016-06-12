import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import String



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { count : String
  }


init : (Model, Cmd Msg)
init =
  ({ count = "0" }, Cmd.none)



-- UPDATE


type Msg
  = LoadCount
  | LoadSucceed String
  | LoadFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadCount ->
      (model, getCount)

    LoadSucceed count ->
      (Model count, Cmd.none)

    LoadFail _ ->
      (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text ( model.count ) ]
    , button [ onClick LoadCount ] [ text "Load Count" ]
    ]


getCount : Cmd Msg
getCount =
  let
    url =
      "http://localhost:3000"
  in
    Task.perform LoadFail LoadSucceed (Http.get decodeCount url)

decodeCount : Json.Decoder String
decodeCount =
  Json.at ["count"] Json.string
