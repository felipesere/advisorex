defmodule AdvisorWeb.AdviceRequestControllerTest do
  use AdvisorWeb.ConnCase

  test "creates the proper questionnaire", %{conn: conn} do
    proposal = %{:group_lead => "11",
                 :advisors => %{"4" => "true"},
                 :questions =>  %{"13" => "true"}}
    conn = conn
           |> ThroughTheWeb.login_as(11)
           |> post("/request", [proposal: proposal])

    response = html_response(conn, 200)

    assert response |> Floki.find("h1") |> Floki.text == "Here are your links"
    assert response |> Floki.find(".individual") |> Enum.count == 1
    assert advice_link(response) =~ "/progress/"
  end

  def advice_link(html) do
    html
    |> Floki.find(".see-advice-link")
    |> Floki.text
  end

  test "redirects unauthenticated user request", %{conn: conn} do
    conn = post conn, "/request", []

    assert redirected_to(conn) == "/"
  end
end
