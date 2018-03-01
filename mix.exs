defmodule ISOBMFFLang.Mixfile do
  use Mix.Project

  def project do
    [
      app: :isobmff_lang,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "ISOBMFF language unpacker",
      source_url: "https://github.com/Litterfeldt/elixir-isobmff-language-unpacker"
    ]
  end

  def application, do: [extra_applications: []]

  defp description() do
    "Elixir lib that unpacks MP4 and MOV 16 bit language representations into ISO639-2/T language codes."
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Karl Litterfeldt"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/Litterfeldt/elixir-isobmff-language-unpacker"}
    ]
  end

  defp deps, do: []
end
