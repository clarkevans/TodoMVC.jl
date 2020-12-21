#!/usr/bin/env julia
using HTTP
using Sockets
using Revise
include("live_server.jl")

using TodoMVC: ROUTER

function serve(server_socket)
    HTTP.serve(ROUTER; server=server_socket, verbose=true)
end

@sync begin
    token = CancelToken()
    @async run_server(serve, token)
    readline()
    close(token)
end
