defmodule WechatPay.Mixfile do
  use Mix.Project

  @version "0.9.0"
  @url "https://github.com/elixir-wechat/wechat_pay"

  def project do
    [
      app: :wechat_pay,
      name: "WechatPay",
      version: @version,
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        docs: :docs,
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ],
      dialyzer: [
        plt_add_apps: [:mix, :plug, :xmerl, :poison]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger, :xmerl]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.9 or ~> 1.0"},

      # Optional
      {:plug, "~> 1.2", optional: true},

      # Dev
      {:poison, "~> 5.0", only: [:dev, :test, :docs]},
      {:jason, "~> 1.0", only: [:dev, :test, :docs]},
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:exvcr, "~> 0.7", only: :test},

      # Docs
      {:inch_ex, "~> 2.0", only: :docs},
      {:ex_doc, ">= 0.0.0", only: [:dev, :docs]}
    ]
  end

  defp package do
    [
      name: :wechat_pay,
      description: "WechatPay API wrapper in Elixir",
      files: ["lib", "mix.exs", "README*", "LICENSE.md", "CHANGELOG.md"],
      maintainers: ["Jun Lin"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/wechat_pay/changelog.html",
        "GitHub" => @url
      }
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"],
        "guides/using_with_phoenix.md": []
      ],
      main: "readme",
      homepage_url: @url,
      source_url: @url,
      source_ref: "master",
      formatters: ["html"],
      groups_for_modules: [
        "Payment methods": [
          ~r"WechatPay.App",
          ~r"WechatPay.JSAPI",
          ~r"WechatPay.Native"
        ],
        Plug: [~r"WechatPay.Plug"],
        Utils: ~r"WechatPay.Utils",
        Others: [WechatPay.JSON]
      ]
    ]
  end
end
