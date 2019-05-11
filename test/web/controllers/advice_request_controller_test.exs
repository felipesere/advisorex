defmodule AdvisorWeb.AdviceRequestControllerTest do
  use AdvisorWeb.ConnCase
  alias Advisor.Test.Support.Users

  test "creates the proper questionnaire", %{conn: conn} do
    felipe = Users.with("Felipe Sere")
    cj = Users.with("Chris Jordan")

    proposal = %{
      :group_lead => Integer.to_string(felipe.id),
      :advisors => %{Integer.to_string(cj.id) => "true"},
      :questions => %{"13" => "true"}
    }

    conn =
      conn
      |> Login.as("Felipe Sere")
      |> post("/request", proposal: proposal)

    response = html_response(conn, 200)

    assert response |> Floki.find("h1") |> Floki.text() == "Here are your links"
    assert response |> Floki.find(".individual") |> Enum.count() == 1
    assert advice_link(response)
  end

  def advice_link(html) do
    html
    |> Floki.find(".see-advice-link")
    |> Floki.text()
  end

  test "redirects unauthenticated user request", %{conn: conn} do
    conn = post conn, "/request", []

    assert redirected_to(conn) == "/"
  end
end
