defmodule SorteiosWeb.PageController do
  use SorteiosWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
