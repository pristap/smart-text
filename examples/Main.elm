module Main exposing (Model, Msg, update, view, subscriptions, init)


import Html exposing (Html, section, div, h1, h2, h3, text, button, textarea, pre)
import Html.Attributes exposing (class, classList, style, placeholder)
import Html.Events exposing (onClick, onInput)
import HtmlBuilder exposing (..)
import SmartText exposing (..)

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }


type alias Model =
  { items : List String
  , parsed : List (List SmartText.Element)
  }


type Msg
    = ChangeItem Int String
    | AddItem
    | RemoveItem Int


replaceInList : Int -> a -> List a -> List a
replaceInList index replacement list =
  list |>
  List.indexedMap (\i original -> if i == index then replacement else original)

removeFromList : Int -> List a -> List a
removeFromList index list =
  list
  |> List.indexedMap (\i item -> if i == index then Nothing else Just item)
  |> List.filterMap identity

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeItem index newContent ->
            ( { model
            | items = replaceInList index newContent model.items
            , parsed = replaceInList index (SmartText.parse newContent) model.parsed
            }
            , Cmd.none
            )

        AddItem ->
            ( { model
            | items = List.append model.items [""]
            , parsed = List.append model.parsed [[(SmartText.Text "")]]
            }
            , Cmd.none
            )
            
        RemoveItem index ->
            ( { model
            | items = removeFromList index model.items 
            , parsed = removeFromList index model.parsed 
            }
            , Cmd.none
            )


contentTextareaStyle : Html.Attribute msg
contentTextareaStyle =
  style
    [ ("width", "100%")
    , ("background", "#E8E6E8")
    , ("border", "none")
    ]

viewItem : Int -> String -> Html Msg
viewItem index content =
    div [ class "row" ]
      [ div [ class "col-12 col-sm-6" ]
          [ textarea
            [ onInput (ChangeItem index)
            , contentTextareaStyle
            , placeholder "Enter Text"
            ]
            [ text content ] ]
      , div [ class "col-12 col-sm-6" ]
          [ HtmlBuilder.generateHtml content ]
      ]

view : Model -> Html Msg
view model =
    section [ class "container" ]
    [ div [] (List.indexedMap viewItem model.items)
    , button [ onClick AddItem ] [ text "+" ] 
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : (Model, Cmd Msg)
init =
    let
        sample = ["Sample #smart_text 👨🏻‍💻 with ❤️ by @kexoth"]
    in
    { items = sample
    , parsed = List.map SmartText.parse sample
    } ! []
