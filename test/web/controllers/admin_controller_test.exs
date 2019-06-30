defmodule AdvisorWeb.AdminControllerTest do
  alias Advisor.Test.Support.Users
  alias Advisor.Test.Support.Sample
  use AdvisorWeb.ConnCase
  alias Advisor.People

  test "needs to be authenticated", %{conn: conn} do
    conn = conn
           |> put_req_header("authorization", "Bearer NOT-SECRET")
           |> post("/admin/people", %{name: "a", email: "b"})


    assert response(conn, 401)
  end

  test "creates a new person", %{conn: conn} do
    conn
    |> put_req_header("authorization", "Bearer SECRET")
    |> post("/admin/people", %{name: "Lightning McQueen", email: "lightning@mcqueen.com"})


    assert People.find_by(email: "lightning@mcqueen.com")
  end

  test "updates a person's details", %{conn: conn} do
    felipe = Users.with("Felipe Sere")

    updated_conn = conn
                   |> put_req_header("authorization", "Bearer SECRET")
                   |> put("/admin/people/#{felipe.email}", %{name: "Strange name", email: "foo@bar.com"})


    assert response(updated_conn, 200)
    assert People.find_by(email: "foo@bar.com").id == felipe.id
  end

  test "can delete a person", %{conn: conn} do
    felipe = Users.with("Felipe Sere")

    conn
    |> put_req_header("authorization", "Bearer SECRET")
    |> delete("/admin/people/#{felipe.email}")

    refute People.find(felipe)
  end

  test "can list existing questionnaires", %{conn: conn} do
    Sample.questionnaire(
      mentor: "Felipe Sere",
      mentee: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    Sample.questionnaire(
      mentor: "Uku Taht",
      mentee: "Chris Jordan",
      advisors: ["Nick Dyer", "Jim Suchy"]
    )

    conn =
      conn
      |> put_req_header("authorization", "Bearer SECRET")
      |> get("/admin/questionnaires")

    assert [
             %{"id" => _, "mentee" => "Rabea Gleissner", "mentor" => "Felipe Sere", "advisors" => ["Priya Patil", "Sarah Johnston"]},
             %{"id" => _, "mentee" => "Chris Jordan", "mentor" => "Uku Taht", "advisors" => ["Nick Dyer", "Jim Suchy"]}
           ] = json_response(conn, 200)
  end

  test "can add new advisors to a questionnaire", %{conn: conn} do
    questionnaire = Sample.questionnaire(
      mentor: "Felipe Sere",
      mentee: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    uku = Users.with("Uku Taht")

    conn =
      conn
      |> put_req_header("authorization", "Bearer SECRET")
      |> post("/admin/questionnaires/#{questionnaire.id}/advisors/#{uku.email}")

    assert response(conn, 200)
    assert Advisor.Questionnaire.find(questionnaire) |> advisors() == ["Priya Patil", "Sarah Johnston", uku.name]
  end

  test "can remove advisors from a questionnaire", %{conn: conn} do
    sarah = Users.with("Sarah Johnston")

    questionnaire = Sample.questionnaire(
      mentor: "Felipe Sere",
      mentee: "Rabea Gleissner",
      advisors: ["Priya Patil", "Sarah Johnston"]
    )

    conn =
      conn
      |> put_req_header("authorization", "Bearer SECRET")
      |> delete("/admin/questionnaires/#{questionnaire.id}/advisors/#{sarah.email}")

    assert response(conn, 200)
    assert Advisor.Questionnaire.find(questionnaire) |> advisors() == ["Priya Patil"]
  end

  def advisors(q) do
    Enum.map(q.advice, fn a -> a.advisor.name end)
  end

  test "failures are reported", %{conn: conn} do
    response = conn
               |> put_req_header("authorization", "Bearer SECRET")
               |> post("/admin/people", %{nme: "Lightning McQueen"})
               |> json_response(400)

    assert response == %{"email" => "can't be blank", "name" => "can't be blank"}
  end
end
