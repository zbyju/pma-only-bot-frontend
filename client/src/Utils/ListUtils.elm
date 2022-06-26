module Utils.ListUtils exposing (..)


flatten : List (List a) -> List a
flatten list =
    List.foldr (++) [] list


addIndexToList : List a -> List ( Int, a )
addIndexToList list =
    addIndexToList_ list 0


addIndexToList_ : List a -> Int -> List ( Int, a )
addIndexToList_ list index =
    case list of
        [] ->
            []

        hd :: tl ->
            ( index, hd ) :: addIndexToList_ tl (index + 1)
