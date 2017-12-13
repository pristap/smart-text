module HtmlBuilder exposing (..)

import SmartText exposing (..)
import Html exposing (div, a, text, Html)
import Html.Attributes exposing (href)

generateHtml : String -> Html msg
generateHtml text =
    div []
    (parse text
    |> List.map generateNode)

generateNode : Element -> Html msg
generateNode element =
    case element of
        HashTag hashtag ->
            let
                url = "https://twitter.com/hashtag/" ++ (String.dropLeft 1 hashtag)
            in
                a [ href url ] [ text hashtag ]
        Mention mention ->
            let
                url = "https://twitter.com/" ++ (String.dropLeft 1 mention)
            in
                a [ href url ] [ text mention ]
        Text otherText ->
            text otherText