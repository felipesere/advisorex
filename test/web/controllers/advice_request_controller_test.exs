defmodule Advisor.Web.AdviceRequestControllerTest do
  use Advisor.Web.ConnCase
  alias Advisor.Web.ProvideAdviceController

  test "creates the proper questionnaire", %{conn: conn} do
    proposal = %{:group_lead => "11",
                 :advisors => %{"4" => "true"},
                 :questions =>  %{"13" => "true"}}
    conn = conn
           |> login_as(11)
           |> post("/request", [proposal: proposal])

    response = html_response(conn, 200)

    assert response |> Floki.find("h1") |> Floki.text == "Here are your links"
    assert response |> Floki.find(".individual") |> Enum.count == 1
    assert response |> Floki.find(".see-advice-link") |> Floki.text =~ "/progress/"
  end

  test "transforms params into database compatible answers" do
    params = %{
      "1" => "answer_1",
      "2" => "answer_2",
      "_csrf_token" => "token",
      "id" => "id"
    }
    [ %{ advice_request_id: advice_request_id_1,
        answer: answer_1,
        question_id: question_id_1 },
      %{ advice_request_id: advice_request_id_2,
        answer: answer_2,
        question_id: question_id_2 } | _] = ProvideAdviceController.all_answers(params)

    assert advice_request_id_1 == "id"
    assert answer_1== "answer_1"
    assert question_id_1 == 1
    assert advice_request_id_2 == "id"
    assert answer_2 == "answer_2"
    assert question_id_2 == 2
  end

  test "redirects unauthenticated user request", %{conn: conn} do
    conn = post conn, "/request", []

    assert redirected_to(conn) == "/"
  end
end
