defmodule SorteiosWeb.ErrorJSONTest do
  use SorteiosWeb.ConnCase, async: true

  test "renders 404" do
    assert SorteiosWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert SorteiosWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
