defmodule Advisor.Web.Authentication.Password do
  alias Comeonin.Bcrypt
  def matches?(password) do
    [checker: checker, password: hashed_password] = Application.get_env(:advisor, __MODULE__)

    checker.matches?(password, hashed_password)
  end

  defmodule HashedPassword do
    def matches?(password, hashed_password) do
      Bcrypt.checkpw(password, hashed_password)
    end
  end

  defmodule SimplePassword do
    def matches?(password, hashed_password) do
      password == hashed_password
    end
  end
end
