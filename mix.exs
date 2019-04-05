defmodule Advisor.Mixfile do
  use Mix.Project

  def project do
    [
      app: :advisor,
      version: "0.0.1",
      elixir: "~> 1.8.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Advisor.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :ueberauth, :ueberauth_google]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps() do
    [
      {:apex, "~> 1.0"},
      {:csv, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:jason, "~> 1.1.0"},
      {:phoenix, "~> 1.4.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:yaml_elixir, "~> 2.1"},
      {:ueberauth_google, "~> 0.8.0"},
      {:guardian, "~> 1.0"},
      {:bamboo, "~> 1.2.0"},
      {:poison, "~> 3.0"}
    ] ++ test_deps()
  end

  defp test_deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_unit_notifier, "~> 0.1.3", only: :test},
      {:excoveralls, "~> 0.10.0", only: :test},
      {:floki, "~> 0.18", only: :test},
      {:mix_test_watch, "~> 0.4"},
      {:dialyxir, "~> 0.5.1"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      ci: ["test", "credo"],
      seed: ["run priv/repo/seeds.exs"]
    ]
  end
end
