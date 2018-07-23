# Locale

Library that provide several things:

- How is a locale named in its native tongue (`en-US` is "American English", `fr-CA` is "Français canadien")
- What is the reading direction of the language of a locale (left to right or right to left)
- Is a string that looks that a locale really a locale

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `locale_names` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:locale_names, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/locale_names](https://hexdocs.pm/locale_names).

## Usage

`locale?(string)` will return a boolean if the locale is correct
`locale(locale)` will return a struct that look like this:

```elixir
%Locale{
  locale: "fr-CA",
  name: "Français canadien",
  direction: :left_to_right
}
```
