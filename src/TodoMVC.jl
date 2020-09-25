module TodoMVC

using HTTP
import HTTP: Response
using Hyperscript
@tags html body script button div

Response(status::Int, node::Hyperscript.Node) = Response(status,
  [SubString("Content-Type") => SubString("text/html; charset=utf-8")];
  body=HTTP.bytes(string(node)))
Response(node::Hyperscript.Node) = Response(200, node)

homepage(req::HTTP.Request) =
    HTTP.Response(200, html(body(
     script(src="https://unpkg.com/htmx.org@0.1.2"),
     button(hxPost="/clicked", hxSwap="outerHTML", "Click Me"))))

clicked(req::HTTP.Request) = Response(div("I'm clicked"))

const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", homepage)
HTTP.@register(ROUTER, "POST", "/clicked", clicked)

end
