import Config

config :ulidex,
  rand_bytes: &:crypto.strong_rand_bytes/1

import_config "#{config_env()}.exs"
