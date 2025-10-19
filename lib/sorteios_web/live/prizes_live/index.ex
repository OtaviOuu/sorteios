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
        <.status_badge status={@rifa.status} />
      </td>
    </tr>
    """
  end

  def prizes_table(assigns) do
    ~H"""
    <div class="card bg-base-100 shadow-xl">
      <div class="card-body">
        <div class="flex items-center justify-between mb-4">
          <h2 class="card-title text-2xl">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-7 w-7"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 8v13m0-13V6a2 2 0 112 2h-2zm0 0V5.5A2.5 2.5 0 109.5 8H12zm-7 4h14M5 12a2 2 0 110-4h14a2 2 0 110 4M5 12v7a2 2 0 002 2h10a2 2 0 002-2v-7"
              />
            </svg>
            Rifas Disponíveis
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
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"
                      />
                    </svg>
                    Nome da Rifa
                  </div>
                </th>
                <th class="text-base">
                  <div class="flex items-center gap-2">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 6h16M4 12h16M4 18h7"
                      />
                    </svg>
                    Descrição
                  </div>
                </th>
                <th class="text-base">Status</th>
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
end
