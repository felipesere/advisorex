# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :phoenix,
  json_library: Jason

# General application configuration
config :advisor,
  ecto_repos: [Advisor.Repo]

# Configures the endpoint
config :advisor, AdvisorWeb.Endpoint,
  url: [host: "localhost"],
  static_url: [path: "/assets"],
  secret_key_base: "SmmWRTx2vhEgHIcQ/7BRuQaIuvQ7fSeTrsFVuPsudiHKtD0AT068LXD61mN5Ow+d",
  render_errors: [view: AdvisorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Advisor.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  base_path: "/auth",
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [
         request_path: "/auth/login",
         callback_path: "/auth/callback",
         hd: "8thlight.com",
         default_scope: "email profile"
       ]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  json_library: Jason

config :advisor, Advisor.Core.Notifications.Email.Mailer,
  adapter: Bamboo.SendgridAdapter,
  api_key: System.get_env("SENDGRID_API_KEY")

config :advisor, FeatureToggle, emails: [only: ["Felipe Seré", "Rabea Gleissner"]]

if Mix.env() == :test do
  config :mix_test_watch, clear: true
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
