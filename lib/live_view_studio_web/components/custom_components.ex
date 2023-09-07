defmodule LiveViewStudioWeb.CustomComponents do
  use Phoenix.Component

  attr :expiration, :integer, default: 24
  slot :legal
  slot :inner_block, required: true

  def promo(assigns) do
    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>

      <dev class="expiration">
        Deal Expires in <%= @expiration %> hours
      </dev>
      <dev class="legal">
        <%= render_slot(@legal) %>
      </dev>
    </div>
    """
  end
end
