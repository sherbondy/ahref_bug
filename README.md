# AhrefBug

Reproducing regression introduced in Phoenix LiveView 0.18.4, re: non-LiveView rendered noop anchor tags (eg `<a href="#">Noop</a>`)
triggering parent liveview socket disconnect, relevant lines of code in `live_view.js` =>

https://github.com/phoenixframework/phoenix_live_view/blob/e1168e34fd160a85d60e0fbfe51a18526b745b0d/assets/js/phoenix_live_view/live_socket.js#L637

Note that clicking the noop link in this example (created in a hook) => causes the LiveView to disconnect (and eg counter stops).

This used to work just fine in 0.18.3 and prior releases.

Not sure if this is a deliberate breakage or accidental regression.

Expectation is for LiveView to leave non-phoenix component link tags alone (eg if a link is in a react component or otherwise embedded in page). If eg the `bindClicks` handling was ignored for a child of a `phx-update="ignore"` component or if this regression was resolved that would be amazing! Thanks!

Live example on fly:
https://ancient-hill-5520.fly.dev/

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
