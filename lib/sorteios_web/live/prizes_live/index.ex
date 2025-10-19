defmodule SorteiosWeb.PrizesLive.Index do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_user_optional}

  def mount(_params, _session, socket) do
    if connected?(socket) do
      SorteiosWeb.Endpoint.subscribe("prize")
    end

    {:ok, rifas} = Sorteio.Prizes.list_rifas()

    {:ok, assign(socket, :rifas, rifas)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1 class="text-2xl font-bold mb-4">Prizes</h1>
      <.button
        :if={Sorteio.Prizes.can_create_rifa?(@current_user)}
        phx-click={JS.navigate(~p"/prizes/new")}
      >
        Create New Rifa
      </.button>
      <.prizes_table rifas={@rifas} />
    </Layouts.app>
    """
  end

  def prizes_table(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <tr :for={rifa <- @rifas}>
            <td>{rifa.name}</td>
            <td>{rifa.description}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "prize"}, socket) do
    {:ok, new_rifas} = Sorteio.Prizes.list_rifas()
    {:noreply, assign(socket, :rifas, new_rifas)}
  end
end
