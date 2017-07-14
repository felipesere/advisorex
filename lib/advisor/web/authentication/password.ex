defmodule Advisor.Web.Authentication.Password do
  def matches?(attempt) do
    [password: password] = Application.get_env(:advisor, __MODULE__)

    attempt == password
  end
end
