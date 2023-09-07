defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats
  alias LiveViewStudioWeb.CustomComponents

  # Using temporary_assigns in this LiveView would greatly minimize memory usage on the server.
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>

    <CustomComponents.promo expiration={2}>
      save 25% on rentals!
      <:legal>
        <Heroicons.exclamation_circle /> Limit 1 per party
      </:legal>
    </CustomComponents.promo>

    <div id="boats">
      <.filter_form filter={@filter} />
      <div class="boats">
        <.boat :for={boat <- @boats} boat={boat} />
      </div>
    </div>

    <CustomComponents.promo>
      Hurry, only 3 boats left!
    </CustomComponents.promo>
    """
  end

  # If we are using local components, we can avoid defining the assigns
  # If we extract the function components to be reusable from different live views
  # we must define the assigns

  attr :filter, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <form phx-change="filter">
      <div class="filters">
        <select name="type">
          <%= Phoenix.HTML.Form.options_for_select(
            type_options(),
            @filter.type
          ) %>
        </select>
        <div class="prices">
          <%= for price <- ["$", "$$", "$$$"] do %>
            <input
              type="checkbox"
              name="prices[]"
              value={price}
              id={price}
              checked={price in @filter.prices}
            />
            <label for={price}><%= price %></label>
          <% end %>
          <input type="hidden" name="prices[]" value="" />
        </div>
      </div>
    </form>
    """
  end

  attr :boat, LiveViewStudio.Boats.Boat, required: true

  def boat(assigns) do
    ~H"""
    <div class="boat">
      <img src={@boat.image} />
      <div class="content">
        <div class="model">
          <%= @boat.model %>
        </div>
        <div class="details">
          <span class="price">
            <%= @boat.price %>
          </span>
          <span class="type">
            <%= @boat.type %>
          </span>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filters = %{type: type, prices: prices}
    boats = Boats.list_boats(filters)

    socket = assign(socket, boats: boats, filter: filters)
    {:noreply, socket}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
