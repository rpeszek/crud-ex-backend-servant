Example backend CRUD project using Servant.  
See my CRUD umbrella project:  [typesafe-web-polyglot](https://github.com/rpeszek/typesafe-web-polyglot.git).

__Features:__  
* Servant Web API for my CRUD 'Thing' example. 
* Servant server implementation uses STM map as backend for simplicity. The data is lost 
when server is restarted.
* API compiles to Elm. Code to do that is in api-to-elm folder (separate stack/cabal project, see separate [ README](api-to-elm/README.md)) 

__TODOs:__ 
* resolve empty response incompatibility between generated Elm and Servant (https://github.com/haskell-servant/servant/issues/69 ?)
* compile Api to swagger
* compile to a Haskell client 
* compile to other languages?
* play more with Servant
* play with persistence (something new and more than STM)

__How to run:__  
```
stack build 
stack exec crud-ex-backend-servant-exe
```
To run compiled Elm use: http://localhost:3000/elm  
This will use servant served HTML page.

To run Elm in elm-reactor, clone [crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)) 
