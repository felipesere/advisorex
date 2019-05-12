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

  def the(conn, %Advisor.Core.Advice{id: id}) do
    conn
    |> get(Routes.provide_advice_path(@endpoint, :index, id))
  end

  def page_for(conn, %Advisor.Core.Advice{id: id}) do
    conn
    |> get(Routes.provide_advice_path(@endpoint, :create, id))
    |> html_response(200)
  end
end
