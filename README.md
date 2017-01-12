Backend support for my polyglot CRUD example/experiment. (That currently only has elm front-end
[crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)).   

Stubbed server implementation uses STM map as backend for simplicity. The data is lost 
when server is restarted.

__TODOs:__ 
* compile Api to Elm
* compile Api to swagger
* generate/compile Haskell client 
* play more with Servant
* play with persistence (something more than STM)

This is not part of my 'umbrella' polyglot project [typesafe-web-polyglot](https://github.com/rpeszek/typesafe-web-polyglot.git) yet.

__How to run:__  
```
stack build 
stack exec crud-ex-backend-servant-exe
```
To run compiled Elm use: http://localhost:3000/elm  
This will use servant served HTML page.

To run Elm in elm-reactor, clone [crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)) 
