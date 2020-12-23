# TodoMVC.jl -- a Julia TodoMVC application /w server-side views

TodoMVC.jl is an example [TodoMVC.com](http://todomvc.com) application
with server-side view generation using [htmx.js](https://htmx.org) and
[Hyperscript.jl](https://github.com/yurivish/Hyperscript.jl). This file
serves as both documentation and a regression test.

    using TodoMVC: wget, post

    wget("/")
    #=>
    <html><body><script src="https://unpkg.com/htmx.org@0.1.2"></script>
    <button hx-post="/clicked" hx-swap="outerHTML">Click Me</button>
    =#

    post("/clicked")
    #-> <div>I&apos;m clicked</div>

We can create server-side objects to test them.

    using TodoMVC: Todo

    Todo("Testing")
    #-> Todo("Testing", TodoMVC.ACTIVE, UUID(…

