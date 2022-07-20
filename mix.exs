defmodule Advisor.Mixfile do
  use Mix.Project

  def project do
    [
      app: :advisor,
      version: "0.0.1",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [
        tool: ExCoveralls
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Advisor.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :bcrypt_elixir]
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
      {:hackney, "~> 1.18"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_live_view, "~> 0.17.11"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:poison, "~> 5.0"},
      {:scribe, "~> 0.10.0"},
      {:yaml_elixir, "~> 2.1"},
      {:bamboo, "~> 2.2"},
      {:bamboo_phoenix, "1.0.0"},
      {:swoosh, "~> 1.3"},
      {:bcrypt_elixir, "~> 3.0"}
    ] ++ test_deps()
  end

  defp test_deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10.0", only: :test},
      {:floki, "~> 0.18", only: :test},
      {:dialyxir, "~> 0.5.1"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create --quiet", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      ci: ["test", "credo", "coveralls.travis"],
      seed: ["run priv/repo/seeds.exs"],
      "seed.questionnaire": ["run priv/repo/seed-questionnaire.exs"]
    ]
  end
end
