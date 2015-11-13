import Counter
import Html exposing (..)
import Html.Events exposing (onClick)
import StartApp.Simple exposing (start)

type alias Model =
  { counters : List ( ID, Counter.Model )
  , nextID : ID
  }

type alias ID = Int

type Action
  = Insert
  | Remove
  | Modify ID Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let newCounter = ( model.nextID, Counter.init 0 )
          newCounters = model.counters ++ [ newCounter ]
      in
          { model |
              counters <- newCounters,
              nextID <- model.nextID + 1
          }

    Remove ->
      { model | counters <- List.drop 1 model.counters }

    Modify id counterAction ->
      let updateCounter (counterID, counterModel) =
            if counterID == id
              then (counterID, Counter.update counterAction counterModel)
              else (counterID, counterModel)
      in
          { model | counters <- List.map updateCounter model.counters }


view : Signal.Address Action -> Model -> Html
view address model =
  let counters = List.map (viewCounter address) model.counters
      remove = button [ onClick address Remove ] [ text "Remove" ]
      insert = button [ onClick address Insert ] [ text "Insert" ]
  in
    div [] ([remove, insert] ++ counters)

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address ( id, model ) =
  Counter.view (Signal.forwardTo address (Modify id)) model

main =
  start { model = { counters = [], nextID = 0}, update = update, view = view }
