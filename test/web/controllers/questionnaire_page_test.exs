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

    number_of_group_lead = 4
    assert response
             |> Floki.find(".group-lead")
             |> length == number_of_group_lead

    number_of_advisors = 23
    assert response
             |> Floki.find(".advisor")
             |> length == number_of_advisors

    assert response
             |> Floki.find(".question-picker li")
             |> length == 16
  end
end
