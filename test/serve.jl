#!/usr/bin/env julia
using HTTP
using Sockets
using Revise

using TodoMVC: ROUTER

HTTP.listen(request -> begin
       Revise.revise()
       Base.invokelatest(HTTP.handle, ROUTER, request)
end, Sockets.localhost, 8080, verbose=true)
