defmodule SorteiosWeb.PrizesLive.Show do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_user_optional}

  def mount(%{"id" => id}, _session, socket) do
    current_user = socket.assigns.current_user

    {:ok, rifa} = Sorteios.Prizes.get_rifa(id, actor: current_user)

    {:ok, tickets} =
      Sorteios.Prizes.list_tickets_from_rifa(rifa.id, actor: current_user)

    socket =
      socket
      |> assign(:page_title, rifa.name)
      |> assign(:rifa, rifa)
      |> assign(:tickets, tickets)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="container mx-auto px-4 py-8 max-w-4xl">
        <div class="card bg-base-100 shadow-xl">
          <div class="card-body">
            <div class="flex items-center gap-2 mb-4">
              <div class="badge badge-primary badge-lg">Rifa Ativa</div>
              <div class="badge badge-primary badge-lg">{@rifa.owener.email}</div>

              <div class="badge badge-info badge-lg">
                <.tickets_list tickets={@tickets} />
              </div>
            </div>

            <h1 class="card-title text-4xl font-bold mb-4">
              {@rifa.name}
            </h1>

            <div class="divider"></div>

            <div class="prose max-w-none">
              <h2 class="text-xl font-semibold mb-3">Descrição</h2>
              <p class="text-base-content/80 text-lg leading-relaxed">
                {@rifa.description}
              </p>
            </div>

            <div class="divider"></div>

            <div class="card-actions justify-end mt-4">
              <.button
                :if={Sorteios.Prizes.can_create_ticket?(@current_user)}
                phx-click="participate"
              >
                <.icon name="hero-ticket" class="w-5 h-5 mr-2" /> Participar da Rifa
              </.button>
              <button class="btn btn-outline btn-lg">
                Compartilhar
              </button>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def tickets_list(assigns) do
    ~H"""
    <div>
      <.icon name="hero-ticket" class="w-6 h-6 inline-block mr-2" />
      {length(@tickets)}
    </div>
    """
  end

  def handle_event("participate", _value, socket) do
    IO.inspect(socket.assigns.rifa.id, label: "RIFA ID")

    IO.inspect(socket.assigns.current_user.id, label: "USER ID")

    case Sorteios.Prizes.create_ticket(
           %{
             user_id: socket.assigns.current_user.id,
             rifa_id: socket.assigns.rifa.id
           },
           actor: socket.assigns.current_user
         ) do
      {:ok, _ticket} ->
        {:noreply,
         socket
         |> put_flash(:info, "Você participou da rifa com sucesso!")}

      {:error, error} ->
        {:noreply,
         socket
         |> put_flash(:error, "Erro ao participar da rifa: #{inspect(error)}")}
    end
  end
end
