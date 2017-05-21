defmodule Advisor.Web.RequestAdviceControllerTest do
  use Advisor.Web.ConnCase

  test "creates the proper questionnaire", %{conn: conn} do
    conn = post conn, "/request", [group_lead: "11", people: %{"4" => "on"}, questions:  %{"13" => "on"}]

    response = html_response(conn, 200)

    assert Floki.find(response, "h1") |> Floki.text == "Here are your links"
  end
end
