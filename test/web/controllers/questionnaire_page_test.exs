defmodule Advisor.Web.RequestPageTest do
  use Advisor.Web.ConnCase
  alias Advisor.Core.{People, Questions}

  @myself 1

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

    number_of_group_lead = length(People.group_leads()) - @myself
    assert response
             |> Floki.find(".group-lead")
             |> length == number_of_group_lead

    number_of_advisors = length(People.everybody()) - @myself
    assert response
             |> Floki.find(".advisor")
             |> length == number_of_advisors

    number_of_questions = Questions.all |> flatten |> length
    assert response
             |> Floki.find(".question-picker li")
             |> length == number_of_questions
  end

  defp flatten(%{client: c, technical: t, community: co}), do: c ++ t ++ co
end
