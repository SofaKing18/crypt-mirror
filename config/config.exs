# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rocket_crypt,
  ecto_repos: [RocketCrypt.Repo]

# Configures the endpoint
config :rocket_crypt, RocketCryptWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "faBXLFMqvncPbtgmz5xK0EdSpYiRZvoQ2WsgmhEZBaljONvtvIlD3Z4u5vDsYycy",
  render_errors: [view: RocketCryptWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RocketCrypt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
