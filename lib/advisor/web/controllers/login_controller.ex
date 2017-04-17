defmodule Advisor.Web.LoginController do
  use Advisor.Web, :controller
  alias Advisor.Core.People

  def index(conn, %{"email" => email}) do
    user = People.find_by(email: email)

    if user do
      conn
      |> put_resp_cookie("user", "#{user.id}")
      |> redirect(to: "/request")
    else
      conn
      |> redirect(to: "/")
    end
  end
end
