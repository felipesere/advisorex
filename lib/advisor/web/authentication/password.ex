defmodule Advisor.Web.Authentication.Password do
  alias Comeonin.Bcrypt
  def matches?(password) do
    [checker: checker, password: real_hash] = Application.get_env(:advisor, __MODULE__)

    checker.matches?(password, real_hash)
  end

  defmodule HashedPassword do
    def matches?(password, hash) do
      Bcrypt.checkpw(password, hash)
    end
  end

  defmodule SimplePassword do
    def matches?(password, hash) do
      password == hash
    end
  end
end
