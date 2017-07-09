defmodule Advisor.Web.RequestPageTest do
  use Advisor.Web.ConnCase

  test "cannot request advice if not authenticated", %{conn: conn} do
    conn = get conn, "/request"

    assert redirected_to(conn) == "/"
  end

  test "sees the page to create a questionnaire", %{conn: conn} do
    conn = conn
           |> put_req_cookie("user", "11")
           |> get("/request")

    response = html_response(conn, 200)

    assert response
             |> Floki.find("h1")
             |> Enum.at(0)
             |> Floki.text == "Hello Felipe Sere!"

    # maybe split this later into group_lead and advisor
    assert response
             |> Floki.find(".people-picker li")
             |> length == 27

    assert response
             |> Floki.find(".question-picker li")
             |> length == 16
  end
end
