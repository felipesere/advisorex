defmodule Advisor.Web.LandingPageTest do
  use Advisor.Web.ConnCase

  test "Hit the landing page", %{conn: conn} do
    conn = get conn, "/"
    response = html_response(conn, 200)

    assert Floki.find(response, "h1") |> Floki.text == "Advisor"
    assert Floki.find(response, "button") |> Floki.text == "Ask for advice"
  end
end
