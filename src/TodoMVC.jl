module TodoMVC

using Mux
using HTTP: Request, handle
using HypertextLiteral

@app APP = (
    Mux.defaults,
    page(respond(@htl("""
     <html><body><script src="https://unpkg.com/htmx.org@0.1.2"></script>
     <button hx-post="/clicked" hx-swap="outerHTML">Click Me</button>"""))),
    page("/clicked",
      respond(htl"""<div>$("I'm clicked")</div>""")),
    Mux.notfound())

# for local testing
loopback(req::Request) = String(TodoMVC.APP.warez(req).body)
wget(url) = println(loopback(Request("GET", url)))
post(url) = println(loopback(Request("POST", url)))

include("model.jl")

end
