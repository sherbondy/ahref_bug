Application.put_env(:phoenix, :json_library, Jason)

Application.put_env(:sample, SamplePhoenix.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 5001],
  server: true,
  live_view: [signing_salt: "aaaaaaaa"],
  secret_key_base: String.duplicate("a", 64)
)

Mix.install([
  {:plug_cowboy, "~> 2.5"},
  {:jason, "~> 1.0"},
  {:phoenix, "~> 1.6.15"},
  {:phoenix_live_view, "~> 0.18.6"}
])

defmodule SamplePhoenix.ErrorView do
  use Phoenix.View, root: ""

  def render(_, _), do: "error"
end

defmodule SamplePhoenix.SampleLive do
  use Phoenix.LiveView, layout: {__MODULE__, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  def render("live.html", assigns) do
    ~H"""
    <script src="https://cdn.jsdelivr.net/npm/phoenix@1.6.15/priv/static/phoenix.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/phoenix_live_view@0.18.6/priv/static/phoenix_live_view.min.js"></script>
    <script>
      let Hooks = {};

      Hooks.DynamicAnchor = {
        mounted() {
          console.log("mounting dynamic anchor hook");
          let dynamicAnchor = document.createElement('a')
          dynamicAnchor.href = "#";
          dynamicAnchor.innerText = "Dynamic Anchor Noop Click Triggers Disconnect";
          this.el.appendChild(dynamicAnchor);
        }
      }

      let liveSocket = new window.LiveView.LiveSocket("/live", window.Phoenix.Socket, {hooks: Hooks});
      liveSocket.connect();
    </script>
    <style>
      * { font-size: 1.1em; }
    </style>
    <%= @inner_content %>
    """
  end

  def render(assigns) do
    ~H"""
    <%= @count %>
    <button phx-click="inc">+</button>
    <button phx-click="dec">-</button>

    <div id="dynamic-anchor-container" phx-hook="DynamicAnchor" phx-update="ignore">
    </div>
    """
  end

  def handle_event("inc", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count + 1)}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count - 1)}
  end
end

defmodule Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", SamplePhoenix do
    pipe_through(:browser)

    live("/", SampleLive, :index)
  end
end

defmodule SamplePhoenix.Endpoint do
  use Phoenix.Endpoint, otp_app: :sample
  socket("/live", Phoenix.LiveView.Socket)
  plug(Router)
end

{:ok, _} = Supervisor.start_link([SamplePhoenix.Endpoint], strategy: :one_for_one)
Process.sleep(:infinity)
