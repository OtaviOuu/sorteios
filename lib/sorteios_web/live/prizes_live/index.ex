defmodule SorteiosWeb.PrizesLive.Index do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_user_optional}

  def mount(_params, _session, socket) do
    if connected?(socket) do
      SorteiosWeb.Endpoint.subscribe("prize")
    end

    {:ok, rifas} = Sorteios.Prizes.list_rifas()

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
        <.table
          id="prizes"
          rows={@rifas}
          row_click={fn rifa -> JS.navigate(~p"/prizes/#{rifa.id}") end}
        >
          <:col :let={rifa} label="Name">
            <.link navigate={~p"/prizes/#{rifa.id}"}>{rifa.name}</.link>
          </:col>
          <:col :let={rifa} label="Description">
            {rifa.description}
          </:col>
          <:col :let={rifa} label="Owner">
            {rifa.owener.email} - <span class={style_role(rifa.owener.role)}>{rifa.owener.role}</span>
          </:col>
          <:col :let={rifa} label="Created At">
            {format_datetime(rifa.inserted_at)}
          </:col>
          <:col :let={rifa} label="Status">
            {rifa.status}
          </:col>
        </.table>
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

  defp format_datetime(datetime) do
    datetime
    |> Calendar.strftime("%d/%m/%Y %H:%M")
  end

  defp style_role(:admin), do: "badge badge-accent"
  defp style_role(:user), do: "badge badge-primary"
  defp style_role(_), do: "badge badge-secondary"
end
