module TodoMVC

using HTTP
import HTTP: Request, Response, handle

using HypertextLiteral

Response(status::Int, htl::HypertextLiteral.Result) = Response(status,
  [SubString("Content-Type") => SubString("text/html; charset=utf-8")];
  body=HTTP.bytes(string(htl)))
Response(node::HypertextLiteral.Result) = Response(200, htl)

homepage(req::HTTP.Request) = HTTP.Response(200, @htl("""
     <html><body><script src="https://unpkg.com/htmx.org@0.1.2"></script>
     <button hx-post="/clicked" hx-swap="outerHTML">Click Me</button>"""))

clicked(req::HTTP.Request) = HTTP.Response(200, htl"""<div>$("I'm clicked")</div>""")

const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", homepage)
HTTP.@register(ROUTER, "POST", "/clicked", clicked)

# for local testing
loopback(req::Request) = read(IOBuffer(handle(ROUTER, req).body), String)
wget(url) = println(loopback(Request("GET", url)))
post(url) = println(loopback(Request("POST", url)))

include("model.jl")

end
