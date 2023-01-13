defmodule AhrefBugWeb.PageLive do
  use AhrefBugWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign(socket, count: 0)}
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :count, fn c -> c + 1 end)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <section class="phx-hero">
        <h1><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h1>
        <p>Bug introduced in 0.18.4</p>
        <h3>Counter: <%= @count %></h3>
      </section>

      <div id="dynamic-anchor-container" phx-hook="DynamicAnchor" phx-update="ignore">
      </div>
    </div>
    """
  end
end
