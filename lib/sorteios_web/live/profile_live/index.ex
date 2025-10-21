defmodule SorteiosWeb.ProfileLive.Index do
  use SorteiosWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="p-4">
        <h1 class="text-2xl font-bold mb-4">Perfil</h1>
        <p class="text-lg">Bem-vindo, <strong>{@current_user.email}</strong>!</p>
        <p class="text-lg">Você tem <strong>{@current_user.credits}</strong> créditos.</p>
      </div>
    </Layouts.app>
    """
  end
end
