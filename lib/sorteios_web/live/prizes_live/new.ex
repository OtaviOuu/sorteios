defmodule SorteiosWeb.PrizesLive.New do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_admin_required}

  def mount(_params, _session, socket) do
    create_rifa_form =
      Sorteios.Prizes.form_to_create_rifa(actor: socket.assigns.current_user) |> to_form()

    socket =
      socket
      |> assign(:form, create_rifa_form)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <h1 class="text-2xl font-bold mb-4">New Rifa</h1>
      <.form for={@form} phx-submit="create" phx-change="validate">
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:description]} label="Description" />

        <.button phx-disable-with="Submitting...">Submit</.button>
      </.form>
    </Layouts.app>
    """
  end

  def handle_event("validate", %{"form" => rifa_params}, socket) do
    {:noreply,
     update(socket, :form, fn form ->
       AshPhoenix.Form.validate(form, rifa_params)
     end)}
  end

  def handle_event("create", %{"form" => rifa_params}, socket) do
    case Sorteios.Prizes.create_rifa(
           rifa_params,
           actor: socket.assigns.current_user
         ) do
      {:ok, rifa} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rifa '#{rifa.name}' created successfully.")
         |> push_navigate(to: ~p"/prizes")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:form, to_form(changeset))}
    end
  end
end
