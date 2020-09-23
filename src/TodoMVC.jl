module TodoMVC

using HTTP

homepage(req::HTTP.Request) =
    HTTP.Response(200,"""
<html>
  <body>
    <script src="https://unpkg.com/htmx.org@0.1.2"></script>
    <button hx-post="/clicked" hx-swap="outerHTML">Click Me</button>
  </body>
</html>
""")

clicked(req::HTTP.Request) = HTTP.Response(200,"<div>I'm clicked!</div>")

const ROUTER = HTTP.Router()
HTTP.@register(ROUTER, "GET", "/", homepage)
HTTP.@register(ROUTER, "POST", "/clicked", clicked)

function serve()
    HTTP.serve(ROUTER, "127.0.0.1", 8080)
end

end
