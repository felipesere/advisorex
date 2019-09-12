defmodule Visit do
  use Phoenix.ConnTest
  alias AdvisorWeb.Router.Helpers, as: Routes

  # The default endpoint for testing
  @endpoint AdvisorWeb.Endpoint

  def the(conn, :landing_page) do
    conn
    |> get("/")
    |> html_response(200)
  end

  def the(conn, :dashboard) do
    conn
    |> get("/dashboard")
    |> html_response(200)
  end

  def the(conn, :create_questionnaire) do
    conn
    |> get("/request")
    |> html_response(200)
  end

  def the(conn, page, id) do
    conn
    |> Visit.the!(page, id)
    |> html_response(200)
  end

  def the!(conn, :questionnaire, id) do
    conn
    |> get(Routes.present_page_path(@endpoint, :index, id))
  end

  def the!(conn, :progress, id) do
    conn
    |> get(Routes.progress_page_path(@endpoint, :index, id))
  end

  def provide_advice_to!(conn, param) do
    conn
    |> provide_advice_to(param)
    |> html_response(200)
  end

  def provide_advice_to(conn, %Advisor.Questionnaire{id: id}) do
    conn
    |> get(Routes.provide_advice_path(@endpoint, :create, id))
  end
end
