defmodule Advisor.Web.ProvideAdviceControllerTest do
  use Advisor.Web.ConnCase

  @tag :pending
  test "renders the form", %{conn: conn} do
    conn = conn
           |> login_as(11)
           |> get("/provide/5d83604c-c55b-4725-a529-91a24b01014c") 
    response = html_response(conn, 200)

    assert Floki.find(response, "h1") |> Floki.text == "Here's the advice form"
  end

  def login_as(conn, id) do
    assign(conn, :user_id, id)
  end
end
