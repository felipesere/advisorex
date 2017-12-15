use Mix.Config

config :advisor, AdvisorWeb.Endpoint,
  load_from_system_env: true,
  debug_errors: true,
  check_origin: false,
  url: [scheme: "https", host: "advisorex.ngrok.io", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :ueberauth, Ueberauth,
  base_path: "/auth",
  providers: [
    google: {Local.Strategy, [request_path: "/auth/login",
                              callback_path: "/auth/callback"]}
    ]

# Do not print debug messages in production
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :advisor, Advisor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "advisor_dev",
  hostname: "localhost",
  pool_size: 10

