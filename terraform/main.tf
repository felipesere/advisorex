provider "heroku" {
  email = "feilpesere@gmail.com"
  api_key = "${var.heroku_api_key}"
}

resource "heroku_app" "web" {
  name = "advisorex"
  region = "eu"
  buildpacks = [
    "https://github.com/HashNuke/heroku-buildpack-elixir.git",
    "https://github.com/gjaldon/heroku-buildpack-phoenix-static.git"
  ]
  config_vars {
    POOL_SIZE = "15"
    SECRET_KEY_BASE = "${random_id.secret_key_base.hex}"
    PASSWORD = "needs-to-be-set-post-mortem"
  }
}

resource "heroku_app_feature" "runtime-dyno-metadata" {
  app = "${heroku_app.web.name}"
  name = "runtime-dyno-metadata"
}

resource "heroku_addon" "database" {
  app = "${heroku_app.web.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "random_id" "secret_key_base" {
  byte_length = 128
}


output "url" {
  value = "${heroku_app.web.web_url}"
}

output "git-url" {
  value = "${heroku_app.web.git_url}"
}
