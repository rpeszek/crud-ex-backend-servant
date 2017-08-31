Example backend CRUD project using Servant.  
See my CRUD umbrella project:  [typesafe-web-polyglot](https://github.com/rpeszek/typesafe-web-polyglot.git).

__ETA Language:__
This is Eta language port of this app.
This version uses embedded jetty server.

May require latest copy of (master) eta (as of 08/30/2015). 
(Unless this is already some time in the future and eta version is > 0.0.9b2 :).)

Currently version of eta's port of servant-sever does not implemented static file serving yet.
So this branch cannot serve css/js files but works fine to serve json as a separate server (with CORS) 
for my Elm and PureScript frontends. 

Util modules are a temporary hack to investigate static file serving with Eta servant and
are work in progress.
