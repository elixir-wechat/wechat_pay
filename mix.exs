defmodule WechatPay.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/linjunpop/wechat_pay"

  def project do
    [
      app: :wechat_pay,
      version: @version,
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: [
        vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
      ],
      name: "WechatPay",
      description: "WechatPay API wrapper in Elixir",
      source_url: @url,
      homepage_url: @url,
      package: package,
      docs: [
        main: "readme", # The main page in the docs
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :poison, :sweet_xml]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:poison, "~> 2.2 or ~> 3.0"},
      {:sweet_xml, "~> 0.6"},
      {:plug, "~> 1.2"},

      {:exvcr, "~> 0.7", only: :test},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:dogma, "~> 0.1", only: :dev},
      {:dialyxir, "~> 0.3", only: :dev},

      {:inch_ex, "~> 0.2", only: :docs},
      {:ex_doc, "~> 0.14", only: [:dev, :docs]}
    ]
  end

  defp package do
    [
      name: :wechat_pay,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Jun Lin"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/linjunpop/wechat_pay"
      }
    ]
  end
end
