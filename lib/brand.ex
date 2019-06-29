defmodule Brand do
  defp settings(), do: Application.get_env(:advisor, Brand, [])
  def icon(), do:  settings() |> Keyword.get(:icon, "")

  def logo(), do: settings() |> Keyword.get(:logo, "")

  def logo_alt(), do: settings() |> Keyword.get(:alt, "")
end
