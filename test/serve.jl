#!/usr/bin/env julia
using HTTP
using Mux

include("live_server.jl")

using Mux: http_handler
using TodoMVC: APP

function serve(server_socket)
    HTTP.serve(http_handler(APP); server=server_socket, verbose=true)
end

@sync begin
    token = CancelToken()
    @async run_server(serve, token)
    readline()
    close(token)
end
