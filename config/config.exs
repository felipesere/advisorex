# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :advisor,
  ecto_repos: [Advisor.Repo]

# Configures the endpoint
config :advisor, AdvisorWeb.Endpoint,
  url: [host: "localhost"],
  static_url: [path: "/assets"],
  secret_key_base: "SmmWRTx2vhEgHIcQ/7BRuQaIuvQ7fSeTrsFVuPsudiHKtD0AT068LXD61mN5Ow+d",
  render_errors: [view: AdvisorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Advisor.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

if Mix.env == :dev do
  config :mix_test_watch, clear: true
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
