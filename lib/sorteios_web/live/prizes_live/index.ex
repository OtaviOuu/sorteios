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
      <%= if length(@rifas) > 0 do %>
        <.prizes_table rifas={@rifas} />
      <% else %>
        <div class="text-sm opacity-60">
          Nenhuma rifa ai é foda
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  def row(assigns) do
    ~H"""
    <tr class="hover:bg-gray-100" phx-click={JS.navigate(~p"/prizes/#{@rifa}")}>
      <td>
        <div class="flex items-center gap-3">
          <div class="avatar placeholder">
            <div class="bg-primary text-primary-content rounded-full w-12">
              <span class="text-xl font-bold">{@rifa.name}</span>
            </div>
          </div>
          <div>
            <div class="font-bold text-lg">{@rifa.name}</div>
            <div class="text-sm opacity-50 badge badge-ghost badge-sm">Rifa Ativa</div>
          </div>
        </div>
      </td>
      <td>
        <div class="max-w-md">
          <p class="text-base-content/80 line-clamp-2">{@rifa.description}</p>
        </div>
      </td>
      <td>
        <div class="max-w-md">
          <p class="text-base-content/80 line-clamp-2">{format_datetime(@rifa.inserted_at)}</p>
        </div>
      </td>
      <td>
        <.status_badge status={@rifa.status} />
      </td>
    </tr>
    """
  end

  def prizes_table(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-md">
      <div class="card-body">
        <div class="flex items-center justify-between mb-4">
          <h2 class="card-title text-2xl">
            <.icon name="hero-gift" class="h-6 w-6 mr-2" /> Rifas Disponíveis
          </h2>
          <div class="badge badge-primary badge-lg">{length(@rifas)} rifas</div>
        </div>

        <div class="divider mt-0"></div>

        <div class="overflow-x-auto">
          <table class="table">
            <thead>
              <tr>
                <th class="text-base">
                  <div class="flex items-center gap-2">
                    Nome da Rifa
                  </div>
                </th>
                <th class="text-base">
                  <div class="flex items-center gap-2">
                    Descrição
                  </div>
                </th>
                <th class="text-base">
                  <div class="flex items-center gap-2">
                    Created At
                  </div>
                </th>
                <th class="text-base">
                  <div class="flex items-center gap-2">
                    Status
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
              <.row :for={rifa <- @rifas} rifa={rifa} />
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def status_badge(assigns) do
    ~H"""
    <div>
      <div class="badge badge-success badge-lg">{@status}</div>
    </div>
    """
  end

  def handle_info(%Phoenix.Socket.Broadcast{topic: "prize"}, socket) do
    {:ok, new_rifas} = Sorteio.Prizes.list_rifas()
    {:noreply, assign(socket, :rifas, new_rifas)}
  end

  defp format_datetime(datetime) do
    datetime
    |> Calendar.strftime("%d/%m/%Y %H:%M")
  end
end
