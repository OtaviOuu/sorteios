defmodule SorteiosWeb.PrizesLive.Index do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_user_optional}

  def mount(_params, _session, socket) do
    if connected?(socket) do
      SorteiosWeb.Endpoint.subscribe("prize")
    end

    {:ok, rifas} = Sorteios.Prizes.list_rifas()
    IO.inspect(rifas, label: "Rifas na live view")

    {:ok, assign(socket, :rifas, rifas)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1 class="text-2xl font-bold mb-4">Prizes</h1>
      <.button
        :if={Sorteios.Prizes.can_create_rifa?(@current_user)}
        phx-click={JS.navigate(~p"/prizes/new")}
      >
        Create New Rifa
      </.button>
      <%= if length(@rifas) > 0 do %>
        <Cinder.Table.table
          resource={Sorteios.Prizes.Rifa}
          actor={@current_user}
          filters_label="Search Rifas"
          row_click={fn rifa -> JS.navigate(~p"/prizes/#{rifa.id}") end}
        >
          <:col :let={rifa} field="name" filter sort>{rifa.name}</:col>
          <:col :let={rifa} field="description" filter>{rifa.description}</:col>
          <:col :let={rifa} field="status" filter>{rifa.status}</:col>
          <:col :let={rifa} field="creator" filter>{rifa.owener.email}</:col>
        </Cinder.Table.table>
      <% else %>
        <div class="text-sm opacity-60">
          Nenhuma rifa ai é foda
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "prize"}, socket) do
    {:ok, new_rifas} = Sorteios.Prizes.list_rifas()
    {:noreply, assign(socket, :rifas, new_rifas)}
  end
end
