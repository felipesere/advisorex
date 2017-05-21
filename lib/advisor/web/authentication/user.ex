defmodule Advisor.Web.Authentication.User do

  def of(conn) do
    conn.assigns[:user]
  end
end
