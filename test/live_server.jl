using Revise
using Sockets

# Some async helper utils

macro async_logged(exs...)
    if length(exs) == 2
        taskname, body = exs
    elseif length(exs) == 1
        taskname = "Task"
        body = only(exs)
    end
    quote
        @async try
            $(esc(body))
        catch exc
            @error string($(esc(taskname)), " failed") exception=(exc,catch_backtrace())
            rethrow()
        end
    end
end

struct CancelToken
    cancelled::Ref{Bool}
    cond::Threads.Condition
end

CancelToken() = CancelToken(Ref(false), Threads.Condition())

function Base.close(token::CancelToken)
    lock(token.cond) do
        token.cancelled[] = true
        notify(token.cond)
    end
end
Base.isopen(token::CancelToken) = lock(()->!token.cancelled[], token.cond)
Base.wait(token::CancelToken)   = lock(()->wait(token.cond), token.cond)


#-------------------------------------------------------------------------------
# The server function
function run_server(serve, token::CancelToken, host=ip"127.0.0.1", port=8081)
    addr = Sockets.InetAddr(host, port)
    server_sockets = Channel(1)
    @sync begin
        @async_logged "Server" begin
            while isopen(token)
                @info "Starting server... press ENTER to stop."
                socket = Sockets.listen(addr)
                try
                    put!(server_sockets, socket)
                    Base.invokelatest(serve, socket)
                catch exc
                    if exc isa Base.IOError && !isopen(socket)
                        # Ok - server restarted
                        continue
                    end
                    close(socket)
                    rethrow()
                end
            end
            @info "Exited server loop"
        end

        @async_logged "Revision loop" begin
            # This is like Revise.entr but we control the event loop. This is
            # necessary because we need to exit this loop cleanly when the user
            # cancels the server, regardless of any revision event.
            while isopen(token)
                @info "Revision event"
                wait(Revise.revision_event)
                Revise.revise(throw=true)
                # Restart the server's listen loop.
                close(take!(server_sockets))
            end
            @info "Exited revise loop"
        end

        wait(token)
        @assert !isopen(token)
        notify(Revise.revision_event) # Trigger revise loop one last time.
        @info "Server done"
    end
end
