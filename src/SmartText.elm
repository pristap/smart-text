module SmartText exposing (parse, Element(HashTag, Mention, Text))

{-| Parse message content using the `parse` function. Returns elements that can be rendered.
# Parsing Function
@docs parse
# Return Type
@docs Element
-}

import Regex exposing (..)

{-|-}
type Element
    = HashTag String
    | Mention String
    | Text String
    -- | Url String

{-| Parsing Function
    tweet = SmartText.parse "Sample #smart_text 👨🏻‍💻 with ❤️ by @kexoth."
    > [Text "Sample ",HashTag "#smart_text",Text " 👨🏻‍💻 with ❤️ by ",Mention "@kexoth",Text "."]
        : List SmartText.Element
-}
parse : String -> List Element
parse text =
    let
        -- In future for Mentions add or-pattern-regex
        matches = find All (regex combinedRegex) text
        
        regularText = split All (regex combinedRegex) text
        |> List.map markText

        marked = matches
        |> List.map .match
        |> List.map markText
    in
        combine regularText marked []
    

markText : String -> Element
markText text =
    case String.uncons text of
        Just ('#', _) ->
            (HashTag text)
        Just ('@', _) ->
            (Mention text)
        _ ->
            (Text text)

combine : List Element -> List Element -> List Element -> List Element
combine firstList secondList resultList =
    case (firstList, secondList) of
        ([], []) ->
            resultList
        (x :: rest, other) ->
            combine other rest (resultList ++ [x])
        ([], x :: rest) ->
            combine rest [] (resultList ++ [x])

combinedRegex : String 
combinedRegex =
    hashtagRegex ++ "|" ++ mentionRegex
hashtagRegex : String
hashtagRegex = "\\B#\\w*[a-zA-Z0-9_-]+\\w*"
mentionRegex : String
mentionRegex = "\\B@\\w*[a-zA-Z0-9_-]+\\w*"