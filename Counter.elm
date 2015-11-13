module Counter (Model, init, Action, update, view, viewWithRemoveButton, Context) where

import Html exposing(..)
import Html.Events exposing (onClick)
import Html.Attributes as A
import Signal

type alias Model = Int

type alias Context =
  { actions : Signal.Address Action
  , remove : Signal.Address ()
  }

type Action = Increment | Decrement

viewWithRemoveButton : Context -> Model -> Html
viewWithRemoveButton context model =
  div []
    [ button [ onClick context.actions Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick context.actions Increment ] [ text "+" ]
    , div [ countStyle ] []
    , button [onClick context.remove () ] [text "X" ]
    ]


init : Int -> Model
init count = count

-- view
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ countStyle, onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [countStyle, onClick address Increment ] [ text "+" ]
    ]

countStyle : Attribute
countStyle =
  A.style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    , ("background", "#AFA")
    ]


-- update
update: Action -> Model -> Model
update action model =
  case action of
    Increment -> model + 3
    Decrement -> model - 1
