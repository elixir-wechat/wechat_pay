# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :wechat_pay, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:wechat_pay, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).

use Mix.Config

config :plug, :validate_header_keys_during_test, true

config :wechat_pay, MyPay,
  env: :sandbox,
  appid: "wx8888888888888888",
  mch_id: "1900000109",
  apikey: "192006250b4c09247ec02edce69f6a2d",
  ssl_cacert: File.read!("fixture/certs/rootca.pem"),
  ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
  ssl_key: File.read!("fixture/certs/apiclient_key.pem")

