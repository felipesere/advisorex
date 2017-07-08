defmodule Advisor.Web.LandingPageTest do
  use Advisor.Web.ConnCase
  import PageAssertions

  test "Hit the landing page", %{conn: conn} do
    conn = get conn, "/"
    response = html_response(conn, 200)

    response
    |> has_title("Advisor")
    |> has_buttons(["Ask for advice", "Go to your Dashboard"])
  end

  def has_buttons(html, buttons) do
    assert html |> Floki.find("button") |> Enum.map(&Floki.text/1) == buttons
    html
  end
end
