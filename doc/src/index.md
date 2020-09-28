# TodoMVC.jl -- a Julia TodoMVC application /w server-side views

TodoMVC.jl is an example [TodoMVC.com](http://todomvc.com) application
with server-side view generation using [htmx.js](https://htmx.org) and
[Hyperscript.jl](https://github.com/yurivish/Hyperscript.jl). This file
serves as both documentation and a regression test.

    using TodoMVC: wget, post

    wget("/")
    #-> …<button hx-post="/clicked" hx-swap="outerHTML">…

    post("/clicked")
    #-> <div>I&#39;m clicked</div>
