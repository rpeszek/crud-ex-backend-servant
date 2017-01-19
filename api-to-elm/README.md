Subproject of https://github.com/rpeszek/crud-ex-backend-servant.git.

Compiles Servant Web 'Thing' API to Elm.

Notes:  It uses symbolic link for src-api folder.  Not sure how well this works
when the git project is cloned.  Basically this expects something like this:

```
ln -s <parent dir>/crud-ex-backend-servant/src-api <parent dir>/crud-ex-backend-servant/api-to-elm/src-api
```

__TODOs:__   
*  Move to using https://github.com/mattjbray/servant-elm.git dynamic-base-urls branch to use dynamic server base url.
*  Incorporate compiled code to [crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git))
