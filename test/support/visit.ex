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

  def provide_advice_to!(conn, param) do
    conn
    |> provide_advice_to(param)
    |> html_response(200)
  end

  def provide_advice_to(conn, %Advisor.Core.Questionnaire{id: id}) do
    conn
    |> get(Routes.provide_advice_path(@endpoint, :create, id))
  end
end
