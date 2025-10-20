defmodule SorteiosWeb.PrizesLive.Show do
  use SorteiosWeb, :live_view

  def mount(%{"id" => id}, _session, socket) do
    {:ok, rifa} = Sorteio.Prizes.get_rifa(id, actor: socket.assigns.current_user)
    IO.inspect(rifa, label: "Rifa encontrada")

    socket =
      socket
      |> assign(:page_title, rifa.name)
      |> assign(:rifa, rifa)

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
              <button class="btn btn-primary btn-lg">
                <.icon name="hero-ticket" class="w-5 h-5 mr-2" /> Participar da Rifa
              </button>
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
end
