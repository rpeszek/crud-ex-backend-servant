module FromServant.ThingApi exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode
import Http
import String


type alias Thing =
    { name : String
    , description : String
    , userId : Maybe (Int)
    }

type alias ThingEntity =
    { id : Int
    , entity :Thing
    }

decodeThing : Decoder Thing
decodeThing =
    decode Thing
        |> required "name" string
        |> required "description" string
        |> required "userId" (maybe int)

encodeThing : Thing -> Json.Encode.Value
encodeThing x =
    Json.Encode.object
        [ ( "name", Json.Encode.string x.name )
        , ( "description", Json.Encode.string x.description )
        , ( "userId", (Maybe.withDefault Json.Encode.null << Maybe.map Json.Encode.int) x.userId )
        ]

decodeThingEntity : Decoder ThingEntity
decodeThingEntity =
    decode ThingEntity
        |> required "id" int
        |> required "entity" decodeThing

getThings : Http.Request (List (ThingEntity))
getThings =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:3000"
                , "things"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson (list decodeThingEntity)
        , timeout =
            Nothing
        , withCredentials =
            False
        }

postThings : Thing -> Http.Request (ThingEntity)
postThings body =
    Http.request
        { method =
            "POST"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:3000"
                , "things"
                ]
        , body =
            Http.jsonBody (encodeThing body)
        , expect =
            Http.expectJson decodeThingEntity
        , timeout =
            Nothing
        , withCredentials =
            False
        }

getThingsByThingId : Int -> Http.Request (Maybe (Thing))
getThingsByThingId thingId =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:3000"
                , "things"
                , thingId |> toString |> Http.encodeUri
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson (maybe decodeThing)
        , timeout =
            Nothing
        , withCredentials =
            False
        }

putThingsByThingId : Int -> Thing -> Http.Request (Thing)
putThingsByThingId thingId body =
    Http.request
        { method =
            "PUT"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:3000"
                , "things"
                , thingId |> toString |> Http.encodeUri
                ]
        , body =
            Http.jsonBody (encodeThing body)
        , expect =
            Http.expectJson decodeThing
        , timeout =
            Nothing
        , withCredentials =
            False
        }

deleteThingsByThingId : Int -> Http.Request (())
deleteThingsByThingId thingId =
    Http.request
        { method =
            "DELETE"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://localhost:3000"
                , "things"
                , thingId |> toString |> Http.encodeUri
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectStringResponse
                (\{ body } ->
                    if String.isEmpty body then
                        Ok ()
                    else
                        Err "Expected the response body to be empty"
                )
        , timeout =
            Nothing
        , withCredentials =
            False
        }