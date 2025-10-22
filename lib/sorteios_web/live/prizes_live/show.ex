defmodule SorteiosWeb.PrizesLive.Show do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_user_optional}

  def mount(%{"id" => id}, _session, socket) do
    current_user = socket.assigns.current_user
    {:ok, rifa} = Sorteios.Prizes.get_rifa(id, actor: current_user)
    {:ok, tickets} = Sorteios.Prizes.list_tickets_from_rifa(rifa.id, actor: current_user)

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
      <div class="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 text-white py-20">
        <div class="absolute inset-0 bg-black/30"></div>

        <div class="relative container mx-auto px-6 max-w-4xl text-center">
          <h1 class="text-5xl font-extrabold tracking-tight mb-4 drop-shadow-lg">
            {@rifa.name}
          </h1>
          <p class="text-lg opacity-90 max-w-2xl mx-auto">
            {@rifa.description}
          </p>

          <div class="flex flex-wrap justify-center gap-3 mt-8">
            <span class="bg-white/10 backdrop-blur-md px-5 py-2 rounded-full text-sm font-medium border border-white/20">
              Rifa Ativa
            </span>
            <span class="bg-white/10 backdrop-blur-md px-5 py-2 rounded-full text-sm font-medium border border-white/20">
              {@rifa.owener.email}
            </span>
            <span class="bg-white/10 backdrop-blur-md px-5 py-2 rounded-full text-sm font-medium border border-white/20 flex items-center gap-2">
              <.icon name="hero-ticket" class="w-4 h-4" /> {length(@tickets)} tickets
            </span>
          </div>
        </div>
      </div>

      <div class="bg-base-100 py-16">
        <div class="container mx-auto px-6 max-w-3xl">
          <div class="flex flex-col sm:flex-row justify-center sm:justify-between gap-4 mt-8">
            <.button
              :if={Sorteios.Prizes.can_create_ticket?(@current_user)}
              data-action="confetti"
              phx-click="participate"
              class="btn btn-primary btn-lg gap-2 font-semibold w-full sm:w-auto"
            >
              <.icon name="hero-ticket" class="w-5 h-5" /> Participar da Rifa
            </.button>

            <button class="btn btn-outline btn-lg gap-2 font-semibold w-full sm:w-auto">
              <.icon name="hero-share" class="w-5 h-5" /> Compartilhar
            </button>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("participate", _value, socket) do
    case Sorteios.Prizes.create_ticket(
           %{user_id: socket.assigns.current_user.id, rifa_id: socket.assigns.rifa.id},
           actor: socket.assigns.current_user
         ) do
      {:ok, _ticket} ->
        # ???
        user = socket.assigns.current_user
        Sorteios.Accounts.consume_credit(user, actor: user)

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
