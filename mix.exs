defmodule WechatPay.Mixfile do
  use Mix.Project

  @version "0.7.0"
  @url "https://github.com/linjunpop/wechat_pay"

  def project do
    [
      app: :wechat_pay,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ],
      name: "WechatPay",
      description: "WechatPay API wrapper in Elixir",
      source_url: @url,
      homepage_url: @url,
      package: package(),
      docs: docs(),
      dialyzer: [
        plt_add_apps: [:mix, :plug, :xmerl, :poison]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger, :xmerl]]
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
      {:httpoison, "~> 0.9 or ~> 1.0"},

      # Optional
      {:plug, "~> 1.2", optional: true},

      # Dev
      {:poison, "~> 4.0", only: [:dev, :test, :docs], override: true},
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:exvcr, "~> 0.7", only: :test},

      # Docs
      {:inch_ex, "~> 1.0", only: :docs},
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "getting-started",
      extras: [
        "docs/Getting Started.md",
        "docs/Phoenix.md",
        "docs/Configuration.md"
      ],
      groups_for_modules: [
        "Payment methods": [
          ~r"WechatPay.App",
          ~r"WechatPay.JSAPI",
          ~r"WechatPay.Native"
        ],
        Plug: [~r"WechatPay.Plug", WechatPay.Handler],
        Utils: ~r"WechatPay.Utils",
        Others: [WechatPay.JSON]
      ]
    ]
  end
end
