Backend support for my polyglot CRUD 'Thing' example/experiment. (That currently only has elm front-end
[crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)).   

__Features:__  
* Servant API for my CRUD 'Thing' example. 
* Servant server implementation uses STM map as backend for simplicity. The data is lost 
when server is restarted.
* API compiles to Elm. Code to do that is in api-to-elm folder (separate stack/cabal project, see [That README](api-to-elm/README.md)) (Work in progress.)

__TODOs:__ 
* compile Api to swagger
* compile to a Haskell client 
* compile to other languages?
* play more with Servant
* play with persistence (something new and more than STM)

This is not part of my 'umbrella' polyglot project [typesafe-web-polyglot](https://github.com/rpeszek/typesafe-web-polyglot.git) yet.

__How to run:__  
```
stack build 
stack exec crud-ex-backend-servant-exe
```
To run compiled Elm use: http://localhost:3000/elm  
This will use servant served HTML page.

To run Elm in elm-reactor, clone [crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)) 
