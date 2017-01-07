Backend support for my polyglot CRUD example/experiment. (That currently only has elm front-end
[crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)).   

Stubbed server implementation uses STM map as backend for simplicity.

__Work in progress.__  
Currently can be used with the above elm project and elm-reactor only. 
Cannot serve HTML pages yet, only JSON.

__TODOs:__ 
* compile Api to Elm
* host HTML pages so elm-reactor is not needed
* compile Api to swagger
* generate/compile Haskell client for testing
* play more with Servant

This is not part of my 'umbrella' polyglot project [typesafe-web-polyglot](https://github.com/rpeszek/typesafe-web-polyglot.git) yet.

__How to run:__  
```
stack build 
stack exec crud-ex-backend-servant-exe
```
Clone [crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)) as well and run it with elm-reactor.
