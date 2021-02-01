defmodule FileuploadTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :fileupload_test,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FileuploadTest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_upload, "~> 0.1"},
      {:cors_plug, "~> 2.0"},
      {:jason, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      dev: ["run --no-halt"],
      app: ["cmd yarn --cwd ./app start"]
    ]
  end
end
