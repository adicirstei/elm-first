module RandomGif where

import Effects exposing (Effects, Never)
import Html exposing(..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task

type alias Model =
  { topic : String
  , gifUrl : String
  }

init : String -> (Model, Effects Action)
init topic =
  ( Model topic "assets/waiting.gif"
  , getRandomGif topic
  )

type Action
  = RequestMore
  | NewGif (Maybe String)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    RequestMore ->
      ( model, getRandomGif model.topic )

    NewGif maybeUrl ->
      ( Model model.topic (Maybe.withDefault model.gifUrl maybeUrl)
      , Effects.none
      )


(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ "width" => "200px" ] ]
    [ h2 [headerStyle] [ text model.topic ]
    , div [imgStyle model.gifUrl] []
    , button [ onClick address RequestMore ] [ text "More Please!" ]
    ]

headerStyle : Attribute
headerStyle =
  style
    [ "width" => "200px"
    , "text-align" => "center"
    ]

imgStyle : String -> Attribute
imgStyle url =
  style
    [ "display" => "inline-block"
    , "width" => "200px"
    , "height" => "200px"
    , "background-position" => "center center"
    , "background-size" => "cover"
    , "background-image" => ("url('" ++ url ++ "')")
    ]

getRandomGif : String -> Effects Action
getRandomGif topic =
  Http.get decodeImageUrl (randomUrl topic)
    |> Task.toMaybe
    |> Task.map NewGif
    |> Effects.task


randomUrl : String -> String
randomUrl topic =
  Http.url "http://api.giphy.com/v1/gifs/random"
    [ "api_key" => "dc6zaTOxFJmzC"
    , "tag" => topic
    ]


decodeImageUrl : Json.Decoder String
decodeImageUrl =
  Json.at ["data", "image_url"] Json.string
